#!/bin/sh -l
#SBATCH -A snic2021-22-602
#SBATCH -p core -n 1
#SBATCH -t 1:00:00
#SBATCH -J filter_depth_and_cov

cd /proj/snic2021-22-602/analyses/Avg_depth_eight

for i in *
do
awk -F, '{ if ($8 >= 2)  print }' $i | awk -F, '{ if ($7 >= 50)  print }' > ../Filtered_depth_cov/filtered_${i}
done
