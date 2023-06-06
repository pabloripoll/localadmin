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

printf "Domains registered locally in $(yellow ${platform^^})'s $(green "sites-available") directory:"; echo;

DIR_PLATFORM="${ETC_NGINX}"
if [[ "$platform" =~ ^(apache)$ ]]; then DIR_PLATFORM="${ETC_APACHE}"; fi

ls -l ${DIR_PLATFORM}/sites-available/;