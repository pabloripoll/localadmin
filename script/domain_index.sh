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
    action=$param_3
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

recorded=false
FILE_AVAILABLE=${DIR_AVAILABLE}/${domain}${TLD}.conf
if [ ! -f "$FILE_AVAILABLE" ]; then
    echo Domain: ${domain}${TLD} $(yellow "has not been created.")
    echo To record this domain run: $ $(green "${ALIAS} domain:create ${platform} ${domain}")
    exit 1
else
    if [[ "$action" =~ ^(edit)$ ]]; then
        sudo nano $FILE_AVAILABLE;
        echo To perform changes run: $ $(green "${ALIAS} domains:update ${platform}")
        exit 1
    else
        recorded=true
        echo Domain ${domain}${TLD} $(green "is recorded.")
    fi
fi

DIR_ENABLED="${ETC_NGINX}/sites-enabled"
if [[ "$platform" =~ ^(apache)$ ]]; then DIR_ENABLED="${ETC_APACHE}/sites-enabled"; fi

FILE_ENABLED=${DIR_ENABLED}/${domain}${TLD}.conf
if [ ! -f "$FILE_ENABLED" ]; then
    echo Domain: ${domain}${TLD} $(yellow "has not been activated.")
    echo To activate this domain run: $ $(green "${ALIAS} domain:up ${platform} ${domain}")
    exit 1
else
    echo Domain ${domain}${TLD} $(green "is running!")    
fi

if [[ "$recorded" == true ]]; then
    echo $(blue "Domain configuration:")
    cat $FILE_AVAILABLE
fi