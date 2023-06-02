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

FILE=/etc/$platform/sites-available/$domain.localhost.conf
if [ -f "$FILE" ]; then
    echo Domain: $(green "$domain.localhost") on $(yellow "${platform^^}") platform $(yellow "has already been created!")
    echo To remove this domain run: $ $(yellow "localnet domain:remove $domain")
    exit 1
fi

echo "Complete parameters followed by pressing <enter> key to set " $(yellow "$domain.localhost") on $(yellow "${platform^^}") server:

if [[ "$platform" =~ ^(nginx)$ ]]; then
    read -p "Enter (y or n) if domain will use SSL ?? n: " ssl
    if [[ $ssl == "y" || $ssl == "Y" || $ssl == "yes" || $ssl == "Yes" ]]; then
        ssl=true
    else
        ssl=false
    fi

    read -p "Enter the directory in which the domain will match: ${PRO_NGINX}/" path
    if [[ "$path" =~ ^()$ ]]; then
        echo $(red "domain directory path cannot be ${PRO_NGINX}/")
        exit 1
    fi

    read -p "Enter the language will be applied from between options [php, node, net, java, pyton]: " code
    if [[ "$code" =~ ^()$ || ! "$code" =~ ^(php|node|net|java|pyton)$ ]]; then
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
    fi

    echo $(yellow "*** check configuration values before proceeding: ***")
    echo $(yellow "SSL:") $ssl
    echo $(yellow "DIRECTORY:") $PRO_NGINX/$path/
    echo $(yellow "LANGUAGE:") $code
    echo $(yellow "VERSION:") $version
    echo $(yellow "FILE:") $file
fi

if [[ "$platform" =~ ^(apache)$ ]]; then
    read -p "Enter (y or n) if domain will use SSL ?? n: " ssl
    if [[ $ssl == "y" || $ssl == "Y" || $ssl == "yes" || $ssl == "Yes" ]]; then
        ssl=true
    else
        ssl=false
    fi

    read -p "Enter the directory in which the domain will match: ${PRO_APACHE}/" path
    if [[ "$path" =~ ^()$ ]]; then
        echo $(red "domain directory path cannot be ${PRO_APACHE}/")
        exit 1
    fi

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

    echo $(yellow "*** check configuration values before proceeding: ***")
    echo $(yellow "SSL:") $ssl
    echo $(yellow "DIRECTORY:") $PRO_APACHE/$path/
    echo $(yellow "LANGUAGE:") $code
    echo $(yellow "VERSION:") $version
    echo $(yellow "FILE:") $file
fi

# Process confirmation
prompt_confirm_proceed "Are all the parameters correct?" || exit 1

echo Creating $(green "$domain.localhost") on $(yellow "${platform^^}") server.