#!/bin/sh -l

module load bioinfo-tools
module load sratools

cd /proj/snic2021-6-25/uu_students/pogenome_fastq/final

fastq-dump $1 --gzip --split-3

