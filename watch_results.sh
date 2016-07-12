storage_dir=.diffcache

declare -a dirs=(channel_ref_data swirl_ref_data CR2_channel_data CR2_swirl_data CR3_channel_data CR3_swirl_data)

[ -d "$storage_dir" ] || mkdir $storage_dir

while true
do
    for d in "${dirs[@]}"
    do
        storage_file="${storage_dir}/${d}"
        #find directory1 -type d -printf "%P\n" | sort > file1
        #find directory2 -type d -printf "%P\n" | sort | diff - file1
        if [ -f "$storage_file" ]
        then
            changed=$(find "$d" -printf "%P\n" | sort | diff - "$storage_file" | grep ".dat")
            if [ "$?" = 0 ]
            then
                echo -e "$d\n$changed" | ssh gaspard@oknaj.eu mailx -s "Gauss\ computation\ result\ landed" gaspard
                echo $(date) >> "${storage_dir}/journal.txt"
                echo "$changed" >> "${storage_dir}/journal.txt"
            fi
        fi
        find "$d" -printf "%P\n" | sort > "$storage_file"
    done
    sleep 60
done
