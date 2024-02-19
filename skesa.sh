#!/bin/bash

conda create -n assembly -y
conda activate assembly
conda install bioconda::skesa -y

reads_dir=data-after-fastp-PhiX-removal
assembly_dir=skesa_asm

for r1 in "$reads_dir"/*_R1.fq.gz; do
    r2=${r1/_R1/_R2}
    if [[ -f $r2 ]] ; then
	contigs="$assembly_dir"/"$(echo "$r1" | sed 's/^.*_\(F[0-9]*\)_.*/\1/')"
	mkdir -p "$contigs"
	skesa --fastq "$r1" "$r2" --contigs_out "$contigs"/skesa_assembly.fa 1> "$contigs"/skesa.stdout.txt 2> "$contigs"/skesa.stderr.txt
    else
        echo "$r2 not found" >&2
    fi
done

conda deactivate
