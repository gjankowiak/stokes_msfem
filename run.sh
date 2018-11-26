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
    echo "Usage: $0 <config> [--ref] [--penal-press] [--dry] [--Nf Nf] [--CRk k] [--max-obstr MO]"
    echo
    echo "Available configs: ${avail_configs[@]}"
    echo
    echo "Options:"
    echo " --ref         : solve the reference problem (FEM)"
    echo " --press-penal : use pressure penalization (defaults to false)"
    echo " --dry         : do a try run, ie do not save results"
    echo " --Nf          : fine mesh size"
    echo " --n           : comma separated coarse mesh sizes"
    echo "                 (default: 4,8,16,32,64,128)"
    echo " --CRk         : comma separated number of functions per edge"
    echo "                 can be 2 or 3 (default: 2,3)"
    echo " --tgv         : value to use as 'tgv' in FreeFem++"
    echo " --max-obstr   : maximum obstrusion for edges, between 0 and 1."
    echo "                 Edges obstructed by more than MO will have"
    echo "                 the associated basis functions discarded."
    echo "                 Defaults to 1 (no functions discarded)."
    echo " --jl-max-size : solve the MsFEM system externally (Julia)"
    echo "                 for coarse meshes less or equal to this value. (default: 0)"
    return 0
}

declare -a avail_configs=()
listconfigs

args=$*

declare -A options

case "$1" in
    -h|--help)
        printhelp
        exit 0
        ;;
esac

options[config]=$1
if [[ " ${avail_configs[@]} " =~ " ${options[config]} " ]];
then
    shift
else
    echo "Configuration '${options[config]}' unavailable"
    printhelp
    exit 1
fi

declare -a CRks=(2 3)
declare -a coarse_size=(4 8 16 32 64 128)

options[REF]=0
options[run_type]="FULL MSFEM"
options[PRG]="./_run.sh"
options[PP]="false"
options[DRY]=0
options[Nf]=1024
options[MO]=1
options[TGV]=1e30
options[JL]=0


REF=0
run_type="FULL MSFEM"
PRG="./_run.sh"

PP="false"
DRY=0
Nf=1024
MO=1
TGV=1e30
JL=0

while [ -n "$1" ]
do
    case "$1" in
        "--ref")
            options[REF]=1
            options[PRG]="./_run_ref.sh"
            options[run_type]="REFERENCE"
        ;;
        "--dry")
            options[DRY]=1
        ;;
        "--press-penal")
            options[PP]="true"
        ;;
        "--Nf")
            shift
            options[Nf]=$1
            if [[ $Nf =~ ^-?[0-9]+$ ]]
            then
                true
            else
                echo "Invalid value for --Nf"
                printhelp
                exit 1
            fi
        ;;
        "--n")
            shift
            IFS=',' read -r -a coarse_size <<< "$1"
        ;;
        "--CRk")
            shift
            echo $1
            IFS=',' read -r -a CRks <<< "$1"
            echo ${CRks[@]}
        ;;
        "--tgv")
            shift
            options[TGV]=$1
        ;;
        "--max-obstr")
            shift
            options[MO]=$1
        ;;
        "--jl-max-size")
            shift
            options[JL]=$1
        ;;
        *)
            echo "Unkown option '$1'"
            printhelp
            exit 1
    esac
    shift
done

configdir="configs/${options[config]}"

base_dir="$PWD"


for CRk in ${CRks[@]};
do
    if [[ " 2 3 " =~ " ${CRk} " ]];
    then
        :
    else
        echo "Skipping invalid value for CRk: '${CRk}'"
        continue
    fi

    options[CRk]=$CRk

    if [ "${options[REF]}" = "1" ]
    then
        dst_dir="$base_dir"/REF_${options[config]}_data
    else
        dst_dir="$base_dir"/CR${CRk}_${options[config]}_data
    fi

    journal_file="$dst_dir"/journal.txt

    echo "####################################"
    echo " Starting ${options[run_type]} run for '${options[config]}'"
    echo "   Nf : ${options[Nf]}"
    if [ "${options[run_type]}" = "FULL MSFEM" ]
    then
        echo "   CRk: ${options[CRk]}"
    fi
    echo "   PP : ${options[PP]}"
    echo "   PRG: ${options[PRG]}"
    echo "####################################"
    echo

    for n in ${coarse_size[@]};
    do
        if [[ " 2 4 8 16 32 64 128 256 512 1024 2048 " =~ " $n " ]];
        then
            :
        else
            echo "Skipping invalid coarse mesh size: '$n'"
            continue
        fi

        if [ "${options[REF]}" = 1 ]
        then
            n=1
        fi
        options[n]=$n

        date=$(date +%Y-%m-%d_%H:%M:%S)
        dated_dir="$dst_dir/$date"
        logfile="$dated_dir/run.log"

        echo -e "\E[34m\033[1mRunning '${options[config]}' with CRk=${options[CRk]}, Nf=${options[Nf]}, MO=${options[MO]} JL=${options[JL]} and n=${options[n]}\E[0m"
        echo -e "\E[34m\033[1mDir: $dated_dir\E[0m"

        mkdir -p "$dated_dir"
        if [ ! -d "$dated_dir" ]
        then
            echo "Unable to create destination directory, aborting!"
            exit 2
        fi

        for k in ${!options[@]};
        do
            echo "$k: ${options[$k]}" >> $dated_dir/options.txt
        done

        ./prepare_params.sh ${options[config]} ${options[Nf]} ${options[n]} ${options[CRk]} ${options[PP]} ${options[MO]} ${options[TGV]} ${options[JL]}

        #bash $PRG "$config" "$dated_dir" | tee "$logfile"
        bash ${options[PRG]} "${options[config]}" "$dated_dir" | grep -v "=========\\|x min max\\|MUMPS : time" | tee "$logfile"
        exitcode=${PIPESTATUS[0]}

        [ "${options[DRY]}" = 0 ] || rm -rf ${dated_dir}

        if [ "$exitcode" = 0 ]
        then
            echo -e "\E[32m\033[1m#\E[0m"
            echo -e "\E[32m\033[1m# SUCCESS\E[0m"
            [ ${options[DRY]} = 0 ] && echo -e "\E[32m\033[1m#         Dir: $dated_dir\E[0m"
            echo -e "\E[32m\033[1m#\E[0m"
        else
            echo -e "\E[31m\033[1m#\E[0m"
            echo -e "\E[31m\033[1m# FAILURE\E[0m"
            [ ${options[DRY]} = 0 ] && echo -e "\E[31m\033[1m#         Dir: $dated_dir\E[0m"
                        echo -e "\E[31m\033[1m#   Exit code: $exitcode\E[0m"
            echo -e "\E[31m\033[1m#\E[0m"
        fi

        if [ "${options[DRY]}" = 0 ]
        then
            if [ "${options[REF]}" = 1 ]
            then
                if [ ! -f "$journal_file" ]
                then
                    echo "Date | exit code | config | Nf" > "$journal_file"
                fi
                echo -e "$date\t$exitcode\t${options[config]}\t${options[Nf]}" >> "$journal_file"
            else
                if [ ! -f "$journal_file" ]
                then
                    echo "Date | exit code | config | CRk | Nf | n" > "$journal_file"
                fi
                echo -e "$date\t$exitcode\t${options[config]}\t${options[CRk]}\t${options[Nf]}\t${options[n]}" >> "$journal_file"
            fi
        fi

        if [ "${options[REF]}" = "1" ]
        then
            break
        fi

        sleep 1
    done
    if [ "${options[REF]}" = "1" ]
    then
        echo "Reference run finished."
        break
    fi
done

if [ "${options[DRY]}" = 0 ]; then
    echo -e "Config: ${options[config]}\nNf:    ${options[Nf]}\nExit code: $exitcode" | cat - <(tail -n 500 "$logfile") | ssh gaspard@garnesier.oknaj.eu mailx -s "Stokes MSFEM\ computation\ complete" gaspard@math.janko.fr
fi
