#!/usr/bin/env bats

# load ../omnicli.sh

function setup() {
    cp oc_config_test oc_config
    >&2 source ../omnicli.sh
}

function teardown() {
    rm oc_config

    # In case of error, print output
    >&2 echo -e "output:\\n$output"
}

@test "omnicli without args" {
    run omnicli
    [ "$status" -eq 1 ]
    [ $(expr "${lines[0]}" : "Usage:") -ne 0 ]
}

@test "Show help" {
    run omnicli -h
    [ "$status" -eq 0 ]
    [ $(expr "${lines[0]}" : "Usage:") -ne 0 ]
}

@test "List CLIs" {
    skip
    run omnicli -l
    [ "$status" -eq 0 ]
    [ $(expr "${lines[0]}" : "Test") -ne 0 ]
}

@test "Test omnicli test:echo" {
    run omnicli -c oc_config test echo
    [ "$status" -eq 0 ]
    [ $(expr "$output" : "test") -ne 0 ]
}

@test "Test inexisting command" {
    run omnicli -c oc_config test unicorn
    [ "$status" -eq 1 ]
}

@test "Test omnicli cron:status" {
    run omnicli -c oc_config cron status
    [ "$status" -eq 0 ]
    [ $(expr "$output" : ".*cron.service") -ne 0 ]
}

