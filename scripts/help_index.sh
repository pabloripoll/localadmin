#!/usr/bin/env bash

Example()
{
   # Display Help
   echo "Add description of the script functions here."
   echo
   echo "Syntax: scriptTemplate [-g|h|v|V]"
   echo "options:"
   echo "g     Print the GPL license notification."
   echo "h     Print this Help."
   echo "v     Verbose mode."
   echo "V     Print software version and exit."
   echo
}

echo

Domains()
{
    echo $(yellow "Domains:")
    echo "$(green "[param_1]") = Server Platform like: Nginx, Apache."
    echo "Syntax: $(green domains) or $(green domains:index) [param_1]"
    echo "      For listing all domains registered on sites-available directory."
    echo "Syntax: $(green domains:active) [param_1]"
    echo "      For listing all domains registered on sites-enabled directory."
    echo "Syntax: $(green domains:update) [param_1]"
    echo "      Updates sites available registered."
    echo
}

Domain()
{
    echo $(yellow "Domain:")
    echo "$(green "[param_1]") = domain name."
    echo "Syntax: $(green domains) or $(green domains:index) [param_1]"
    echo "      List domain registered if active."
    echo "Syntax: $(green domains:active) [param_1]"
    echo "      For listing all domains registered on sites-enabled directory."
    echo "Syntax: $(green domains:update) [param_1]"
    echo "      Updates sites available registered."
    echo
}

## Help:
echo "Bash version ${BASH_VERSION}"
echo
Domains
Domain