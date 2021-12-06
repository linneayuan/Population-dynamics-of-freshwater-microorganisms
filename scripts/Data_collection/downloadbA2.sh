#!/bin/sh -l
#SBATCH -A snic2021-22-602
#SBATCH -p core -n 1
#SBATCH -t 55:00:00
#SBATCH -J download

module load bioinfo-tools
module load sratools

dir=/proj/snic2021-6-25/uu_students/pogenome_fastq

cd /proj/snic2021-22-602/analyses/Filtered_depth_cov

for k in *bA2.csv.txt
do
cd $dir
mkdir $k
cd $k
for i in $(cat /proj/snic2021-22-602/analyses/Filtered_depth_cov/$k)
do
fastq-dump $i --gzip --split-3
done
done
