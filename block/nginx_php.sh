#!/usr/bin/env bash

# nginx server block
cat <<EOF > $nginx_server_block
server {
        listen 80;
        listen [::]:80;

        # SSL configuration
        ${sslon}listen 443 ssl default_server;
        ${sslon}listen [::]:443 ssl default_server;

        # Project directory
        root $path;

        # Add index.php to the list if you are using PHP
        index $index;

        # Root domain
        server_name ${domain}${TLD} www.${domain}${TLD};

        location / {
                # First attempt to serve request as file, then as directory, then fall back to displaying a 404.
                try_files $(echo '$uri') $(echo '$uri')/ =404;
        }

        # Pass PHP scripts to FastCGI server
        location ~ \.php$ {
                include snippets/fastcgi-php.conf;
                # With php-fpm (or other unix sockets):
                fastcgi_pass unix:/run/php/php${version}-fpm.sock;
                # With php-cgi (or other tcp sockets):
                #fastcgi_pass 127.0.0.1:9000;
        }

        # Certbot
        location ~ /.well-known {
                allow all;
        }
}
EOF