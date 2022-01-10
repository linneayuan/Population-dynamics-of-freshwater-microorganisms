#!/bin/sh -l
#SBATCH -A snic2021-5-53
#SBATCH -p core -n 4
#SBATCH -t 01:00:00
#SBATCH -J pipe_test
#SBATCH --mail-user=linnea.yuanandersson.0663@student.uu.se --mail-type=ALL

module load bioinfo-tools
module load bowtie2/2.3.5.1
module load samtools/1.12
module load sratools

# Run like this: preescreening.sbatch <reference fasta files for mapping> <accessions> <accession coordinate file> 
# The accessions should be in textfiles, each accession separated by a row break. 

#Check if pipe has been run already
if [[ -f "Prescreening_results/" ]]
then 
	echo  "Files already exist"
else
	mkdir Prescreening_results/
fi

#Downloading 10% of fasta files, mapping with bowtie and calculating coverages
bash scripts/download10_mapping_cov.sh $1 $2


#Merge average depth files with coordinates using script tsv_to_csv.py
if [[ -f "Prescreening_results/Coordinate_depth_files/" ]]
then
    	echo "Folder already exists"
else
    	mkdir Prescreening_results/Coordinate_depth_files 
	module load python3/3.8.7
	
	if grep -q 'Accession' $3 #checks if accesion column header is Accession
	then
    		python3 scripts/merge_cov_coordinates.py $3
	else
    		echo "accession coordinate file does not have correct header. Converts. New accession coordinate file in Prescreening_results folder called accession_coordinate.csv"
        	bash scripts/convert_accession_coordinate.sh $3 #changes name of accession column header to Accession
        	python3 scripts/merge_cov_coordinates.py Prescreening_results/accession_coordinate.csv
	fi

fi

#Filtering files containing coverages and coordinates 
bash scripts/filter_depth_cov.sh

#Saving filtered accessions in new txt file
bash scripts/filtered_accessions.sh

#Once this is done you can run the download_complete_genomes.sh script which downloads the accessions from the txt file above
