# shellcheck shell=bash

# MIT License
#
# Copyright (c) 2019 Thomas Coussot
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


#
# ─── INIT ───────────────────────────────────────────────────────────────────────
#

# usedShell=`ps -hp $$|awk 'END {print $NF;}'`

# if [[ $usedShell == *"bash"* ]]; then
#     my_dir="$(dirname "${BASH_SOURCE[0]}")"
# elif [[ $usedShell == *"zsh"* ]]; then
#     my_dir="$(dirname "$0")"
# fi

# Set debug to 0 by default
if [[ -z $_OC_DEBUG ]]; then
    _OC_DEBUG=0;
fi
# Set debug file default
if [[ -z $_OC_DEBUG_FILE ]]; then
    _OC_DEBUG_FILE="/tmp/ocDebug.log";
fi

# Set default delimiter if it isn't set
if [[ -z $_OC_DELIMITER ]]; then
    _OC_DELIMITER='■■';
fi

# Set default config file path if it isn't set
if [[ -z $_OC_CONFIG_FILE ]]; then
    _OC_CONFIG_FILE="$HOME/.omnicli";
fi

# Set auto register default
if [[ -z $_OC_AUTO_REGISTER ]]; then
    _OC_AUTO_REGISTER=1;
fi


# Set default colors
if [[ -z $_OC_COLOR_1 ]]; then
    _OC_COLOR_1='\033[0;31m'; # red
fi
if [[ -z $_OC_COLOR_2 ]]; then
    _OC_COLOR_2='\033[1;34m'; # red
fi
_NC='\033[0m' # No Color

_OC_STRUCT_CLI='1'
_OC_STRUCT_CMDORDER='2'
_OC_STRUCT_CMDNAME='3'
_OC_STRUCT_CMD='4'
_OC_STRUCT_DESC='5'

#
# ─── FUNCTIONS ──────────────────────────────────────────────────────────────────
#

# echo that ensure to write to the user terminal
function _echot() {
    >&1 echo -e "$@"
}

function _debug() {
    if [[ $_OC_DEBUG == 1 ]]; then
        echo -e "$@" >> "$_OC_DEBUG_FILE"
    fi
}

# ────────────────────────────────────────────────────────────────────────────────

function _oc_parse_config() {
    local line=$1;
    local part=$2;

    case $part in
        'cli')          echo "$line" | awk -F $_OC_DELIMITER "{print \$$_OC_STRUCT_CLI}";;
        'order')        echo "$line" | awk -F $_OC_DELIMITER "{print \$$_OC_STRUCT_CMDORDER}";;
        'cmdName')      echo "$line" | awk -F $_OC_DELIMITER "{print \$$_OC_STRUCT_CMDNAME}";;
        'cmd')          echo "$line" | awk -F $_OC_DELIMITER "{print \$$_OC_STRUCT_CMD}";;
        'description')  echo "$line" | awk -F $_OC_DELIMITER "{print \$$_OC_STRUCT_DESC}";;
        *)              echo "";;
    esac
}

function _oc_verify_cli_exists() {
    local cli=$1;

    if ! grep -Eq "^$cli$_OC_DELIMITER" "$_OC_CONFIG_FILE"; then
        return 1;
    fi

    return 0;
}

function _oc_verify_command_exists() {
    local cli=$1;
    local cmdName=$2;
    
    # shellcheck disable=SC1087
    # if ! grep -Eq "^$cli$_OC_DELIMITER[0-9]+$_OC_DELIMITER$cmdName$_OC_DELIMITER" "$_OC_CONFIG_FILE"; then
    if ! grep -Eq "^$cli$_OC_DELIMITER.{2,4}$_OC_DELIMITER$cmdName$_OC_DELIMITER" "$_OC_CONFIG_FILE"; then
        return 1;
    fi
    
    return 0;
}

function _oc_count_cli_commands() {
    local cli=$1;

    local count;
    count="$(grep -c "^$cli$_OC_DELIMITER" "$_OC_CONFIG_FILE")"
    echo "$count";
}

# ────────────────────────────────────────────────────────────────────────────────

# shellcheck disable=SC2005
function _oc_find_cli_cmd() {
    local cli=$1;
    local cmdName=$2;

    local line;
    # shellcheck disable=SC1087
    line="$(grep -E "^$cli$_OC_DELIMITER.{2,4}$_OC_DELIMITER$cmdName" < "$_OC_CONFIG_FILE")"
    _debug "command line: $line"

    echo "$(_oc_parse_config "$line" 'cmd')"
}

function _oc_exec_cli_cmd() {
    local cli=$1;
    local cmdName=$2;
    
    local cmd="";
    cmd="$(_oc_find_cli_cmd "$cli" "$cmdName")"
    
    eval "$cmd"
    return $?;
}

# TODO: function sort config file

function _oc_list_clis(){
    local clis;
    clis="$(sort < "$_OC_CONFIG_FILE" | awk -F '■■' "{print \$$_OC_STRUCT_CLI}" | uniq)";

    _echot "Available CLIs:";
    for cli in $clis; do
        _echot "    - $cli";
    done

    return $?;
}

function _oc_list_cli_comands(){
    local cli=$1;

    if ! _oc_verify_cli_exists "$cli"; then
        _echot "This CLI ($cli) does not exist"
        _debug "CLI $cli does not exist"
        return 1;
    fi

    _echot "Available commands for $_OC_COLOR_1$cli$_NC:";

    local commands;
    commands="$(grep "^$cli" < "$_OC_CONFIG_FILE" | sort | awk -F '■■' "{printf(\"    $_OC_COLOR_2%s$_NC:%s\\n\", \$$_OC_STRUCT_CMDNAME, \$$_OC_STRUCT_DESC)}")";
    _echot "$(echo -e "$commands" | column -s':' -te)";

    return $?;
}

# ────────────────────────────────────────────────────────────────────────────────

# Print help
# TODO: contextualize help if a scope is defined
function _oc_help() {
    cat << EOF
Usage: $0 TBD

TODO

EOF
}

function _oc_list() {
    local scope=$1;

    _debug "list scope: '$scope'"
    if [ -z "$scope" ]; then
        _debug "list CLIs"
        _oc_list_clis
    else
        _debug "list CLI commands"
        _oc_list_cli_comands "$scope";
    fi

    return $?;
}

function _oc_add() {
    local cli=$1;
    local cmdName=$2;
    local cmd=$3;
    local desc=$4;

    if [ $# -lt 4 ]; then
        _echot "There aren't enough arguments to create a new command."
        _oc_help;
    fi

    local order;
    order=$(($(_oc_count_cli_commands "$cli")+1))
    if [ $order -lt 10 ]; then
        order="0$order";
    fi
    _debug "order: $order"

    local line;
    line="$cli$_OC_DELIMITER$order$_OC_DELIMITER$cmdName$_OC_DELIMITER$cmd$_OC_DELIMITER$desc"
    _debug "new config line:\\n$line"

    echo "$line" >> "$_OC_CONFIG_FILE";

    _echot "Command $cmdName is created!\\n"
    _oc_list_cli_comands "$cli";

    # TODO: auto register if new cli

    return 0;
}

function _oc_delete() {
    local cli=$1;
    local cmdName=$2;

    # TODO: delete whole cli

    if ! _oc_verify_cli_exists "$1"; then
        _echot "This CLI ($cli) does not exist."
        _debug "CLI $cli does not exist"
        return 1;
    fi
    if ! _oc_verify_command_exists "$1" "$2"; then
        _echot "This command does not exist."
        _debug "Command $2 does not exist"
        _oc_list_cli_comands "$1"
        return 1;
    fi

    local line;
    line="$(_oc_find_cli_cmd "$cli" "$cmdName")"
    sed -i "/$line/d" "$_OC_CONFIG_FILE"

    _debug "config:\\n$(cat "$_OC_CONFIG_FILE")"

    _echot "The command $cli $cmdName have been deleted."
    return 0;
}

function _oc_register() {
    # TODO: if a scope is defined, only register the scope
    # TODO: verify command doesn't already exist
    
    for cli in $(awk -F "$_OC_DELIMITER" '{print $1}' < "$_OC_CONFIG_FILE" | uniq); do
        local al;
        al="alias $cli='omnicli -c $_OC_CONFIG_FILE $cli'"
        eval "$al";
    done

    return 0;
}

function _oc_exec() {
    if [ $# -lt 1 ]; then
        _echot "cli must be specified\\n";
        _oc_help;
        return 1;
    fi
    if [ $# -lt 2 ]; then
        _echot "command must be specified\\n";
        _oc_help;
        return 1;
    fi
    
    if ! _oc_verify_cli_exists "$1"; then
        _echot "This CLI ($cli) does not exist."
        _debug "CLI $cli does not exist"
        return 1;
    fi
    if ! _oc_verify_command_exists "$1" "$2"; then
        _echot "This command does not exist."
        _debug "Command $2 does not exist"
        _oc_list_cli_comands "$1"
        return 1;
    fi
    
    _oc_exec_cli_cmd "$1" "$2"
    return $?;
}

#
# ─── OMNICLI ────────────────────────────────────────────────────────────────────
#

function omnicli() {
    if [[ $# == 0 ]]; then
        _oc_help
        return 1;
    fi
    
    local args=();
    local action="exec";
    while [[ $# -gt 0 ]]; do
        local arg=$1;
        shift;
        
        case $arg in
            '-c'|'--config')    _OC_CONFIG_FILE=$1; shift;;
            '-a'|'--add')       action='add';;
            '-d'|'--delete')    action='delete';;
            '-r'|'--register')  action='register';;
            '-h'|'--help')      action='help';;
            '-l'|'--list')      action='list';;
            '--debug')          _OC_DEBUG=1;;
            *)                  args+=("$arg");;
        esac
    done
    
    _debug "Configuration file: $_OC_CONFIG_FILE"
    if [ ! -e "$_OC_CONFIG_FILE" ]; then
        _debug "Configuration file not found, creating it."
        touch "$_OC_CONFIG_FILE";
    fi
    
    _debug "action=$action; args=(${args[*]})"
    case $action in
        'add')      _oc_add "${args[@]}";;
        'delete')   _oc_delete "${args[@]}";;
        'register') _oc_register;;
        'list')     _oc_list "${args[@]}";;
        'exec')     _oc_exec "${args[@]}";;
        'help')     _oc_help;;
    esac

    return $?;
}

# ────────────────────────────────────────────────────────────────────────────────
# ────────────────────────────────────────────────────────────────────────────────

if [[ $_OC_AUTO_REGISTER == 1 ]]; then
    omnicli -r
fi
