#!/bin/sh -l
#SBATCH -A snic2021-22-602
#SBATCH -p core -n 1
#SBATCH -t 5:00:00
#SBATCH -J download

module load bioinfo-tools
module load sratools

fastq-dump SRR12486991 --gzip --split-3
fastq-dump SRR12486994 --gzip --split-3
