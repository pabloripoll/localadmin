#!/usr/bin/env bash

platform=$param_1
domain=$param_2

if [ -z $platform ]; then \
    echo $(red "Server Platform") $(yellow "must be specified!");
    exit 1;
fi

if [[ ! "$platform" =~ ^(nginx|apache)$ ]]; then
    echo $(yellow "Server platform") $(red "$platform") $(yellow "is not recognizable!");
    echo Param $(yellow "1") is for $(green "platform");
    echo Param $(yellow "2") is for $(green "new domain name");
    exit 1;
fi

file=/etc/$platform/sites-available/${domain}${TLD}.conf
if [ -f "$file" ]; then
    echo Domain: $(green "${domain}${TLD}") on $(yellow "${platform^^}") platform $(yellow "has already been created!")
    echo To remove this domain run: $ $(yellow "${ALIAS} domain:remove ${domain}")
    exit 1
fi

echo "Complete parameters followed by pressing <enter> key to set $(yellow "$domain${TLD}") on $(yellow "${platform^^}") server:"
proxy=false

if [[ "$platform" =~ ^(nginx)$ ]]; then
    read -p "Enter (y or n) if domain will use SSL ?? n: " ssl
    ssl="${ssl,,}"
    if [[ $ssl == "y" || $ssl == "yes" ]]; then ssl=true; else ssl=false; fi

    read -p "Enter the language will be applied from between options [${LANGS}]: " code
    if [[ "$code" =~ ^()$ || ! "$code" =~ ^(${LANGS})$ ]]; then
        echo $(red "Entered language does not match any options!")
        exit 1
    fi

    if [[ "$code" =~ ^(php)$ ]]; then
        read -p "Enter index file ?? index.php: " index
        if [[ "$index" =~ ^()$ ]]; then index="index.php index.html"; fi
        
        read -p "Enter the PHP version will be applied from options [${PHP_VERSIONS}]: " version
        IFS='|' read -r -a array <<< "$PHP_VERSIONS"
        if ! (echo ${array[@]} | grep -q -w $version); then 
            echo $(red "Entered PHP version does not match any options!")
            exit 1
        fi
    else
        read -p "Enter index file ?? index.html: " index
        if [[ "$index" =~ ^()$ ]]; then index="index.html"; fi
        
        echo $(yellow "To prevent a listener overlap, you'd have to be sure the port to use:") $(blue "$ sudo ss -tulwn | grep LISTEN")
        read -p "Enter the port will be reversed proxy to: " port
        if [[ "$port" =~ ^()$ ]]; then
            echo $(red "Entered PHP version does not match any options!")
            exit 1
        fi
        proxy="${code^^} on port :$port"
    fi

    predefined_path="${PROJ_FLD}"
    if [[ "$code" =~ ^(php)$ ]]; then predefined_path="${PROJ_PHP}" ; fi
    if [[ "$code" =~ ^(java)$ ]]; then predefined_path="${PROJ_JAVA}" ; fi
    if [[ "$code" =~ ^(nodejs)$ ]]; then predefined_path="${PROJ_NODEJS}" ; fi
    if [[ "$code" =~ ^(dotnet)$ ]]; then predefined_path="${PROJ_DOTNET}" ; fi
    if [[ "$code" =~ ^(python)$ ]]; then predefined_path="${PROJ_PYTHON}" ; fi
    if [[ "$code" =~ ^(go)$ ]]; then predefined_path="${PROJ_GO}" ; fi

    read -p "Enter the directory in which the domain will match from ${predefined_path}/:" path
    if [[ "$path" =~ ^()$ ]]; then
        echo $(red "domain directory path cannot be ${predefined_path}/")
        exit 1
    fi
    path=${predefined_path}/$path
fi

if [[ "$platform" =~ ^(apache)$ ]]; then
    port=$PORT_APACHE
    proxy="${platform^^} on port :$port"
    read -p "Enter (y or n) if domain will use SSL ?? n: " ssl
    ssl="${ssl,,}"
    if [[ $ssl == "y" || $ssl == "yes" ]]; then ssl=true; else ssl=false; fi

    code="php"
    if [[ "$code" =~ ^(php)$ ]]; then
        read -p "Enter index file ?? index.php: " index
        if [[ "$index" =~ ^()$ ]]; then index="index.php index.html"; fi

        read -p "Enter the PHP version will be applied from options [${PHP_VERSIONS}]: " version
        IFS='|' read -r -a array <<< "$PHP_VERSIONS"
        if ! (echo ${array[@]} | grep -q -w $version); then 
            echo $(red "Entered PHP version does not match any options!")
            exit 1
        fi
    fi

    read -p "Enter the directory in which the domain will match from ${PROJ_APACHE}/:" path
    if [[ "$path" =~ ^()$ ]]; then
        echo $(red "domain directory path cannot be ")
        exit 1
    fi
    path=${PROJ_APACHE}/$path
fi

# Cheking input values
echo $(yellow "*** check configuration values before proceeding: ***")
echo $(yellow "DOMAIN:") ${domain}${TLD}
echo $(yellow "SERVER:") Nginx
if [[ ! "$proxy" =~ ^(false)$ ]]; then
    echo $(yellow "Proxy:") $proxy
fi
echo $(yellow "SSL:") $ssl
echo $(yellow "LANGUAGE:") $code
if [[ "$code" =~ ^(php)$ ]]; then 
    echo $(yellow "VERSION:") $version
fi
echo $(yellow "INDEX:") $index
echo $(yellow "DIRECTORY:") $path

# Process confirmation
prompt_confirm_proceed "Are all the parameters correct?" || exit 1

echo Processing ${domain}${TLD} parameters.

# Create nginx server block
nginx_server_block="${DIR}/temp/${domain}${TLD}.conf"
echo Creating $(yellow "NGINX") server block file as $(yellow "${domain}${TLD}.conf")

# SSL comment tag
sslon="# "
if [[ "$ssl" =~ ^(true)$ ]]; then sslon=""; fi

if [[ "$code" =~ ^(php)$ && "$platform" =~ ^(nginx)$ ]]; then
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
    echo server block $(green "${domain}${TLD}") for $(yellow "NGINX") sites available has been created.
    echo placing file into $(yellow "NGINX") sites available directory as SUDO USER:
    sudo mv $nginx_server_block ${ETC_NGINX}/sites-available/${domain}${TLD}.conf
    sudo chown root:root ${ETC_NGINX}/sites-available/${domain}${TLD}.conf
    sudo chmod 644 ${ETC_NGINX}/sites-available/${domain}${TLD}.conf
    echo server block $(green "${domain}${TLD}") has been placed into $(yellow "NGINX") sites available directory.
    sudo nginx -t
    echo
    read -p "Do you need to active ${domain}${TLD} right now ?? y: " activation
    activation="${activation,,}"
    if [[ $activation == "n" || $activation == "no" ]]; then
        echo To activate domain run $(green "$ ${ALIAS} domain:up ${platform} ${domain}${TLD}")
        exit 1
    else
        sudo ln -s ${ETC_NGINX}/sites-available/${domain}${TLD}.conf ${ETC_NGINX}/sites-enabled/
        sudo systemctl restart nginx
        exit 1
    fi
fi

if [[ "$code" =~ ^(php)$ && "$platform" =~ ^(apache)$ ]]; then
# nginx server block
cat <<EOF > $nginx_server_block
server {
        listen 80;
        listen [::]:80;

        # SSL configuration is managed by Apache

        # Root domain
        server_name ${domain}${TLD} www.${domain}${TLD};

        location / {
                # Reverse Proxy to Apache
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
    echo $(green "${domain}${TLD}") on $(yellow "NGINX") for $(yellow "APACHE") has been $(green "succesfully created!")

# apache server block
apache_server_block="${DIR}/temp/${domain}${TLD}.conf"
echo Creating $(yellow "APACHE") server block as $(yellow "$apache_server_block") file
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
    echo $(green "${domain}${TLD}") on $(yellow "APACHE") has been $(green "succesfully created!")
fi

if [[ ! "$code" =~ ^(php)$ ]]; then


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
                # Reverse Proxy for GO
                proxy_pass https://127.0.0.1:${port};
                proxy_set_header Host $(echo '$host');
                proxy_set_header X-Real-IP $(echo '$remote_addr');
                proxy_set_header X-Forwarded-For $(echo '$proxy_add_x_forwarded_for');
                proxy_set_header X-Forwarded-Proto $(echo '$scheme');
                
        }

        # Certbot
        location ~ /.well-known {
                allow all;
        }
}
EOF
    echo $(green "${domain}${TLD}") on $(yellow "NGINX") for ${proxy} has been $(green "succesfully created!")
fi
