#!/bin/bash

config=$1
Nf=$2

sed -e "s/#config#/$config/" -e "s/#Nf#/$Nf/" <plot_holes.edp.in >plot_holes.edp
bash ./prepare_params.sh $config $Nf 3 3 false
FF_VERBOSITY=0 FreeFem++ plot_holes.edp
