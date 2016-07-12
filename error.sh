#!/bin/bash

listconfigs()
{
    avail_configs=()
    for config in configs/*; do
        avail_configs+=("${config/configs\//}")
    done
}

printhelp()
{
    echo "Usage: $0 <config> <Nf> [--basedir bd]"
    return 0
}

./make_links.sh

declare -a avail_configs=()
listconfigs

config=$1
if [[ " ${avail_configs[@]} " =~ " ${config} " ]];
then
    shift
else
    printhelp
    exit 1
fi

bd=.

Nf=$1
if [[ $Nf =~ ^-?[0-9]+$ ]]
then
    true
else
    echo "Invalid value for --Nf"
    printhelp
    exit 1
fi

shift

while [ -n "$1" ]
do
    case "$1" in
        "--basedir")
            shift
            bd=$1
            if [ ! -d "$bd" ]
            then
                echo "Directory '$bd' does not exist."
                exit 1
            fi
        ;;
        *)
            echo "Unkown option '$1'"
            printhelp
            exit 1
    esac
    shift
done

ref_dir="${bd}/REF_${config}_data"

FF_VERBOSE=0

for CRk in 2 3
do
    pb_dir="${bd}/CR${CRk}_${config}_data"
    date=$(date +%Y-%m-%d_%H:%M:%S)

    sed -e "s/#config#/${config}/" -e "s/#Nf#/${Nf}/" -e "s!#refdir#!${ref_dir}!" -e "s!#crkdir#!${pb_dir}!" -e "s/#CRk#/${CRk}/" <error.edp.in >error.edp

    FF_VERBOSITY=0 FreeFem++ error.edp

    mv "${pb_dir}/.error_${Nf}.csv" "${pb_dir}/error_${Nf}_${date}.csv"
    ln -f -s "error_${Nf}_${date}.csv" "${pb_dir}/error_${Nf}.csv"
    cat "${pb_dir}/error_${Nf}.csv"
done
