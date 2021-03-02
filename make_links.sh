#!/bin/bash

base_dir="/scratch/scratch/jankowiak/msfem"

if [ "$1" = "--clean" ]
then
    bash ./clean_orphans.sh
fi

for d in $base_dir/CR*_data
do
    cd "$d"
    while read line; do
        target=$(echo $line | awk '{print $1}')
        link_name=$(echo $line | awk '{print $5"-"$6}')
        previous_target=$(readlink "$link_name")
        if [ "$target" = "$previous_target" ]
        then
            #echo "Skipping ${PWD#$base_dir/}/$target ($link_name)"
            continue
        fi
        echo "Updating ${PWD#$base_dir/}/$link_name → ${PWD#$base_dir/}/$target"
        ln -n -f -s "$target" "$link_name";
    done < <(tail -n+2 journal.txt)
    cd "$base_dir"
done

for d in REF_*_data
do
    cd "$d"
    while read line; do
        target=$(echo $line | awk '{print $1}')
        link_name=$(echo $line | awk '{print $4}')
        previous_target=$(readlink "$link_name")
        [ "$target" = "$previous_target" ] && continue
        echo "Updating ${PWD#$base_dir/}/$link_name → ${PWD#$base_dir/}/$target"
        ln -n -f -s "$target" "$link_name";
    done < <(tail -n+2 journal.txt)
    cd "$base_dir"
done
