#!/usr/bin/env bash

platform=$param_1
domain=$param_2
action=$param_3

if [ -z ${platform} ]; then 
    echo $(red "platform has not been declared.")
    return 1
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

DIR_ENABLED="${ETC_NGINX}/sites-enabled"
if [[ "$platform" =~ ^(apache)$ ]]; then DIR_ENABLED="${ETC_APACHE}/sites-enabled"; fi

FILE_ENABLED=${DIR_ENABLED}/${domain}${TLD}.conf
if [ ! -f "$FILE_ENABLED" ]; then
    echo Domain: ${domain}${TLD} $(yellow "has not been activated.")
    echo To activate this domain run: $ $(green "${ALIAS} domain:up") $(yellow "${platform} ${domain}")
    exit 1
fi

echo Domain ${domain}${TLD} set on ${platform^^} platform status:
curl -I -L --max-redirs 5 ${domain}${TLD};
exit 1