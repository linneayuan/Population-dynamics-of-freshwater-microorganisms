#!/bin/bash -l

#SBATCH -A snic2021-22-602
#SBATCH -p core -n 1
#SBATCH -t 200:00:00
#SBATCH -J run1
#SBATCH --mail-type=ALL
#SBATCH --mail-user linnea.yuanandersson.0663@student.uu.se

module load bioinfo-tools
module load sratools

for accessions in $(cat /proj/snic2021-22-602/data/Accession_files/accession_number_mini_test.txt)
do
vdb-dump $accessions -r > row_column.txt
awk '{print $7}' row_column.txt > rows_with_colon.txt
rows=$(sed 's/,//g' rows_with_colon.txt)
percent_10_of_rows=$(expr $rows / 10)
fastq-dump $accessions -N 1 -X $percent_10_of_rows --gzip --split-3
done
rm row_column.txt
rm rows_with_colon.txt
