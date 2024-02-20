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

cd $input_dir
fastqc *
multiqc .

cd ..
bash trimm.sh
cd reports
multiqc .

# phix removal
bash bbduk.sh

for file in "$input_dir"/*R1*; do
	R1=$(basename -- "$file")
	R2="${filename/R1/R2}"
	# isolate name saved as $isolate
	isolate="${R1:0:8}"

	#assembly with skesa
	skesa \
	--fastq "$output_dir/fastp_$isolate/trimmed_${R1}" \
	"$output_dir/fastp_$isolate/trimmed_${R2}" \
	--contigs_out "$output_dir/skesa_$isolate/$isolate.fasta" \
	1> "$output_dir/skesa_$isolate"/skesa.stdout.txt \
	2> "$output_dir/skesa_$isolate"/skesa.stderr.txt

	#filter
	conda activate pythonold
	python filter.contigs.py \
		-i "$output_dir/skesa_$isolate/$isolate.fasta" \
		-o "$output_dir/skesa_$isolate/filtered_$isolate.fna"
	conda deactivate

done


