# F1

# Pipeline to determine the genome for a microbial outbreak: 
## For the procedure we subdivided the tasks which are: 

## 1. Quality Control and Trimmming: 
## Pre-requisites: 
Create a conda environment for the overall sub-procedure 

```python
conda create -n teamf
```
 Tools that were benchmarked and were selected for the step and need to be installed in the conda environment: 
 1. FastQc: This is required for the quality control step (https://www.bioinformatics.babraham.ac.uk/projects/fastqc/). 
 2. MultiQc: This is required for generating an overall of the report that are present (https://multiqc.info/). 
 3. Fastp: This will help with the trimming portion (https://academic.oup.com/bioinformatics/article/34/17/i884/5093234). 
 4. BBduk: This is used to remove the Phix contamination that might be present in the reads (https://sourceforge.net/projects/bbmap/). 

```python 
conda install -c bioconda fastqc multiqc fastp bbmap
```

After the required benchmarks these were the best tools that were found for the particular pipeline. 

# Steps to execute: 

1. Initial raw read quality control: 

Make a directory where all the raw reads will be present

```python
mkdir raw_reads
``` 

Activate the conda environemnt created and run the fastqc with multiqc for the intial raw read quality control to check if any discrepancies are present. 


```python 
conda activate teamf
fastqc *
multiqc . 
```
2. After no major discrepancies are found, run the overall trimming with the speecified parameters for the fastq files with ``trimm.sh`` script. 

Make a directory where the trimmed results will be located. 

```python 
mkdir final
bash trimm.sh
```
The name for the directory can be changed, but for that, the output directory need to be changed as well in ``trimm.sh``

3. After the trimming is done, go to the directory where the output for the trimmed files are and run multiqc again to check the quality of the trimmed reads. 

```python
multiqc . 
```

4. If not satisfied with the quality, you can change the flags mentioned in the ``trim.sh`` script as per you convenience and requirements. 

5. To check/remove any contamination in the trimmed files, you can execute ``___.sh`` script. 

```python  

Bash script 

``` 

The above mentioned steps are crucial as they will determine the overall quality and reliability of the downstream analysis. 

## 2. Assembly 

