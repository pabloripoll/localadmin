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

if [[ "$platform" =~ ^(nginx)$ ]]; then
    echo "Complete parameters followed by pressing <enter> key to set " $(yellow "$domain.localhost") on $(yellow "${platform^^}") server:

    read -p "Enter (y or n) if domain will use SSL ?? n: " ssl
    if [[ $ssl == "y" || $ssl == "Y" || $ssl == "yes" || $ssl == "Yes" ]]; then
        ssl=true
    else
        ssl=false
    fi

    read -p "Enter the directory in that domain will match: ${PRO_NGINX}/" path
    if [[ "$path" =~ ^()$ ]]; then
        echo $(red "domain directory path cannot be ${PRO_NGINX}/")
        exit 1
    fi

    read -p "Enter the language will be apply from options: php, node, net, java, pyton: " code
    if [[ "$code" =~ ^()$ ]]; then
        echo $(red "A language code option must be selected!")
        exit 1
    fi
    if [[ ! "$code" =~ ^(php|node|net|java|pyton)$ ]]; then
        echo $(red "Select a language code from the options.")
        exit 1
    fi

    if [[ "$code" =~ ^(php)$ ]]; then 
        read -p "Enter index file ?? index.php: " file
        if [[ "$file" =~ ^()$ ]]; then file="index.php"; fi
    fi    

    echo $(yellow "*** check configuration values before proceeding: ***")
    echo $(yellow "SSL:") $ssl
    echo $(yellow "DIRECTORY:") $PRO_NGINX/$path/
    echo $(yellow "LANGUAGE:") $code
    echo $(yellow "FILE:") $file
fi

# Process confirmation
prompt_confirm_proceed "Are all the parameters correct? only:" || exit 1

echo Creating $(green "$domain.localhost") on $(yellow "${platform^^}") server.