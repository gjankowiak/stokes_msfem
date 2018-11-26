#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <config> <Nf>"
    exit 1
fi

config=$1
Nf=$2

sed -e "s/#config#/$config/" -e "s/#Nf#/$Nf/" <plot_holes.edp.in >plot_holes.edp
bash ./prepare_params.sh $config $Nf 3 3 false
FF_VERBOSITY=0 FreeFem++ plot_holes.edp
