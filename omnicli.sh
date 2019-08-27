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

delimiter='■■';
# configFile='~/.omnicli';
configFile='./test/oc_config';

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
    >&2 echo $@
}

function _oc_find_command() {
    cli=$1;
    cmd=$2;
    
    if [[ $cli == "" ]]; then
        _echot -e "cli must be specified\n";
        _oc_help;
        exit 1;
    fi
    if [[ $cmd == "" ]]; then
        _echot -e "command must be specified\n";
        _oc_help;
        exit 1;
    fi
    
    found=0;
    while read line; do
        # alias=${line%:*}
        # pwd=${line#*:}
        # if [[ $alias == $1 ]]; then
        #     cd $pwd;
        #     found=1
        #     break;
        # fi
        lcli="$(awk -F $delimiter '{print $1}')";
        _echot $lcli;
    done < $configFile
}

function _oc_exec() {
    _oc_find_command $1 $2
    
    return
}

#
# ─── OMNICLI ────────────────────────────────────────────────────────────────────
#

function omnicli() {
    if [ ! -e configFile ]; then
        touch configFile
    fi
    
    if [[ $# == 0 ]]; then
        _oc_help
    fi
    
    
    
    while [[ $# > 0 ]]; do
        arg=$1
        shift
        
        case $arg in
            '-c'|'--config')    echo "change config file";;
            '-r'|'--register')  echo "add a new CLI";;
            '-d'|'--delete')    echo "delete a CLI";;
            '-h'|'--help')      _oc_help;;
            '-l'|'--list')      echo "list CLIs";;
            *)                  _oc_exec $@;;
        esac
    done
}
