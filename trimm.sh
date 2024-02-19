#!/bin/bash

# Get the directory where the script is located
script_dir=$(dirname "$0")


R1=""
R2=""


# Loop through all .fastq.gz files in the script's directory
for file in "$script_dir"/*.fastq.gz; do
    # Extract just the filename without the directory path
    file_name=$(basename "$file")
    if [[ $file_name == *_R1.fastq.gz ]]; then
        R1="$file_name"
    elif [[ $file_name == *_R2.fastq.gz ]]; then
        R2="$file_name"
    fi

    #substring="${R1%"$common_ending"}_fastp_report.html"
    substring="${R1:0:8}"
    #echo "${R1%"$la_name"_fastp_report.html}"
    #echo "$substring"
    fastp -w 6 --qualified_quality_phred 30 --unqualified_percent_limit 20 --dont_eval_duplication -i $R1  -I $R2 -o "nodupli/trimmed_$R1" -O "nodupli/trimmed_$R2" -h "final/${substring}fastp_report.html" -j "final/${substring}fastp.json" -z 6
    #fastp -w 6 --qualified_quality_phred 30 --unqualified_percent_limit 20 -i $R1 -o "indi/trimmed_$R1" -h "indi/${substring}R1fastp_report.html" -j "indi/${substring}R1fastp.json" -z 6
    #fastp -w 6 --qualified_quality_phred 30 --unqualified_percent_limit 20 -i $R2 -o "indi/trimmed_$R2" -h "indi/${substring}R2fastp_report.html" -j "indi/${substring}R2fastp.json" -z 6
done

# Output the current directory
echo "Script is running in the directory: $(pwd)"

# Return to the original directory if necessary
cd - > /dev/null  # This changes back to the previous directory, suppressing the output
