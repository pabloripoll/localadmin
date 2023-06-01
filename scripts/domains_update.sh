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

echo $(blue "checking") $(yellow ${platform^^}) $(blue "for syntax errors:");

if [[ "$platform" =~ ^(nginx)$ ]]; then
    sudo $platform -t;
    echo $(blue "updating...");
    sudo systemctl restart $platform;    

elif [[ "$platform" =~ ^(apache)$ ]]; then 
    platform2="apache2";
    echo $(blue "updating...");
    sudo systemctl reload $platform2;

else
    sudo systemctl restart $platform;

fi

echo $(yellow ${platform^^}) $(green "sites has been updated!");