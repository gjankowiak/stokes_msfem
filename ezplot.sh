#!/bin/bash

if [ "$#" -ne 1 ];
then
    echo "Usage: $0 <data_dir>"
    exit 1
fi

dir=$1

basedir="$PWD"

cd "$dir" || exit 1
ls
#LD_LIBRARY_PATH=/scratch/scratch/opt/freefem/lib/ff++/3.59/lib/ FF_VERBOSITY=100 FreeFem++ "${basedir}/plot.edp"
FF_VERBOSITY=100 FreeFem++ "${basedir}/plot.edp"

gzip *.vtk
