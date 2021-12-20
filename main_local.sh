#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/"	


t1=${1}
mask=${2}
outputdir=$3

if [ $# -lt 2 ]; then												
		echo $0: "usage: "$( basename $0 )" <t1.ext> <mask.ext> [<outputdir>]"
		return 1;		    
fi 

echo "t1: "${t1}
echo "mask: "${mask}
echo "outputdir: "${outputdir}
[ -z ${outputdir} ] && { outputdir=${input_dir}"/segmentation" ; }
mkdir -p ${outputdir}
 ( [ -z "${mask}" ]  || [  "${mask}" == "null" ] ) || { mask_opt="  ${mask} "; }

outputdir_0=${outputdir}"/outputdir"
outputdir_1=${outputdir}"/segmentation"

nthreads=2

template_dir=${SCRIPT_DIR}'/data/PTBP/'
bash ${SCRIPT_DIR}'/antsCorticalThicknessSegmentation.sh' ${t1} ${template_dir} ${nthreads} ${outputdir_0} ${mask_opt}

# save outputfile 

mkdir -p ${outputdir_1}

cp ${outputdir_0}'/BrainSegmentation.nii.gz'	${outputdir_1}'/segmentation.nii.gz'
cp ${SCRIPT_DIR}'/data/label.json' ${outputdir_1}

