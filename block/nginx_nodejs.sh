#!/usr/bin/env bash

# nginx server block
cat <<EOF > $nginx_server_block
server {
        listen 80;
        listen [::]:80;

        # SSL configuration
        ${sslon}listen 443 ssl default_server;
        ${sslon}listen [::]:443 ssl default_server;

        # Root domain
        server_name ${domain}${TLD} www.${domain}${TLD};

        location / {
                # Reverse proxy for NodeJS
                proxy_set_header X-Forwarded-For $(echo '$proxy_add_x_forwarded_for');
                proxy_set_header Host $(echo '$host');
                proxy_pass http://127.0.0.1:${port};
                proxy_http_version 1.1;
                proxy_set_header Upgrade $(echo '$http_upgrade');
                proxy_set_header Connection "upgrade";
        }

        # Certbot
        location ~ /.well-known {
                allow all;
        }
}
EOF