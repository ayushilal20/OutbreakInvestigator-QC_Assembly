# F1

# Pipeline to determine the genome for a microbial outbreak: 
## For the procedure we subdivided the tasks which are: 

## 1. Quality Control and Trimmming: 
## Pre-requisites: 
Create a conda environment for the overall sub-procedure 

```python
conda create -n teamf
```
 Selected Tools for QC after benchmarking :: 
 1. FastQc: This is required for the quality control step (https://www.bioinformatics.babraham.ac.uk/projects/fastqc/). 
 2. MultiQc: This is required for generating an overall of the report that are present (https://multiqc.info/). 
 3. Fastp: This will help with the trimming portion (https://academic.oup.com/bioinformatics/article/34/17/i884/5093234). 
 4. BBduk: This is used to remove the Phix contamination that might be present in the reads (https://sourceforge.net/projects/bbmap/). 

```python 
conda install -c bioconda fastqc multiqc fastp bbmap
```
# Steps to execute: 

1. Initial raw read quality control: 

Create directory for raw reads.

```python
mkdir raw_reads
``` 
Run fastqc with multiqc for intial raw read quality control to check for any discrepancies. 

```python 
conda activate teamf
fastqc *
multiqc . 
```
2. If no major discrepancies are found, use ``trimm.sh`` script to perform trimming on the fastq files.

Create directory for trimmed reads. 

```python 
mkdir final
bash trimm.sh
```

3. Run multiqc on trimmed reads again to check the quality of the trimmed reads. 

```python
multiqc . 
```

4. If not satisfied with the quality, repeat Step2 with different flags mentioned in the ``trim.sh`` script. 

5. To check and remove any contamination in the trimmed files, execute ``___.sh`` script. 

```python  

Bash script 

``` 
Quality Control is crucial prior to any downstream analysis [Garbage in Garbage Out]. 

## 2. Assembly 

