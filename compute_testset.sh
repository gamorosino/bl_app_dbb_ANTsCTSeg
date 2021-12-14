#! /bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/"	
testset_dir=$1
output_dir=$2
if [ $# -lt 1 ]; then												
		echo $0: "usage: "$( basename $0 )" <test_set_dir> [<output_dir>]"
		return 1;		    
fi 
predict_script=${SCRIPT_DIR}/"main.sh"
disce_score_script=${SCRIPT_DIR}/"dice_score.sh"
[ -z ${output_dir} ] && { output_dir=${testset_dir}'/bids/derivatives/bl_app_dbb_ANTsCTSeg/' ; }
mkdir -p ${output_dir}
for i in $( ls ${testset_dir}/* -d ); do
	b_name_i=$( basename ${i} )
	[ "${b_name_i}" == "bids" ] && { continue; }
	[ -d ${i} ] || { continue; }
	echo ${i}
	t1_i=$( ls ${i}'/dt-neuro-anat-t1w.id-'*/'t1.nii.gz' )
	mask_i=$( ls ${i}'/dt-neuro-mask.id-'*/'mask.nii.gz' )
	parc_i=$( ls ${i}'/dt-neuro-parcellation-volume.id-'*/'parc.nii.gz' )
	echo 't1': ${t1_i}
	echo 'mask': ${mask_i}
	echo 'parc': ${parc_i}
	output_dir_i=${output_dir}'/'$( basename ${i}  )'/'
	echo ${output_dir_i}
	mkdir -p ${output_dir_i}
	bash ${predict_script} ${t1_i} ${mask_i} ${output_dir_i}'/'
	output_seg=${output_dir_i}'/segmentation.nii.gz'	
	dice_score=${output_dir_i}'/dice_score.txt'
	bash ${disce_score_script} ${output_seg} ${parc_i} ${dice_score}
	cat ${dice_score}
done

csv_file=${output_dir}'/dice_score.csv'

echo "Subject_Id CSF GM WM DGM Brainstem Cerebellum"

echo "Subject_Id CSF GM WM DGM Brainstem Cerebellum" > ${csv_file}

for i in $( ls ${output_dir}/* -d ); do

	echo $( basename ${i} ) $( cat ${i}'/dice_score.txt' )
	echo $( basename ${i} ) $( cat ${i}'/dice_score.txt' ) >> ${csv_file}

done
