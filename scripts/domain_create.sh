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

FILE=/etc/$platform/sites-available/$domain$LTD.conf
if [ -f "$FILE" ]; then
    echo Domain: $(green "$domain$LTD") on $(yellow "${platform^^}") platform $(yellow "has already been created!")
    echo To remove this domain run: $ $(yellow "localnet domain:remove $domain")
    exit 1
fi

echo "Complete parameters followed by pressing <enter> key to set $(yellow "$domain$LTD") on $(yellow "${platform^^}") server:"
proxy=false

if [[ "$platform" =~ ^(nginx)$ ]]; then
    read -p "Enter (y or n) if domain will use SSL ?? n: " ssl
    if [[ $ssl == "y" || $ssl == "Y" || $ssl == "yes" || $ssl == "Yes" ]]; then
        ssl=true
    else
        ssl=false
    fi

    read -p "Enter the directory in which the domain will match: ${PROJ_NGINX}/" path
    if [[ "$path" =~ ^()$ ]]; then
        echo $(red "domain directory path cannot be ${PROJ_NGINX}/")
        exit 1
    fi
    path=${PROJ_NGINX}/$path

    read -p "Enter the language will be applied from between options [${LANGS}]: " code
    if [[ "$code" =~ ^()$ || ! "$code" =~ ^(${LANGS})$ ]]; then
        echo $(red "Entered language does not match any options!")
        exit 1
    fi

    if [[ "$code" =~ ^(php)$ ]]; then 
        read -p "Enter index file ?? index.php: " file
        if [[ "$file" =~ ^()$ ]]; then file="index.php"; fi
        
        read -p "Enter the PHP version will be applied from options [${PHP_VERSIONS}]: " version
        IFS='|' read -r -a array <<< "$PHP_VERSIONS"
        if ! (echo ${array[@]} | grep -q -w $version); then 
            echo $(red "Entered PHP version does not match any options!")
            exit 1
        fi
    else
        read -p "Enter index file ?? index.html: " file
        if [[ "$file" =~ ^()$ ]]; then file="index.html"; fi
        
        echo $(yellow "To prevent a listener overlap, you'd have to be sure the port to use:") $(blue "$ sudo ss -tulwn | grep LISTEN")
        read -p "Enter the port will be reversed proxy to: " port
        if [[ "$port" =~ ^()$ ]]; then
            echo $(red "Entered PHP version does not match any options!")
            exit 1
        fi
        proxy="${code^^} on port :$port"
    fi
fi

if [[ "$platform" =~ ^(apache)$ ]]; then
    port=$PORT_APACHE
    proxy="${platform^^} on port :$port"
    read -p "Enter (y or n) if domain will use SSL ?? n: " ssl
    if [[ $ssl == "y" || $ssl == "Y" || $ssl == "yes" || $ssl == "Yes" ]]; then
        ssl=true
    else
        ssl=false
    fi

    read -p "Enter the directory in which the domain will match: ${PROJ_APACHE}/" path
    if [[ "$path" =~ ^()$ ]]; then
        echo $(red "domain directory path cannot be ")
        exit 1
    fi
    path=${PROJ_APACHE}/$path

    code="php"
    if [[ "$code" =~ ^(php)$ ]]; then 
        read -p "Enter index file ?? index.php: " file
        if [[ "$file" =~ ^()$ ]]; then file="index.php"; fi

        read -p "Enter the PHP version will be applied from options [${PHP_VERSIONS}]: " version
        IFS='|' read -r -a array <<< "$PHP_VERSIONS"
        if ! (echo ${array[@]} | grep -q -w $version); then 
            echo $(red "Entered PHP version does not match any options!")
            exit 1
        fi
    fi
fi

echo $(yellow "*** check configuration values before proceeding: ***")
echo $(yellow "DOMAIN:") $domain$LTD
echo $(yellow "SERVER:") Nginx
echo $(yellow "Proxy:") $proxy
echo $(yellow "SSL:") $ssl
echo $(yellow "DIRECTORY:") $path
echo $(yellow "LANGUAGE:") $code
if [[ "$code" =~ ^(php)$ ]]; then 
    echo $(yellow "VERSION:") $version
fi
echo $(yellow "FILE:") $file

# Process confirmation
prompt_confirm_proceed "Are all the parameters correct?" || exit 1

echo Creating $(green "$domain$LTD") on $(yellow "${platform^^}") server.

# Create file
_file="$domain$LTD.conf"
if [ -f "$_file" ]; then
  echo "# server block" > $_file
fi
echo "server {" >> $_file
echo "$(printf "%-8s")listen 80;" >> $_file
echo "$(printf "%-8s")listen [::]:80;" >> $_file
echo "}" >> $_file