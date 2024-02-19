#!/bin/bash

# Check if the folder does not exist
FOLDER_NAME="trimmed_phix_unmatched"
if [ ! -d "$FOLDER_NAME" ]; then
    mkdir "$FOLDER_NAME"
    echo "Folder '$FOLDER_NAME' created."
else
    echo "Folder '$FOLDER_NAME' already exists."
fi

# Check if the folder does not exist
FOLDER_NAME="trimmed_phix_matched"
if [ ! -d "$FOLDER_NAME" ]; then
    mkdir "$FOLDER_NAME"
    echo "Folder '$FOLDER_NAME' created."
else
    echo "Folder '$FOLDER_NAME' already exists."
fi

RUN_PATH="trimmed"
OUT_PATH_1="trimmed_phix_unmatched"
OUT_PATH_2="trimmed_phix_matched"
OUT_PATH_3="reports"

for R1_file in $(ls ${RUN_PATH}/*_R1.fastq.gz)
do
    SAMPLE=$(basename "${R1_file}" _R1.fastq.gz)
    R2_file="${RUN_PATH}/${SAMPLE}_R2.fastq.gz"
    
    out1="${OUT_PATH_1}/unmatched_${SAMPLE}_R1.fq.gz"
    out2="${OUT_PATH_1}/unmatched_${SAMPLE}_R2.fq.gz"
    outm1="${OUT_PATH_2}/matched_${SAMPLE}_R1.fq.gz"
    outm2="${OUT_PATH_2}/matched_${SAMPLE}_R2.fq.gz"

    bbduk.sh in=${R1_file} out=${out1} outm=${outm1} ref=phix k=31 hdist=1 overwrite=t stats=${OUT_PATH_3}/${SAMPLE}_R1_stats.txt 
    bbduk.sh in=${R2_file} out=${out2} outm=${outm2} ref=phix k=31 hdist=1 overwrite=t stats=${OUT_PATH_3}/${SAMPLE}_R2_stats.txt
done
