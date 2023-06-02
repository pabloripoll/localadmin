#!/usr/bin/env bash

## Variables
script="";
param_1="";
param_2="";
param_3="";
param_4="";

## Top level domain by default or leave it empty when others are used
TLD=".localhost" #

## Servers
ETC_NGINX="nginx";
ETC_APACHE="apache2";

## Ports
PORT_NGINX=80
PORT_APACHE=8080

## Languages
LANGS="php|nodejs|dotnet|java|pyton|c++|go"

## Domain projects
PROJ_FLD="/var/www"
PROJ_JAVA="/var/www/java"
PROJ_NGINX="/var/www/nginx"
PROJ_APACHE="/var/www/apache"
PROJ_NODEJS="/var/www/nodejs"
PROJ_DOTNET="/var/www/dotnet"
PROJ_PYTHON="/var/www/python"

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