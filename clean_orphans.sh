#!/bin/bash

BASEDIR="/scratch/scratch/jankowiak/msfem"

function clean_dirs {
    indexed_dirs=()

    if [[ ! -f journal.txt ]];
    then
        return 1
    fi
    head -n 1 journal.txt > journal.txt.new
    while read line; do
        dirname=$(echo $line | awk '{print $1}')
        if [ -d "$dirname" ]
        then
            s=""
            indexed_dirs+=("${dirname}")
        else
            s="# "
        fi
        [ "$s" = "# " ] && echo "removing journal entry for ${PWD#$BASEDIR/}/$dirname"
        echo "$s$line" >> journal.txt.new
    done < <(tail -n+2 journal.txt)
    for d in $(find . -mindepth 1 -maxdepth 1 -type d -printf "%P\n")
    do
        if [[ " ${indexed_dirs[@]} " =~ " ${d} " ]]
        then
            :
        else
            echo "removing orphan dir ${PWD#$BASEDIR/}/$d"
            rm -rf "$d"
        fi
    done
    grep -v '^#' journal.txt.new > journal.txt
}

cd "$BASEDIR"
for d in CR*_data REF*_data
do
    cd "$d"
    clean_dirs
    cd "$BASEDIR"
done
