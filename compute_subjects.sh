#! /bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/"	
testset_dir=$1
output_dir=$2

########################################################################
## Functions
########################################################################
exists () {
                                      			
		if [ $# -lt 1 ]; then
		    echo $0: "usage: exists <filename> "
		    echo "    echo 1 if the file (or folder) exists, 0 otherwise"
		    return 1;		    
		fi 
		
		if [ -d "${1}" ]; then 

			echo 1;
		else
			([ -e "${1}" ] && [ -f "${1}" ]) && { echo 1; } || { echo 0; }	
		fi		
		};

########################################################################
## Main
########################################################################

for i in $( ls ${testset_dir}/* -d ); do
	b_name_i=$( basename ${i} )
	[ "${b_name_i}" == "bids" ] && { continue; }
	[ -d ${i} ] || { continue; }
	echo ${i}	
	t1_i=$( ls ${i}'/dt-neuro-anat-t1w.id-'*/'t1.nii.gz' )
	mask_i=$( ls ${i}'/dt-neuro-mask.id-'*/'mask.nii.gz' )
	parc_i=$( ls ${i}'/dt-neuro-parcellation-volume.id-'*/'parc.nii.gz' )
	echo ${t1_i}
	echo ${mask_i}
	echo ${parc_i}
	output_dir_i=${output_dir}'/'$( basename ${i}  )'/'
	echo ${output_dir_i}
	mkdir -p ${output_dir_i}
	output_seg=${output_dir_i}'/segmentation/segmentation.nii.gz'	
	[ $( exists ${output_seg} ) -eq 1 ] || { bash  ${SCRIPT_DIR}/main_local.sh  ${t1_i} ${mask_i}  ${output_dir_i}  ; } \
										&& { echo "Brain tissue segmentation already done for "${b_name_i} ; }

done
