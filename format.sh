#!/bin/bash

# Author: James Boot, Date: 01/07/2024
# Script for formatting of CosMx data prior to running FICTURE

#####
#$ -M j.boot@qmul.ac.uk                # Change to your email address 
#$ -m bes
#$ -cwd
#$ -pe smp 1
#$ -l h_vmem=8G  
#$ -j y
#$ -l h_rt=240:00:00
#$ -N ficture              # Change the name of the job accordingly
#####

# Load Python module
module load python

# Activate virtualenv
source ficture/bin/activate

INPUT=/data/home/hmy961/ficture_trial/tma2/data/GCIN10692_TMA2_tx_file.csv.gz                 # Change it to your transcript file
PATH=/data/home/hmy961/ficture_trial/tma2/outs
IDEN=TMA2                                                   # How you identify your files
DUMMY=NegPrb                                                # Name of the negative controls, could pass regex to match multiple prob names
PX_TO_UM=0.120                                              # Convert the pixel unit in the input to micrometer

OUTPUT=${PATH}/filtered.matrix.${IDEN}.tsv
FEATURE=${PATH}/feature.clean.${IDEN}.tsv.gz

python /data/home/hmy961/ficture_trial/scripts/format_cosmx.py --input ${INPUT} \
--output ${OUTPUT} \
--feature ${FEATURE} \
--dummy_genes ${DUMMY} \
--px_to_um ${PX_TO_UM} \
--annotation cell_ID \
--precision 2

sort -k2,2g -k1,1g ${OUTPUT} | gzip -c > ${OUTPUT}.gz
rm ${OUTPUT}