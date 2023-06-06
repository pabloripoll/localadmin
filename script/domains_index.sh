#!/usr/bin/env bash

platform="${SERVERS::5}"
if [ ! -z $param_1 ]; then \
    platform=$param_1
fi

if [ -z $platform ]; then \
    echo $(red "Server platform") $(yellow "must be specified!");
    exit 1;
fi

if [[ ! "$platform" =~ ^($SERVERS)$ ]]; then
    echo $(yellow "Server platform") $(red "${platform^^}") $(yellow "is not recognizable!");
    exit 1;
fi

printf "Domains registered locally on $(yellow ${platform^^}) server platform:"; echo;

DIR_PLATFORM="${ETC_NGINX}"
if [[ "$platform" =~ ^(apache)$ ]]; then DIR_PLATFORM="${ETC_APACHE}"; fi

for row in $(echo "$(ls -l ${DIR_PLATFORM}/sites-available/ -t 2>&1)" | awk -v OFS="," '$1=$1'); do
    IFS=',' read -r -a array <<< "$row"
    if [[ ! "${array[8]}" =~ ^()$ ]]; then
    
        if [[ "${array[8]}" =~ ^($NOTDOMAIN)$ ]]; then continue; fi

        date="[$(printf "%02d\n" ${array[6]}) ${array[5]} $(printf %-5s ${array[7]} | tr ' ' X)]"
        domain="${array[8]}"
        status=$(green "[active]")
        FILE_ENABLED=${DIR_PLATFORM}/sites-enabled/$domain
        if [ ! -f "$FILE_ENABLED" ]; then
            status=$(yellow "[record]")
        fi
        echo $date $status $domain
    fi
done