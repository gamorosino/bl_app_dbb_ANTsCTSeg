#!/bin/bash

	SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/"	
	computed=${1}
	groud_truth=${2}
	output=$3
	if [ $# -lt 1 ]; then												
		echo $0: "usage: "$( basename $0 )" <segmentation1.ext> <segmentation2.ext> [<output>]"
		return 1;		    
	fi 





if  ! ( [ -z "${computed}" ]  || [  "${computed}" == "null" ] || [ -z "${groud_truth}" ]  || [  "${groud_truth}" == "null" ]   ); then

	echo "computed: "${computed}
	echo "groud_truth: "${groud_truth}
	
	inputidr=$( dirname ${computed} )

	[ -z ${output} ] && { output=${inputidr}"/dice_score.txt" ; }

	
	python   ${SCRIPT_DIR}/dice_score.py  ${computed} ${groud_truth} ${output}	

	


fi
