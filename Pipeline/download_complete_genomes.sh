#!/bin/sh -l
#Script that downloads full genomes of the filtered samples 
#Run like this: download_complete_genomes.sh <output directory>

module load bioinfo-tools
module load sratools

for accessions in Prescreening_results/filtered_depth_files/filtered_accessions.txt
do
fastq-dump $accession --gzip --split-3 --outdir $1
done
