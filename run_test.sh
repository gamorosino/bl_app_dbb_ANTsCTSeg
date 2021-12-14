#! /bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/"	
project_id='60a14ca503bcad0ad27cada9'
outputdir=$1
bash ${SCRIPT_DIR}/download_testset.sh
bash ${SCRIPT_DIR}/compute_testset.sh proj-${project_id} ${outputdir}
