config=$1
Nf=${2:-1024}
n=${3:-8}
CRk=${4:-3}
PP=${5:-false}
MO=${6:-1}
TGV=${7:-1e30}
JL=${8:-0}
echo "Preparing problem $config with Nf=$Nf and n=$n"
sed -e "s/#config#/${config}/" -e "s/#Nf#/$Nf/" -e "s/#n#/$n/" -e "s/#CRk#/$CRk/" -e "s/#PP#/$PP/" -e "s/#MO#/$MO/" -e "s/#TGV#/$TGV/" -e "s/#JL#/$JL/" <configs/${config}/params.edp.in >params.edp
exit $?
