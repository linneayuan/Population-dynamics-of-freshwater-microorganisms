#!/bin/sh -l

#Go through filtered files and extract accessions, removes header
for file in Prescreening_results/filtered_depth_files/filtered_geo*
do
awk -F"," '{print $1}' $file | tail -n +2 >> Prescreening_results/filtered_depth_files/filtered_accessions_with_dup.txt
done
sort -u Prescreening_results/filtered_depth_files/filtered_accessions_with_dup.txt > Prescreening_results/filtered_depth_files/filtered_accessions.txt
rm Prescreening_results/filtered_depth_files/filtered_accessions_with_dup.txt
