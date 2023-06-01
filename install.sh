#!/usr/bin/env bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
. "$DIR/support/styles.sh"
. "$DIR/support/dialogues.sh"

# SETTINGS
ALIAS="localnet"

echo Activating $(yellow "LocalNetAdmin") with $(yellow "${ALIAS}") as alias name:
prompt_confirm "Are you sure to continue?" || return 1

echo "" >> ~/.bashrc
echo "## --- LOCALNETADMIN --- ###" >> ~/.bashrc
echo "alias $ALIAS='$DIR/main.sh'" >> ~/.bashrc
source ~/.bashrc

echo Activation $(green "complete!")
echo Before continue, read $(yellow "README.md") file!