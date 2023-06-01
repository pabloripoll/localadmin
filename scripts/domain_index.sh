#!/usr/bin/env bash

platform=$param_1
domain=$param_2
action=$param_3

if [ -z ${platform} ]; then 
    echo $(red "platform has not been declared.")
    return 1
fi

if [[ ! "$platform" =~ ^(nginx|apache)$ ]]; then
    echo $(yellow "Server platform") $(red "$platform") $(yellow "is not recognizable!");
    echo Param $(yellow "1") is for $(green "platform");
    echo Param $(yellow "2") is for $(green "domain name");
    exit 1;
fi
if [[ "$platform" =~ ^(apache)$ ]]; then platform="apache2"; fi

FILE=/etc/$platform/sites-available/$domain.localhost.conf
if [ ! -f "$FILE" ]; then
    echo Domain: $(red "$domain.localhost") $(yellow "has not been created.")
    echo To activate this domain run: $ $(green "localnet domain:create") $(yellow "$domain")
    return 1
else
    if [[ "$action" =~ ^(edit)$ ]]; then
        sudo nano $FILE;
        echo To perform changes run: $ $(green "localnet domains:update") $(yellow "${platform::-1}")
        return 1;
    else
        echo Domain: $(yellow "$domain.localhost") $(green "was created.")
    fi
fi

FILE_ENABLED=/etc/$platform/sites-enabled/$domain.localhost.conf
if [ ! -f "$FILE_ENABLED" ]; then
    echo Domain: $(red "$domain.localhost") $(yellow "has not been activated.")
    echo To activate this domain run: $ $(green "localnet domain:up") $(yellow "$domain")
    return 1
else
    echo Domain: $(yellow "$domain.localhost") $(green "is running!")
    echo $(blue "Domain configuration:")
    cat $FILE
fi