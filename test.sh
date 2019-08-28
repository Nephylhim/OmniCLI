#!/bin/bash

# reflex -d none -s -r '.sh' -- bash -c "clear; bash omnicli.sh; echo -e \"\n\n__________________________________\n\"; bash omnicli.sh asdf"

# shellcheck disable=SC1091
source ./omnicli.sh;

separator="\\n__________________________________";

# ────────────────────────────────────────────────────────────────────────────────

function testFn() {
    cmd=$1

    echo -e "Cmd: $cmd\\n---"
    eval "$cmd"
    echo -e $separator
}

cp test/oc_config_test test/oc_config
clear;
# echo -e "omnicli\n"
# omnicli

# echo -e $separator
# echo -e "omnicli -h\n"
# omnicli -h

# echo -e $separator
# echo -e "omnicli -l\n"
# omnicli -l

# echo -e $separator
# echo -e "omnicli asdf yolo\n"
# omnicli asdf yolo

testFn "omnicli"
testFn "omnicli -h"
testFn "omnicli -l"

testFn "omnicli test echo"
testFn "omnicli -c test/oc_config test echo"
