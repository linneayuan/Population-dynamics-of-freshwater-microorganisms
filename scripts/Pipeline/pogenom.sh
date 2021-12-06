#!/bin/sh -l
#SBATCH -A snic2021-22-602
#SBATCH -p core -n 1
#SBATCH -t 06:00:00
#SBATCH -J running_pogenom

module load bioinfo-tools perl/5.26.2 perl_modules/5.26.2

perl pogenom.pl --vcf_file <VCF_FILE> --out <OUTPUT_FILES_PREFIX> --fasta_file <FASTA_FILE> --min_count 15 --min_found 0 --subsample 15 > <OUTPUT_FILES_PREFIX_stdout.txt>
