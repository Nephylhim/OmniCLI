#!/bin/bash

# shellcheck disable=SC1091

NC='\033[0m' # No Color
BLUE='\033[1;34m'

confFile=$1

while true; do
    echo -en "${BLUE}omnicli>${NC} "
    read -ra cmd

    # Correctly spliting args in case of argument encapsulated in "".
    args=();
    buffer="";
    for c in "${cmd[@]}"; do
        if [ -z $buffer ]; then
            if [[ $c == "\""* ]]; then
                buffer=$c
            else
                args+=("$c");
            fi
        else
            if [[ $c == *"\"" ]]; then
                buffer+=" $c";
                args+=("$(echo "$buffer" | tr -d '"')");
                buffer=""
            else
                buffer+=" $c";
            fi
        fi
    done

    source ../omnicli.sh

    if [ ! -z "$confFile" ]; then
        omnicli -c "$confFile" --debug "${args[@]}"
    else
        omnicli --debug "${args[@]}"
    fi
done
