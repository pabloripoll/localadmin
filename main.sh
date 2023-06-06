#!/usr/bin/env bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
. "$DIR/config/setting.sh"
. "$DIR/support/styles.sh"
. "$DIR/support/dialogues.sh"

iparams=0
for param in "$@"
do
    if [[ "$i" =~ ^()$ ]]; then script=$param; fi
    if [[ "$i" =~ ^(1)$ ]]; then param_1=$param; fi
    if [[ "$i" =~ ^(2)$ ]]; then param_2=$param; fi
    if [[ "$i" =~ ^(3)$ ]]; then param_3=$param; fi
    if [[ "$i" =~ ^(4)$ ]]; then param_4=$param; fi    
    i=$((i + 1))
    iparams=$((i + 1))
done

run()
{
    IFS=':' read -r -a value <<< "$script"
    script=${value[0]}"_index"
    if [ ! -z ${value[1]} ]; then
        script=${value[0]}"_"${value[1]}
    fi

    FILE=$DIR/script/$script.sh
    if [ ! -f "$FILE" ]; then
        echo ${ALIAS} script: $(yellow "'$script:$method'") $(red "cannot be found!")
        echo For ${ALIAS} $(yellow "'scripts'") information run: $ $(green "${ALIAS} help")
        exit 1
    else
        . $FILE
    fi
}

run

# Last line output break
echo