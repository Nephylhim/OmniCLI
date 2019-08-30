#!/bin/bash

# shellcheck disable=SC1091

NC='\033[0m' # No Color
RED='\033[0;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'

confFile=$1
debugFile="/tmp/ocDebug.log"

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

    export _OC_DEBUG=1
    rm "$debugFile" 2> /dev/null
    source ../omnicli.sh

    if [ ! -z "$confFile" ]; then
        omnicli -c "$confFile" --debug "${args[@]}"
    else
        omnicli --debug "${args[@]}"
    fi
    status=$?

    echo -e "\\n\\n${YELLOW}DEBUG:\\n__________________________________________"
    echo -e "$(cat "$debugFile")"

    echo -e "__________________________________________${NC}"
    if [[ $status == 0 ]]; then
        echo -e "${GREEN}omnicli exited with status $status${NC}\\n\\n\\n"
    else
        echo -e "${RED}omnicli exited with status $status${NC}\\n\\n\\n"
    fi
done
