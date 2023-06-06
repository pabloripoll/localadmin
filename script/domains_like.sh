#!/usr/bin/env bash

platform=""
domain=""

if [ "$iparams" -eq 2 ]; then
    echo Illegal declaration.
    exit 1
fi

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
    echo $(yellow "Server platform") $(red "${platform^^}") $(yellow "is not recognizable!");
    exit 1;
fi

DIR_PLATFORM="${ETC_NGINX}"
if [[ "$platform" =~ ^(apache)$ ]]; then DIR_PLATFORM="${ETC_APACHE}"; fi

echo Domains registered on $(yellow "${platform^^}") with name like: $(yellow "*${domain}*");

for row in $(echo "$(ls -l ${DIR_PLATFORM}/sites-available -t 2>&1)" | awk -v OFS="," '$1=$1'); do
    IFS=',' read -r -a array <<< "$row"
    result=""
    if [[ ! "${array[8]}" =~ ^()$ && "${array[8]}" =~ .*"$domain".* ]]; then
        result=${array[8]}
        status=$(green "[active]")
        FILE_ENABLED=${DIR_PLATFORM}/sites-enabled/$result
        if [ ! -f "$FILE_ENABLED" ]; then
            status=$(yellow "[record]")
        fi
        echo "${status} ${result}"
    fi
done
