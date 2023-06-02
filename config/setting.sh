#!/usr/bin/env bash

## Variables
script="";
param_1="";
param_2="";
param_3="";
param_4="";

## Constants
ETC_NGINX="nginx";
ETC_APACHE="apache2";

## Domains projects
PRO_NGINX="/var/www/nginx"
PRO_APACHE="/var/www/apache"

## Language versions
php_versions()
{
    output=""
    for row in $(echo "$(ls -l /etc/php -t 2>&1)" | awk -v OFS="," '$1=$1'); do
        IFS=',' read -r -a array <<< "$row"
        if [[ ! "${array[8]}" =~ ^()$ ]]; then
            output=$output"|"${array[8]}
        fi
    done
    local output="${output:1}"
    echo $output
}
PHP_VERSIONS=$(php_versions)