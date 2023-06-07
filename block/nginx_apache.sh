#!/usr/bin/env bash

# nginx server block
cat <<EOF > $nginx_server_block
server {
        listen 80;
        listen [::]:80;

        # SSL configuration is managed by Apache

        # Root domain
        server_name ${domain}${TLD} www.${domain}${TLD};

        location / {
                # Reverse proxy to Apache
                proxy_pass http://127.0.0.1:${PORT_APACHE};
                proxy_set_header Host $(echo '$host');
                proxy_set_header X-Real-IP $(echo '$remote_addr');
                proxy_set_header X-Forwarded-For $(echo '$proxy_add_x_forwarded_for');
                proxy_set_header X-Forwarded-Proto $(echo '$scheme');
        }

        # Deny access to .htaccess files if Apache's document root concurs with nginx's one
        location ~ /\.ht {
                deny all;
        }

        # Certbot
        location ~ /.well-known {
                allow all;
        }
}
EOF