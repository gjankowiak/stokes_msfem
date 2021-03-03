#!/bin/bash

shopt -s failglob

function join_by { local IFS="$1"; shift; echo "$*"; }

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

bd=/scratch/scratch/jankowiak/msfem

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

FF_VERBOSE=0
declare -a available_mesh_sizes

for CRk in 2 3
do
    ref_dir="${bd}/REF_${config}_data"
    pb_dir="${bd}/CR${CRk}_${config}_data"
    date=$(date +%Y-%m-%d_%H:%M:%S)

    available_mesh_sizes=()

    globbed_dirs=($pb_dir/$Nf-*)
    for d in ${globbed_dirs[@]};
    do
        stripped=${d#$pb_dir/}
        available_mesh_sizes+=(${stripped/$Nf-/})
    done

    #available_mesh_sizes=(4 10 20 45)

    sizes_string=$(join_by , ${available_mesh_sizes[@]})
    first_size=${available_mesh_sizes[0]}

    echo "Found the following mesh sizes:"
    echo ${available_mesh_sizes[@]}

    sed -e "s/#config#/${config}/" -e "s/#Nf#/${Nf}/" -e "s!#refdir#!${ref_dir}!" -e "s!#crkdir#!${pb_dir}!" -e "s/#CRk#/${CRk}/" -e "s/#nbase#/$first_size/" -e "s/#sizes#/$sizes_string/" <error2.edp.in >error2.edp

    FF_VERBOSITY=0 FreeFem++ error2.edp

    mv "${pb_dir}/.error_${Nf}.csv" "${pb_dir}/error_${Nf}_${date}.csv"
    ln -f -s "error_${Nf}_${date}.csv" "${pb_dir}/error_${Nf}.csv"
    cat "${pb_dir}/error_${Nf}.csv"
done
