#!/bin/bash

BASEDIR="$PWD"

if [ "$1" = "--clean" ]
then
    bash ./clean_orphans.sh
fi

for d in CR*_data
do
    cd "$d"
    while read line; do
        target=$(echo $line | awk '{print $1}')
        link_name=$(echo $line | awk '{print $5"-"$6}')
        previous_target=$(readlink "$link_name")
        if [ "$target" = "$previous_target" ]
        then
            #echo "Skipping ${PWD#$BASEDIR/}/$target ($link_name)"
            continue
        fi
        echo "Updating ${PWD#$BASEDIR/}/$link_name → ${PWD#$BASEDIR/}/$target"
        ln -n -f -s "$target" "$link_name";
    done < <(tail -n+2 journal.txt)
    cd "$BASEDIR"
done

for d in REF_*_data
do
    cd "$d"
    while read line; do
        target=$(echo $line | awk '{print $1}')
        link_name=$(echo $line | awk '{print $4}')
        previous_target=$(readlink "$link_name")
        [ "$target" = "$previous_target" ] && continue
        echo "Updating ${PWD#$BASEDIR/}/$link_name → ${PWD#$BASEDIR/}/$target"
        ln -n -f -s "$target" "$link_name";
    done < <(tail -n+2 journal.txt)
    cd "$BASEDIR"
done
