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

_ocDelimiter='■■';
_ocConfigFile="$HOME/.omnicli";

_ocPartsPlace=(['cliName']=1 ['cmdName']=2) # TODO

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

function _oc_command_exists() {
    # TODO
    return 0;
}

function _oc_find_command() {
    cli=$1;
    cmdName=$2;
    
    if [[ $cli == "" ]]; then
        _echot "cli must be specified\\n";
        _oc_help;
        return 1;
    fi
    if [[ $cmdName == "" ]]; then
        _echot "command must be specified\\n";
        _oc_help;
        return 1;
    fi
    
    cmd="";
    while read -r line; do
        # if [[ $line == "·"* ]]; then
        #     # echo "group line: $line => continue"
        #     continue;
        # fi
        # echo "line: $line"

        lCli="$(echo "$line" | awk -F $_ocDelimiter '{print $1}')";
        lCmdName="$(echo "$line" | awk -F $_ocDelimiter '{print $2}')";
        # _echot $lCli;
        # _echot $lCmdName;
        if [[ $lCli == "$cli" && $lCmdName == "$cmdName" ]]; then
            cmd="$(echo "$line" | awk -F $_ocDelimiter '{print $3}')";
            break;
        fi
    done < "$_ocConfigFile"

    if [[ $cmd == "" ]]; then
        _echot "This command does not exist";
        return 1;
    fi

    eval "$cmd"
}

function _oc_exec() {
    _oc_find_command "$1" "$2"
    
    return
}

#
# ─── OMNICLI ────────────────────────────────────────────────────────────────────
#

function omnicli() {
    # if [ ! -e _ocConfigFile ]; then
    #     touch _ocConfigFile
    # fi
    
    if [[ $# == 0 ]]; then
        _oc_help
        return 1;
    fi
    
    
    args=()
    action="" # TODO !!
    while [[ $# -gt 0 ]]; do
        arg=$1
        
        case $arg in
            '-c'|'--config')    shift; _ocConfigFile=$1;;
            '-r'|'--register')  echo "add a new CLI";;
            '-d'|'--delete')    echo "delete a CLI";;
            '-h'|'--help')      _oc_help; return;;
            '-l'|'--list')      echo "list CLIs";;
            *)                  args+=("$arg");;
        esac

        shift
    done

    _oc_exec "${args[@]}";
}
