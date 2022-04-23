#! /bin/bash
tag_list=( ACC PFM MCDs HD )
#pub_id=$1
output_dir=$1
mkdir -p ${output_dir}
for tag in ${tag_list[@]}; do
	mkdir -p ${output_dir}'/'${tag}
	bl bids download --pub "6263ac49f3858674a29a89b8" --tag EMEDEA-PED --tag ${tag} --output ${output_dir}'/'${tag}
done
