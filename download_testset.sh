#! /bin/bash
tag_list=( ACC PFM MCDs HD )
#pub_id=$1
for tag in ${tag_list[@]}; do
	bl bids download --pub "61b8b6b57ebe1c6fd7f048f2" --tag EMEDEA-PED --tag ${tag} #--output ./DBB_test
done
