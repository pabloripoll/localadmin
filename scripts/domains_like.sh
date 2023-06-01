#!/usr/bin/env bash

domain=$param_1

FILE=/etc/nginx/sites-enabled/$domain.localhost.conf
if [ ! -f "$FILE" ]; then
    echo Domain: $(red "$domain.localhost") $(yellow "has not been activated.")
    echo To activate this domain run: $ $(green "localnet domain:create") $(yellow "$domain")
    return 1
else
    FILE=/etc/apache2/sites-enabled/$domain.localhost.conf
    if [ -f "$FILE" ]; then
        echo Domain: $(green "$domain.localhost") is running on $(yellow "APACHE") reversed proxy by $(yellow "NGINX")
    else
        echo Domain: $(green "$domain.localhost") is running on $(yellow "NGINX")
    fi    
fi