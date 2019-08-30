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

_OC_STRUCT_CLI='1'
_OC_STRUCT_CMDNAME='2'
_OC_STRUCT_CMD='3'
_OC_STRUCT_DESC='4'

#
# ─── FUNCTIONS ──────────────────────────────────────────────────────────────────
#

# Print help
function _oc_help() {
    cat << EOF
Usage: $0 TBD

TODO

EOF
}

# echo that ensure to write to the user terminal
function _echot() {
    >&1 echo -e "$@"
}

function _debug() {
    if [[ $_OC_DEBUG == 1 ]]; then
        echo -e "$@" >> "$_OC_DEBUG_FILE"
    fi
}

function _parse_config() {
    local line=$1;
    local part=$2;

    case $part in
        'cli')          echo "$line" | awk -F $_OC_DELIMITER "{print \$$_OC_STRUCT_CLI}";;
        'cmdName')      echo "$line" | awk -F $_OC_DELIMITER "{print \$$_OC_STRUCT_CMDNAME}";;
        'cmd')          echo "$line" | awk -F $_OC_DELIMITER "{print \$$_OC_STRUCT_CMD}";;
        'description')  echo "$line" | awk -F $_OC_DELIMITER "{print \$$_OC_STRUCT_DESC}";;
        *)              echo "";;
    esac
}

function _oc_command_exists() {
    local cli=$1;
    local cmdName=$2;
    
    if ! grep -Fq "$cli$_OC_DELIMITER$cmdName" "$_OC_CONFIG_FILE"; then
        return 1;
    fi
    
    return 0;
}

function _oc_find_command() {
    local cli=$1;
    local cmdName=$2;
    
    local cmd="";
    while read -r line; do
        lCli="$(_parse_config "$line" 'cli')"
        lCmdName="$(_parse_config "$line" 'cmdName')";
        
        if [[ $lCli == "$cli" && $lCmdName == "$cmdName" ]]; then
            cmd="$(echo "$line" | awk -F $_OC_DELIMITER '{print $3}')";
            break;
        fi
    done < "$_OC_CONFIG_FILE"
    
    if [[ $cmd == "" ]]; then
        _echot "This command does not exist";
        return 1;
    fi
    
    eval "$cmd"
    return $?;
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
    
    if ! _oc_command_exists "$1" "$2"; then
        _echot "Command not found"
        # TODO: show available commands
        return 1;
    fi
    
    _oc_find_command "$1" "$2"
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
            '-r'|'--register')  action='register';;
            '-d'|'--delete')    action='delete';;
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
        'register') echo "TODO";;
        'delete')   echo "TODO";;
        'list')     echo "list CLIs"; echo "TODO";;
        'exec')     _oc_exec "${args[@]}";;
        'help')     _oc_help;;
    esac

    return $?;
}
