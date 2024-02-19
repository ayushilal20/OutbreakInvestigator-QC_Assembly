#!/bin/bash

conda create -n "pythonold" python=2.7 -y
conda activate pythonold
conda install biopython -y

velvet_dir="velvet_asm"
skesa_dir="skesa_asm"
filtered_velvet_dir="filtered_velvet_asm"
filtered_skesa_dir="filtered_skesa_asm"

for i in $(ls -A "$velvet_dir"); do
	filtered_contigs="$filtered_velvet_dir/$i"
	mkdir -p "$filtered_contigs"
	python filter.contigs.py -i "$velvet_dir/$i"/contigs.fa -o "$filtered_contigs"/filtered_contigs.fa 1> "$filtered_contigs"/filter.stdout.txt 2> "$filtered_contigs"/filter.stderr.txt
done

for i in $(ls -A "$skesa_dir"); do
	filtered_contigs="$filtered_skesa_dir/$i"
	mkdir -p "$filtered_contigs"
	python filter.contigs.py -i "$skesa_dir/$i"/skesa_assembly.fa -o "$filtered_contigs"/filtered_contigs.fa 1> "$filtered_contigs"/filter.stdout.txt 2> "$filtered_contigs"/filter.stderr.txt
done

conda deactivate