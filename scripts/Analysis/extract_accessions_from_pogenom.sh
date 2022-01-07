#!/bin/sh -l

#Script for extracting accessions from  pogenom results
#change organism 
organism=Muni
path=/proj/snic2021-22-602/analyses/POGENOM_results/${organism}
outdir=/proj/snic2021-22-602/analyses/POGENOM_results/${organism}

#Extract accessions from pogenom results
awk -F ' ' '{print $1'} ${path}/*.intradiv.txt | head -n -1 | sed s'/Sample/ID/' > ${outdir}/${organism}_accessions.csv
awk -F ' ' '{print $1'} ${path}/*.intradiv.txt | tail -n +2 | head -n -1 > ${outdir}/${organism}_accessions.txt
 
