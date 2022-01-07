#!/bin/sh -l

for accession in $(cat /proj/snic2021-22-602/data/Accession_files/36_not_downloaded.txt)
do
sbatch -A snic2021-22-602 -J ${accession}_download -p core -n 6 -t 50:00:00 download1_complete.sh $accession
done

