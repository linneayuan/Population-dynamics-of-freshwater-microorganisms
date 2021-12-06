#!/bin/sh -l
#SBATCH -A snic2021-22-602
#SBATCH -p core -n 1
#SBATCH -t 00:01:00
#SBATCH -J compiling_cov_results
#SBATCH --mail-user=linnea.yuanandersson.0663@student.uu.se --mail-type=ALL

for file in *
do
#Store accessions in txt file OBS this includes header
awk -F, '{ print $1 }' ${file} > /proj/snic2021-22-602/analyses/Filtered_depth_cov/accessions_${file}.txt

#remove ID header 
sed -i '1d' /proj/snic2021-22-602/analyses/Filtered_depth_cov/accessions_${file}.txt

done

