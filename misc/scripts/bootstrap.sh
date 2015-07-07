#!/bin/bash

export SCRIPT_DIR=$(dirname "$0")

##
## Bootstrap Process
##

main ()
{
    local submodules=$(git submodule status)
    local result=$?

    if [ "$result" -ne "0" ]
    then
        exit $result
    fi

    if [ -n "$submodules" ]
    then
        echo "*** Updating submodules..."
        update_submodules
    fi
}

bootstrap_submodule ()
{
    local bootstrap="script/bootstrap"

    if [ -e "$bootstrap" ]
    then
        echo "*** Bootstrapping $name..."
        "$bootstrap" >/dev/null
    else
        update_submodules
    fi
}

update_submodules ()
{
    git submodule sync --quiet && git submodule update --init && git submodule foreach --quiet bootstrap_submodule
}

export -f bootstrap_submodule
export -f update_submodules

main