#!/usr/bin/env bash

platform=$param_1
domain=$param_2

# Reverse proxy by NGINX
IFS=':' read -r -a value <<< "$platform"
platform=${value[0]}
proxy=''
if [ ! -z ${value[1]} ]; then 
    proxy=${value[1]}
fi
if [[ "$proxy" =~ ^(proxy)$ ]]; then
    proxy=true
else
    proxy=false
fi

if [ -z $platform ]; then \
    echo $(red "Server Platform") $(yellow "must be specified!");
    exit 1;
fi

if [[ ! "$platform" =~ ^(nginx|apache)$ ]]; then
    echo $(yellow "Server Platform") $(red "$platform") $(yellow "is not recognizable!");
    exit 1;
fi

if [[ "$platform" =~ ^(apache)$ ]]; then platform="apache2"; fi

FILE=/etc/$platform/sites-enabled/$domain.localhost.conf
if [ -f "$FILE" ]; then
    echo Domain: $(green "$domain.localhost") on $(yellow "${platform^^}") platform $(green "is already running!")
    echo To deactivate this domain run: $ $(blue "localnet domain:down $domain")
    return 1
fi

# Security
echo Activating $(yellow "$domain.localhost") on $(yellow "${platform^^}") server.
prompt_confirm "Are you sure to continue?" || exit 0

if [[ $proxy===false ]]; then
    echo Activating $(yellow "$domain.localhost") on $(yellow "${platform^^}") server...
    echo ...
    echo Domain: $(green "$domain.localhost") has been succesfully activated!
    echo Server: $(yellow "is only available on") $(green "${platform^^}") $(yellow "server")
else
    echo Activating $(yellow "$domain.localhost") on $(yellow "${platform^^}") server...
    echo ...
    echo Domain: $(green "$domain.localhost") $(yellow "has been succesfully activated!") proxy by $(yellow "NGINX")
fi
