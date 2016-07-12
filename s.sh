#!/bin/bash

case "$1" in
    attach|detach|block|a|d|b)
        mode="$1"
        shift
        ;;
    *)
        ;;
esac

function join { local IFS="$1"; shift; echo "$*"; }

sessionname=$(join \# ${*//-/})

echo ./run.sh $*

case $mode in
    block|b)
        screen -D -m -S "$sessionname" ./run.sh $*
        ;;
    detach|d)
        screen -d -m -S "$sessionname" ./run.sh $*
        ;;
    *)
        screen -S "$sessionname" ./run.sh $*
        ;;
esac
