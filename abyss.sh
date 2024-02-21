#!/bin/bash

isolates=("F0582884" "F0582987" "F0622946" "F0658207" \
	"F0658208" "F0658209" "F0784744" "F0798117" \
	"F0798119" "F0798122" "F0798123" "F1725545" \
	"F1725552" "F1736637" "F1736640" "F1737233" \
	"F1738908" "F1739591" "F1739597" "F1739602" \
	"F2034395" "F2045925" "F2045928" "F2045930" \
	"F2045932" "F2045942" "F2045945" "F2049583" \
	"F2049584" "F2052228")
	
mkdir -p abyss

for i in "${isolates[@]}"; do
	abyss \
		-k 33 \
		-o ./abyss/"$i".fasta \
		./trimmed_phix_unmatched/unmatched_trimmed_"$i"_R1.fq.gz \
		./trimmed_phix_unmatched/unmatched_trimmed_"$i"_R2.fq.gz
done

mkdir -p filterab

for i in "${isolates[@]}"; do
	seqkit seq -m 500 ./abyss/"$i".fasta > ./filterab/"$i".fna
done
