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

echo checking $(yellow ${platform^^}) for syntax errors:

if [[ "$platform" =~ ^(nginx)$ ]]; then
    check=$(sudo ${platform} -t 2>&1)
    if [[ ${check##* } =~ ^(failed)$ ]]; then
        echo $(red "Some errors must be fixed first!");
        sudo ${platform} -t
    else
        echo $(blue "updating...")
        sudo systemctl restart ${platform}
        echo $(yellow ${platform^^}) $(green "sites has been updated!")
    fi
fi

if [[ "$platform" =~ ^(apache)$ ]]; then
    check=$(sudo ${platform}ctl -t 2>&1)
    if ! echo $check | grep -q "Syntax OK"; then        
        echo $(yellow "Some errors must be fixed first!")
        sudo ${platform}ctl -t
    else
        echo $(blue "updating...")
        sudo systemctl reload ${platform}2;
        echo $(yellow ${platform^^}) $(green "sites has been updated!")
    fi
fi