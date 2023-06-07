#!/usr/bin/env bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
. "$DIR/config/setting.sh"
. "$DIR/support/styles.sh"
. "$DIR/support/dialogues.sh"

echo "Bash --version ${BASH_VERSION}"
echo Activating $(yellow "Domains Admin") with $(yellow "${ALIAS}") as alias name:
prompt_confirm_proceed "Are you sure to continue?" || exit 1

echo "" >> ~/.bashrc
echo "## --- NGINX DOMAINS ADMIN --- ###" >> ~/.bashrc
echo "alias $ALIAS='$DIR/main.sh'" >> ~/.bashrc
source ~/.bashrc

echo Activation $(green "complete!")
echo Before continue, read $(yellow "README.md") file!