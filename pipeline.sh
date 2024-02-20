#!/bin/bash

# environment 1
conda create -n teamf
conda activate teamf
conda install -c bioconda fastqc multiqc fastp bbmap skesa -y

# environment 2
conda create -n "pythonold" python=2.7 -y
conda activate pythonold
conda install biopython -y
conda deactivate

# commandline usage: sh pipeline.sh [input_dir] [output_dir]
input_dir="$1"
output_dir="$2"

for file in "$input_dir"/*R1*; do
	R1=$(basename -- "$file")
	R2="${filename/R1/R2}"
	# isolate name saved as $isolate
	isolate="${R1:0:8}"

	# create output dirs for fastp, bbduk, skesa and quast
	mkdir -p "$output_dir"/{fastp,reports,bbduk,skesa,quast}/$isolate

	#trimming with fastp
	fastp -w 6 \
	--qualified_quality_phred 30 \
	--unqualified_percent_limit 20 \
	--dont_eval_duplication \
	-i $R1 -I $R2 \
	-o "$output_dir/fastp_$isolate/trimmed_${R1}" \
	-O "$output_dir/fastp_$isolate/trimmed_${R2}" \
	-h "$output_dir/reports/${isolate}_fastp_report.html" \
	-j "$output_dir/reports/${isolate}_fastp.json" -z 6

	#bbduk
	 bbduk.sh in="$output_dir/fastp_$isolate/trimmed_${R1}" out="$output_dir/bbduk_$isolate/unmatched_${R1}" outm="$output_dir/bbduk_$isolate/matched_${R1}" ref=phix k=31 hdist=1 overwrite=t stats="$output_dir/bbduk_$isolate/R1_stats.txt" 
    	 bbduk.sh in="$output_dir/fastp_$isolate/trimmed_${R2}" out="$output_dir/bbduk_$isolate/unmatched_${R2}" outm="$output_dir/bbduk_$isolate/matched_${R2}" ref=phix k=31 hdist=1 overwrite=t stats="$output_dir/bbduk_$isolate/R2_stats.txt" 
	 
	#assembly with skesa
	skesa \
	--fastq "$output_dir/bbduk_$isolate/matched_${R1}" \
	"$output_dir/bbduk_$isolate/matched_${R2}" \
	--contigs_out "$output_dir/skesa_$isolate/$isolate.fasta" \
	1> "$output_dir/skesa_$isolate"/skesa.stdout.txt \
	2> "$output_dir/skesa_$isolate"/skesa.stderr.txt

	#filter
	conda activate pythonold
	python filter.contigs.py \
		-i "$output_dir/skesa_$isolate/$isolate.fasta" \
		-o "$output_dir/skesa_$isolate/filtered_$isolate.fna"
	conda deactivate

	#quality with quast

done
