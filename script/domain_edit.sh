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

if [ -z ${platform} ]; then 
    echo $(red "platform has not been declared.")
    exit 1
fi

if [[ ! "$platform" =~ ^($SERVERS)$ ]]; then
    echo $(yellow "Server platform") $(red "$platform") $(yellow "is not recognizable!");
    echo Param $(yellow "1") is for $(green "platform");
    echo Param $(yellow "2") is for $(green "domain name");
    exit 1;
fi

DIR_AVAILABLE="${ETC_NGINX}/sites-available"
if [[ "$platform" =~ ^(apache)$ ]]; then DIR_AVAILABLE="${ETC_APACHE}/sites-available"; fi

FILE_AVAILABLE=${DIR_AVAILABLE}/${domain}${TLD}.conf
if [ ! -f "$FILE_AVAILABLE" ]; then
    echo Domain: ${domain}${TLD} $(yellow "has not been created.")
    echo To record this domain run: $ $(green "${ALIAS} domain:create") $(yellow "${platform} ${domain}")
    exit 1
fi

sudo nano $FILE_AVAILABLE;
echo To perform changes run: $ $(green "${ALIAS} domains:update") $(yellow "${platform}")
exit 1