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
    run omnicli -c oc_config -l
    [ "$status" -eq 0 ]
    [ $(expr "${lines[0]}" : "Available CLIs:") -ne 0 ]
    [ $(expr "${lines[1]}" : "    - cron") -ne 0 ]
}

@test "List CLI commands" {
    run omnicli -c oc_config test -l
    [ "$status" -eq 0 ]
    [ $(expr "${lines[0]}" : ".*test.*:") -ne 0 ] # Colors are captured by expr
    [ $(expr "${lines[1]}" : ".*echo.*just echo \"test\"") -ne 0 ]
}

@test "List inexisting CLI commands" {
    run omnicli -c oc_config poney -l
    [ "$status" -eq 1 ]
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

@test "Test failing command" {
    run omnicli -c oc_config test fail
    [ "$status" -eq 1 ]
    [ $(expr "$output" : "it fail!") -ne 0 ]
}

@test "Test omnicli cron:status" {
    run omnicli -c oc_config cron status
    [ "$status" -eq 0 ]
    [ $(expr "$output" : ".*cron.service") -ne 0 ]
}

@test "register a command" {
    # TODO
    skip
}

@test "delete a command" {
    # TODO
    skip
}
