#!/bin/bash

# Check if the folder does not exist
FOLDER_NAME="trimmed"
if [ ! -d "$FOLDER_NAME" ]; then
    mkdir "$FOLDER_NAME"
    echo "Folder '$FOLDER_NAME' created."
else
    echo "Folder '$FOLDER_NAME' already exists."
fi

# Check if the folder does not exist
FOLDER_NAME="reports"
if [ ! -d "$FOLDER_NAME" ]; then
    mkdir "$FOLDER_NAME"
    echo "Folder '$FOLDER_NAME' created."
else
    echo "Folder '$FOLDER_NAME' already exists."
fi

cd raw_reads

R1="" 
R2=""

# Loop through all .fastq.gz files in the script's directory
for file in *.fastq.gz; do
    # Extract just the filename without the directory path
    file_name=$(basename "$file")
    if [[ $file_name == *_R1.fastq.gz ]]; then
        R1="$file_name"
    elif [[ $file_name == *_R2.fastq.gz ]]; then
        R2="$file_name"
    fi

    substring="${R1:0:8}"
    fastp -w 6 --qualified_quality_phred 30 --unqualified_percent_limit 20 --dont_eval_duplication -i $R1 -I $R2 -o "../trimmed/trimmed_$R1" -O "../trimmed/trimmed_$R2" -h "../reports/${substring}_fastp_report.html" -j "../reports/${substring}_fastp.json" -z 6
done

# Output the current directory
echo "Script is running in the directory: $(pwd)"

# Return to the original directory if necessary
