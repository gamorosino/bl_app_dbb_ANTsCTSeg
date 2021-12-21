#! /bin/bash
tag_list=( ACC PFM MCDs HD )
#pub_id=$1
output_dir=$1
mkdir -p ${output_dir}
for tag in ${tag_list[@]}; do
	mkdir -p ${output_dir}'/'${tag}
	bl bids download --pub "61b8b6b57ebe1c6fd7f048f2" --tag EMEDEA-PED --tag ${tag} --output ${output_dir}'/'${tag}
done
