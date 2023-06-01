#!/usr/bin/env bash

platform=$param_1

if [ -z $platform ]; then \
    echo $(red "Server platform") $(yellow "must be specified!");
    exit 1;
fi

if [[ ! "$platform" =~ ^(nginx|apache)$ ]]; then
    echo $(yellow "Server platform") $(red "${platform^^}") $(yellow "is not recognizable!");
    exit 1;
fi

printf "$(green "Domains registered locally on") $(yellow ${platform^^}) $(green "server platform:")"; echo;

if [[ "$platform" =~ ^(apache)$ ]]; then platform=$ETC_APACHE; fi

ls -l /etc/$platform/sites-available/;
