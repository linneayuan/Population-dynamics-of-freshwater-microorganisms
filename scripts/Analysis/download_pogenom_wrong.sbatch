#!/bin/sh -l
#SBATCH -A snic2021-22-602
#SBATCH -p core -n 1
#SBATCH -t 08:00:00
#SBATCH -J download_POGENOM
#SBATCH --mail-user=chelsea.ramsin.9601@student.uu.se --mail-type=FAIL --mail-type=END

module load bioinfo-tools
module load snakemake
module load bowtie2
module load samtools
module load picard
module load vcflib
module load freebayes
module load python3
module load seqtk 

/proj/snic2021-22-602/miniconda/miniconda3/bin/conda env create -f config_files/Input_POGENOM_conda_env_setup.yaml
	
