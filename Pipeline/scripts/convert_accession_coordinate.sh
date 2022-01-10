#script for changing accession column header to Accession

#Define accession coordinate input file
accession_coordinate_file=$1

#Remove everything except accession numbers
sed 's/^.*ERR/ERR/' $1 | sed 's/^.*SRR/SRR/' | sed 's/^.*DRR/DRR/' | sed 's/".*/''/' > Prescreening_results/accessions.csv

#Add Accession as header
sed -n -i '1s/^/Accession/' Prescreening_results/accessions.csv

#Put column of accessions together with original accession and coordinate file
paste -d, Prescreening_results/accessions.csv $1 > Prescreening_results/accession_coordinate.csv

rm Prescreening_results/accessions.csv


