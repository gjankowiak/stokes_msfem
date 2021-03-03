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
    echo "Usage: $0 <config> <dst_dir>"
    return 0
}

if [[ "$0" =~ "run_ref.sh" ]]
then
    method=REF
else
    method=CRk
fi

declare -a avail_configs=()
listconfigs

config=$1
if [[ " ${avail_configs[@]} " =~ " ${config} " ]];
then
    true
else
    echo "Configuration '${config}' unavailable"
    printhelp
    exit 1
fi

shift

dst_dir="$1"
basedir=$PWD

if [ "$dst_dir" == "" ]
then
    echo "You must provide a destination directory"
    printhelp
    exit 1
fi

[ -d "$dst_dir" ] || mkdir -p "$dst_dir" || exit 666
#cp {${method},params,defs,holes}_${config}.edp ${method}_main.edp save.edp mpi.edp utils.edp "$dst_dir"
cp params.edp defs.edp configs/${config}/{bcs,holes}.edp utils.edp ${method}_{compute,main}.edp save.edp mpi.edp julia_freefem_io.jl juliasolve.jl "$dst_dir"
cd "$dst_dir" || exit 666

echo "$method" > method.txt

#export FF_VERBOSITY=0

ulimit -v 30000000

EDPFILE="${method}_main.edp"

#if [ "$HOSTNAME" == "greygoo" ]
if [ "$method" == "REF" ]
then
    FreeFem++ "$EDPFILE"
else
    #FreeFem++ "$EDPFILE"
    ff-mpirun -n 1 "$EDPFILE"
fi
