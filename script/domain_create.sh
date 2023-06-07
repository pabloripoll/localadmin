#!/usr/bin/env bash

if [ "$iparams" -eq 3 ]; then
    platform="${SERVERS::5}"
    domain=$param_1
    if [ -z ${domain} ]; then 
        echo $(red "domain name has not been declared.")
        exit 1
    fi
else
    platform=$param_1
    domain=$param_2
fi

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

echo "Complete the following parameters by pressing <enter> key to set $(yellow "$domain${TLD}") on $(yellow "${platform^^}") server:"
proxy=false

if [[ "$platform" =~ ^(apache)$ ]]; then
    port=$PORT_APACHE
    proxy="${platform^^} on port :$port"
    read -p "Enter (y or n) if domain will use SSL ?? n: " ssl
    ssl="${ssl,,}"
    if [[ $ssl == "y" || $ssl == "yes" ]]; then ssl=true; else ssl=false; fi

    code="php"
    if [[ "$code" =~ ^(php)$ ]]; then
        read -p "Enter index file ?? index.php: " index
        if [[ "$index" =~ ^()$ ]]; then index="index.php"; fi

        read -p "Enter the PHP version will be applied from options [${PHP_VERSIONS}]: " version
        IFS='|' read -r -a array <<< "$PHP_VERSIONS"
        if ! (echo ${array[@]} | grep -q -w $version); then 
            echo $(red "Entered PHP version does not match any options!")
            exit 1
        fi
    fi

    read -p "Enter the directory in which the domain will match from ${PROJ_APACHE}/:" path
    if [[ "$path" =~ ^()$ ]]; then
        echo $(red "domain directory path cannot be empty!")
        exit 1
    fi
    path=${PROJ_APACHE}/$path
fi

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

# Cheking input values
echo $(yellow "*** check configuration values before proceeding: ***")
echo $(yellow "DOMAIN:") ${domain}${TLD}
echo $(yellow "SERVER:") NGINX
if [[ ! "$proxy" == false ]]; then
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

echo Registering ${domain}${TLD} parameters...

prompt_confirm_proceed "Do you want to put up online ${domain}${TLD} at the end of the process?"
activation="${REPLY,,}"

# SSL comment tag
sslon="# "
if [[ "$ssl" == true ]]; then sslon=""; fi

# APACHE server block
if [[ "$code" =~ ^(php)$ && "$platform" =~ ^(apache)$ ]]; then
    echo Creating $(yellow "APACHE") server block as $(yellow "$apache_server_block") file
    apache_server_block="${DIR}/temp/${domain}${TLD}.conf"
    . "$DIR/block/apache_php.sh"
    echo server block $(green "${domain}${TLD}") for $(yellow "APACHE") sites available has been created.
    sudo mv $apache_server_block ${ETC_APACHE}/sites-available/${domain}${TLD}.conf
    sudo chown root:root ${ETC_APACHE}/sites-available/${domain}${TLD}.conf
    sudo chmod 644 ${ETC_APACHE}/sites-available/${domain}${TLD}.conf
    if [[ "$activation" =~ ^(y)$ ]]; then
        action=$(echo "$(sudo a2ensite ${domain}${TLD}.conf)")
        echo Domain $(yellow "${domain}${TLD}") has been put up online in $(yellow "APACHE") platform.    
        sudo systemctl reload apache2
        echo $(yellow "APACHE") $(green "sites has been updated!")
    fi
fi

# NGINX server block
echo Creating $(yellow "NGINX") server block file as $(yellow "${domain}${TLD}.conf")
nginx_server_block="${DIR}/temp/${domain}${TLD}.conf"

if [[ "$code" =~ ^(php)$ && "$platform" =~ ^(apache)$ ]]; then
    . "$DIR/block/nginx_apache.sh"
fi

# PHP
if [[ "$code" =~ ^(php)$ && "$platform" =~ ^(nginx)$ ]]; then
    . "$DIR/block/nginx_php.sh"
fi

# GO
if [[ "$code" =~ ^(go)$ ]]; then
    . "$DIR/block/nginx_go.sh"
fi

# NodeJS
if [[ "$code" =~ ^(nodejs)$ ]]; then
    . "$DIR/block/nginx_nodejs.sh"
fi

# Dot Net
if [[ "$code" =~ ^(dotnet)$ ]]; then
    . "$DIR/block/nginx_dotnet.sh"
fi

# Python
if [[ "$code" =~ ^(python)$ ]]; then
    . "$DIR/block/nginx_python.sh"
fi

# Java
if [[ "$code" =~ ^(java)$ ]]; then
    . "$DIR/block/nginx_java.sh"
fi

# Java Springboot
if [[ "$code" =~ ^(javasp)$ ]]; then
    . "$DIR/block/nginx_javasp.sh"
fi

echo server block $(green "${domain}${TLD}") for $(yellow "NGINX") sites available has been created.
echo placing file into $(yellow "NGINX") sites available directory as SUDO USER:
sudo mv $nginx_server_block ${ETC_NGINX}/sites-available/${domain}${TLD}.conf
sudo chown root:root ${ETC_NGINX}/sites-available/${domain}${TLD}.conf
sudo chmod 644 ${ETC_NGINX}/sites-available/${domain}${TLD}.conf
echo server block $(green "${domain}${TLD}") has been placed into $(yellow "NGINX") sites available directory.
sudo nginx -t

if [[ $activation == "n" ]]; then
    echo To activate domain run $(green "$ ${ALIAS} domain:up ${platform} ${domain}${TLD}")
    exit 1
else
    action=$(echo "$(sudo ln -s ${ETC_NGINX}/sites-available/${domain}${TLD}.conf ${ETC_NGINX}/sites-enabled)")
    echo Domain $(yellow "${domain}${TLD}") has been put up online in $(yellow "NGINX") platform.
    sudo systemctl restart nginx
    echo $(yellow "NGINX") $(green "sites has been updated!")
    exit 1
fi