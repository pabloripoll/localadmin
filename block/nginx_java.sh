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

        # Reverse proxy for Java like Jetty, GlassFish and Tomcat
        location / {
                index ${index};
        }

        location ~ \.do$ {
                proxy_pass http://127.0.0.1:${port};
                proxy_set_header X-Real-IP $(echo '$remote_addr');
                proxy_set_header X-Forwarded-For $(echo '$proxy_add_x_forwarded_for');
                proxy_set_header Host $(echo '$http_host');
        }

        location ~ \.jsp$ {
                proxy_pass http://127.0.0.1:${port};
                proxy_set_header X-Real-IP $(echo '$remote_addr');
                proxy_set_header X-Forwarded-For $(echo '$proxy_add_x_forwarded_for');
                proxy_set_header Host $(echo '$http_host');
        }

        location ^~/servlets/* {
                proxy_pass http://127.0.0.1:${port};
                proxy_set_header X-Real-IP $(echo '$remote_addr');
                proxy_set_header X-Forwarded-For $(echo '$proxy_add_x_forwarded_for');
                proxy_set_header Host $(echo '$http_host');
        }

        # Certbot
        location ~ /.well-known {
                allow all;
        }
}
EOF