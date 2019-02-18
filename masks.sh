#!/bin/bash

function genmask {
    conf=$1
    config=${conf/configs\//}
    # Skip configs that have no holes defined or that are symlinks to other configs
    holes_file="configs/${config}/holes.edp"

    if [ -d "configs/${config}" -a -f "$holes_file" ];
    then
        echo "Generating masks cache for '${config}'"
    else
        echo "Config '${config}' is not available"
        exit 1
    fi

    [ ! -f "$holes_file" ] && continue
    [ -L "$holes_file" ] && continue
    masks_dir="configs/${config}/masks"
    [ -d "$masks_dir" ] || mkdir "$masks_dir"
    #for Nf in 2048 1024 512 256 128 16; do
    for Nf in 128; do
        echo "Nf: $Nf"
        [ -f "$masks_dir/${Nf}.dat" ] && continue
        sed -e "s/#config#/$config/" -e "s/#Nf#/$Nf/" <masks.edp.in >masks.edp
        bash ./prepare_params.sh $config $Nf 3 3 false 1
        FF_VERBOSITY=0 FreeFem++ masks.edp
    done
}

if [ -z "$1" ]
then
    for conf in configs/*; do
        genmask "$conf"
    done
else
    while [ -n "$1" ]; do
        genmask "$1"
        shift
    done
fi

