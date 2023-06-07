#!/usr/bin/env bash

# apache server block
cat <<EOF > $apache_server_block
<VirtualHost *:${PORT_APACHE}>
    ServerName ${domain}${TLD}
    ServerAlias www.${domain}${TLD}

    DocumentRoot $path/

    <Directory $path/>
        Options -Indexes +FollowSymLinks -MultiViews
        AllowOverride All
        Require all granted
    </Directory>

    # Enable PHP-FPM adding the following block
    <FilesMatch \.php$>
        # 2.4.10+ can proxy to unix socket
        SetHandler "proxy:unix:/var/run/php/php${version}-fpm.sock|fcgi://localhost"
        # Else we can just use a tcp socket:
        # SetHandler "proxy:fcgi://127.0.0.1:9000"
    </FilesMatch>

    ErrorLog $(echo '${APACHE_LOG_DIR}')/error.log
    CustomLog $(echo '${APACHE_LOG_DIR}')/access.log combined
</VirtualHost>
EOF