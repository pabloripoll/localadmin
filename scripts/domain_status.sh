#!/usr/bin/env bash

platform=$param_1
domain=$param_2

if [ -z $platform ]; then \
    echo $(red "Server platform") $(yellow "must be specified!");
    exit 1;
fi

if [[ ! "$platform" =~ ^(nginx|apache)$ ]]; then
    echo $(yellow "Server platform") $(red "$platform") $(yellow "is not recognizable!");
    exit 1;
fi

if [[ "$platform" =~ ^(apache)$ ]]; then platform="apache2"; fi

FILE=/etc/$platform/sites-enabled/$domain.localhost.conf
if [ ! -f "$FILE" ]; then
    echo Domain: $(yellow "$domain.localhost") on $(yellow ${platform^^}) platform $(yellow "couldn't be found!")
    echo $FILE
    echo Search this domain running: $ $(blue "localnet domains $platform")
    return 1
else
    echo Domain $(green "$domain.localhost") status running on $(yellow "${platform^^}") platform is:
    curl -I -L --max-redirs 5 $domain.localhost;
fi