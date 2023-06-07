#!/usr/bin/env bash

## Alias
ALIAS="localnet"

## Variables
script="";
param_1="";
param_2="";
param_3="";
param_4="";

## Top level domain by default for local machine or leave it empty for remote
TLD=".localhost"

## Servers
SERVERS="nginx|apache"

## Server directory
ETC_NGINX="/etc/nginx";
ETC_APACHE="/etc/apache2";

## Server port
PORT_NGINX=80
PORT_APACHE=8080

## Custom project's directories
PROJ_FLD="/var/www"
PROJ_PHP="/var/www/nginx"
PROJ_APACHE="/var/www/apache"
PROJ_JAVA="/var/www/java"
PROJ_JAVASP="/var/www/springboot"
PROJ_NODEJS="/var/www/nodejs"
PROJ_DOTNET="/var/www/dotnet"
PROJ_PYTHON="/var/www/python"
PROJ_GO="/var/www/golang"

## Languages
LANGS="php|go|nodejs|dotnet|pyton|java|javasp"

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

## Special
NOTDOMAIN="default|default.dpkg|default.dpkg-old|000-default.conf|000-default.conf.save|default-ssl.conf"