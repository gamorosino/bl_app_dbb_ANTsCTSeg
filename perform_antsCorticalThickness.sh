#!bin\bash

t1=${1}
TEMPLATE_FOLDER=${2}
ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=${3}				# multi-threading (per le funzioni di ANTs)
segment_dir=${4}"/"

mkdir -p ${segment_dir}
export ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS

bash ${ANTSPATH}/antsCorticalThickness.sh -d 3 -a ${t1} \
							-e ${TEMPLATE_FOLDER}PTBP_T1_Head.nii.gz \
							-m ${TEMPLATE_FOLDER}PTBP_T1_BrainCerebellumProbabilityMask.nii.gz \
							-p ${TEMPLATE_FOLDER}Priors/priors%d.nii.gz \
							-f ${TEMPLATE_FOLDER}PTBP_T1_ExtractionMask.nii.gz \
							-t ${TEMPLATE_FOLDER}PTBP_T1_BrainCerebellum.nii.gz \
							-k 0 -n 3 -w 0.25 -q 0 -o ${segment_dir}

