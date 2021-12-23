#! /bin/bash


########################################################################
## Input parsing
########################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/"	
project_id='60a14ca503bcad0ad27cada9'
download_dir=$1
outputdir=$2 #./'DBB_test'

	if [ $# -lt 2 ]; then												
		echo $0: "usage: "$( basename $0 )" <download_dir.ext> <output_dir>"
		return 1;		    
	fi 

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

array_mean ()	{

		        if [ $# -lt 1 ]; then														
			    echo $0: "usage: array_mean <array_values>"
			    echo "    array_values: values of the array "
			    echo "    example: array_mean \${array[@]} "	 	
			    return 1;		    
			fi 

			local array=("$@")					
			local val=0
			local N=${#array[@]}
			local mean=0
			for (( i=0; i<$N; i++ )); do
					val=${array[$i]}
	  				mean=$(echo "scale=4; ${mean}+${val} " | bc | awk '{printf "%f", $0}')
			done
			mean=$(echo "scale=4; ${mean}/${N} " | bc | awk '{printf "%f", $0}')

			echo $mean

		};

array_stdev () {
    
			if [ $# -lt 1 ]; then							# usage dello script							
			    echo $0: usage: "array_stdev <vect>"
			    return 1;		    
			fi 

			local vect=("$@")
			mean=$( array_mean ${vect[@]} )
			sqdif=0
			for ((i=0; i<${#vect[@]}; i++)); do  
				sqdif=$(echo "scale=6; ${sqdif}+((${vect[i]}-${mean})^2) " | bc )
			done
			result=$(echo "scale=6; sqrt(${sqdif}/${#vect[@]}) " | bc | awk '{printf "%f", $0}' ) 
			echo $result
	
		}


########################################################################
## Main
########################################################################


mkdir -p ${download_dir}	
bash ${SCRIPT_DIR}/download_testset.sh ${download_dir}
mkdir -p ${outputdir}
tag_list=( ACC PFM MCDs HD )
csv_all=${outputdir}'/average_dice_score.csv'
idx=0
echo ' , CSF, GM, WM, DGM, Brainstem, Cerebellum' > ${csv_all}
for tag in ${tag_list[@]}; do
	idx=$(( $idx + 1 ))
	bash ${SCRIPT_DIR}/compute_testset_local.sh ${download_dir}'/'${tag}'/'proj-${project_id} ${outputdir}'/'${tag}
	dice_score_v=$( cat ${outputdir}'/'${tag}'/dice_score_average.csv' ) 
	echo "dice score: "${dice_score_v}
	echo ${tag},${dice_score_v}>> ${csv_all}
	dice_score_v=( $( echo ${dice_score_v//','/' '} ) )
	CSF_ds[$idx]=${dice_score_v[0]}
	GM_ds[$idx]=${dice_score_v[2]}
	WM_ds[$idx]=${dice_score_v[4]}
	DGM_ds[$idx]=${dice_score_v[6]}
	BS_ds[$idx]=${dice_score_v[8]}
	Cereb_ds[$idx]=${dice_score_v[10]}
done

CSF_mean=$( array_mean ${CSF_ds[@]} )
GM_mean=$( array_mean ${GM_ds[@]} )
WM_mean=$( array_mean ${WM_ds[@]} )
DGM_mean=$( array_mean ${DGM_ds[@]} )
BS_mean=$( array_mean ${BS_ds[@]} )
Cereb_mean=$( array_mean ${Cereb_ds[@]} )

CSF_stdev=$( array_stdev ${CSF_ds[@]} )
GM_stdev=$( array_stdev ${GM_ds[@]} )
WM_stdev=$( array_stdev ${WM_ds[@]} )
DGM_stdev=$( array_stdev ${DGM_ds[@]} )
BS_stdev=$( array_stdev ${BS_ds[@]} )
Cereb_stdev=$( array_stdev ${Cereb_ds[@]} )

echo ''
echo  "Global Average",${CSF_mean} "("${CSF_stdev}")",${GM_mean}  "("${GM_stdev}")",${WM_mean} "("${WM_stdev}")",${DGM_mean} "("${DGM_stdev}")",${BS_mean} "("${BS_stdev}")",${Cereb_mean} "("${Cereb_stdev}")" >> ${csv_all}
cat ${csv_all}
echo ''
echo "The average dice score for each category is saved as: "${csv_all}
