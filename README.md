# F1 : Pipeline for Read QC and Genome Assembly during a microbial outbreak

## Option 1: Run entire pipeline(one tool per stage; chosen after analysis) in 1 step .

```
sh pipeline.sh [input_dir] [output_dir]
```
## Option2: Run individual steps, with multiple tools at each step.

## 1. Quality Control and Trimming: 
## Pre-requisites: 
 Conda environment with following packages (Selected Tools for QC after benchmarking)::
 1. FastQc: This is required for the quality control step (https://www.bioinformatics.babraham.ac.uk/projects/fastqc/). 
 2. MultiQc: This is required for generating an overall of the report that are present (https://multiqc.info/). 
 3. Fastp: This will help with the trimming portion (https://academic.oup.com/bioinformatics/article/34/17/i884/5093234). 
 4. BBduk: This is used to remove the Phix contamination that might be present in the reads (https://sourceforge.net/projects/bbmap/). 

```
conda create -n teamf
conda activate teamf
conda install -c bioconda fastqc multiqc fastp bbmap
```

## Steps to execute: 

1. Initial raw read quality control

 Place all raw reads in directory ``raw_reads``.
 Run fastqc with multiqc on intial raw reads to check initial quality (look for discrepancies b/w tools). 

``` 
mkdir raw_reads
cd raw_reads
fastqc *
multiqc . 
```
2. If no major discrepancies are found, use ``trimm.sh`` script to perform trimming on the fastq files.

```
cd ..
bash trimm.sh
```

3. Run multiqc on trimmed reads again to check quality of final reads. 

```
cd reports
multiqc . 
```

4. If not satisfied with the quality, repeat Step2 with different flags in ``trimm.sh``. 

5. To check and remove any contamination in the trimmed files, execute ``bbduk.sh`` script. 

```
bash bbduk.sh 
``` 
```
conda deactivate
```
Quality Control is crucial prior to any downstream analysis [Garbage in Garbage Out]. 

## 2. Genome Assembly 

## Pre-requisites: 
 Conda environment with following packages (Selected Assemblers for Genome Assembly)::
 1. skesa: https://github.com/ncbi/SKESA
 2. velvet: https://github.com/dzerbino/velvet
 3. abyss: https://github.com/bcgsc/abyss

```
conda create -n teamf_asm -y 
conda activate teamf_asm
conda install bioconda::skesa bioconda::velvet bioconda::abyss bioconda::seqkit -y
```
## Steps to execute: 

1. Assembly with skesa.

 Reads are assumed to be in ``trimmed_phix_unmatched`` folder aftr QC.
 Assembled contigs will be placed in ``skesa_asm``.
 
 ```
sh skesa.sh
```

2. Assembly with velvet.

 Reads are assumed to be in ``trimmed_phix_unmatched`` folder aftr QC.
 Assembled contigs will be placed in ``velvet_asm``.
 
```
sh velvet.sh
```

3. Assembly with abyss and filter with seqkit
 Reads are assumed to be in ``trimmed_phix_unmatched`` folder aftr QC.
 Assembled and filtered contigs will be placed in ``filteredab``.

```
sh abyss.sh
```

```
conda deactivate
```

4. Creating separate conda env for filtering contigs from velvet and skesa; filtered contigs for skesa will be placed in ``filtered_skesa_asm``, filtered contigs for velvet will be placed in ``filtered_velvet_asm``,
```
conda create -n "pythonold" python=2.7 -y
conda activate pythonold
conda install biopython -y
sh filter.sh
conda deactivate
```
