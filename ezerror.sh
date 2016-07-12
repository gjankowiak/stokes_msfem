#!/bin/bash

n=4
dir1=""
dir2=""

if [ -z "$1" ]
then
    echo "Usage: $0 [--n n] [refdir] [testdir]"
    exit 1
fi

while [ -n "$1" ]
do
    case "$1" in
        "--n")
            shift
            n="$1"
        ;;
        *)
            if [ -z "$dir1" ];
            then
                dir1=$PWD/$1
            else
                dir2=$PWD/$1
            fi
        ;;
    esac
    shift
done

basedir="$PWD"

sed -e "s+#DIR2#+${dir2}+" -e "s+#n#+${n}+" <plot_error.edp.in >plot_error.edp

cd "$dir1" || exit 1
ls
FF_VERBOSITY=0 FreeFem++ "${basedir}/plot_error.edp"
