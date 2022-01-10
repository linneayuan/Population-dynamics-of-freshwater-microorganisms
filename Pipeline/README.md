# Prescreening pipeline
This pipeline will download 10% of sequences from the SRA database, map the sequences to chosen references, calculate coverages 
and filter for average coverage over 20x and 50 %cov. This way you can quickly do a prescreening of a number of metagenomes before actually
downloading the whole set and performing any analysis. This pipeline can only download from the SRA database. 

## Prerequisite software
You will need the following software

* Bowtie2
* sratools
* samtools

## Input files
You will need to place the following files in the folder Raw_data:
* A .fasta reference file with all your reference genomes (used for Bowtie2)

* A .txt file with accession numbers, separated by row break. The accession numbers must start with ERR, SRR or DRR.

* A .csv file with accessions and coordinates. Note that this file must have one column called <em>Latitude</em> with latitude coordinates in
  the decimal degree coordinate system, as well as one column called <em>Longitude</em> with longitude coordinates in the decimal degree coordinate 
  system. Name of column containing accession numbers does not matter.

## Running pipeline
The pipeline is computationally heavy so slurm is advised

Run with command:
> bash prescreening_pipeline.sh <.fasta file with  references for mapping> <.txt file with accessions> <.csv file with accessions and coordinates>

# Downloading full dataset
If you want to download full sequences the following script is provided: download_complete_genomes.sh is provided.
The script is computationally heavy so slurm is advised

Run with command:
> bash download_complete_genomes.sh <output directory for your .fastq files>
  


