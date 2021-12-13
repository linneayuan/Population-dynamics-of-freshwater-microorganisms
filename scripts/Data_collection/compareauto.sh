#!/bin/bash -l

#SBATCH -A snic2021-22-602
#SBATCH -p core -n 1
#SBATCH -t 8:00:00
#SBATCH -J run

module load bioinfo-tools
module load sratools

cd /proj/snic2021-6-25/uu_students/pogenome_fastq/downloaded_files

for accessions in $(cat /proj/snic2021-22-602/data/Accession_files/remaining_new_accessions.txt)
do
if [ -e ${accessions}_1.fastq.gz ]; then
vdb-dump $accessions -r | awk '{print $7}' >> rows_with_colon.txt
echo $accessions >> rem_new_keep.txt
zcat ${accessions}_1.fastq.gz | wc -l > current_count.txt
for k in $(cat current_count.txt)
do
echo $(( ${k} / 4 )) >> row_counts.txt
done
rm current_count.txt
fi
done

paste rows_with_colon.txt rem_new_keep.txt > sizes_and_codes.txt
paste row_counts.txt rem_new_keep.txt > sizes_and_codes_downloaded.txt
rm rows_with_colon.txt
rm rem_new_keep.txt
rm row_counts.txt

comm sizes_and_codes.txt sizes_and_codes_downloaded.txt > comparison.txt
