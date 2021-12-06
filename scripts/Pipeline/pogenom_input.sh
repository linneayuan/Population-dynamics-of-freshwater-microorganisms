#!/bin/sh -l
#SBATCH -A snic2021-22-602
#SBATCH -p core -n 12
#SBATCH -t 01:00:00
#SBATCH -J running_pogenom_input
#SBATCH --mail-user=chelsea.ramsin.9601@student.uu.se --mail-type=ALL

#/proj/snic2021-22-602/POGENOM/Input_POGENOM

source /proj/snic2021-22-602/miniconda/miniconda3/bin/activate
conda activate ip_env
bash Input_POGENOM.sh
conda deactivate
