# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific aliases and functions
test -s ~/bin/bladefunctions && . ~/bin/bladefunctions || true

# Find all files with specified file extensions
# Example:
# $ findall cc java proto
function findall() {
    local exts="$@"
    local expr=''
    for ext in $exts; do
        if [ -z "$expr" ]; then
            expr="-name *.$ext"
        else
            expr+=" -or -name *.$ext"
        fi
    done
    ( set -f; find $expr | grep -Ev 'build(32|64)_(debug_release)' )
}

# Generate a find* command alias for specified file extensions
# Params:
#  $1 alias name
#  $2 a string contains specified file extensions, must be quoted if more than one
function generate_find_aliase() {
    local name="$1"
    local exts="$2"
    local expr=''
    for ext in $exts; do
        if [ -z "$expr" ]; then
            expr="-name '*.$ext'"
        else
            expr+=" -or -name '*.$ext'"
        fi
    done
    local find_cmd="find $expr | grep -Ev 'build(32|64)_(debug_release)'"
    alias $name="$find_cmd"
}

function generate_all_find_aliases() {
    local cc_src="c cc cpp cxx c++ C"
    local cc_h="h hh hpp hxx H"
    local cc="$cc_src $cc_h"
    generate_find_aliase findallh "$cc_h"
    generate_find_aliase findallccsrc "$cc_src"
    generate_find_aliase findallcc "$cc"
    generate_find_aliase findalljava java
    generate_find_aliase findallgo go
    generate_find_aliase findallcode "$cc java proto py js scala sh go"
}

generate_all_find_aliases

export GREP_OPTIONS="--color --exclude=\*.svn\*"
export EDITOR=vim
export FIGNORE=svn
