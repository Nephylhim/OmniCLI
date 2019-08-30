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
    read -r input
    read -ra cmd <<< "$input"
    export _OC_DEBUG=1
    rm "$debugFile" 2> /dev/null
    source ../omnicli.sh

    if [ ! -z "$confFile" ]; then
        omnicli -c "$confFile" --debug "${cmd[@]}"
    else
        omnicli --debug "${cmd[@]}"
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
