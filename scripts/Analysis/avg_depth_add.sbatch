#!/bin/sh -l
#SBATCH -A snic2021-22-602
#SBATCH -p core -n 1
#SBATCH -t 00:00:01
#SBATCH -J compiling_cov_results
#SBATCH --mail-user=linnea.yuanandersson.0663@student.uu.se --mail-type=ALL

module load bioinfotools
module load python3/3.8.7

python3 split_to_organisms.py
