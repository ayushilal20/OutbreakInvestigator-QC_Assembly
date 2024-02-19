#!/bin/bash

conda create -n assembly -y
conda activate assembly
conda install bioconda::velvet -y

reads_dir=data-after-fastp-PhiX-removal
assembly_dir=velvet_asm

for r1 in "$reads_dir"/*_R1.fq.gz; do
    r2=${r1/_R1/_R2}
    if [[ -f $r2 ]] ; then
	contigs="$assembly_dir"/"$(echo "$r1" | sed 's/^.*_\(F[0-9]*\)_.*/\1/')"
	mkdir -p "$contigs"
	velveth "$contigs" 31 -shortPaired -fastq "$r1" "$r2" 1> "$contigs"/velvet.stdout.txt 2> "$contigs"/velvet.stderr.txt
	velvetg "$contigs" -cov_cutoff auto
    else
        echo "$r2 not found" >&2
    fi
done

conda deactivate
