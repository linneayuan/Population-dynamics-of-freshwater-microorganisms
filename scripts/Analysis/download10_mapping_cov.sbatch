#!/bin/sh -l
#SBATCH -A snic2021-22-602
#SBATCH -p core -n 4
#SBATCH -t 60:00:00
#SBATCH -J mapping_and_downloading_accession6
#SBATCH --mail-user=linnea.yuanandersson.0663@student.uu.se --mail-type=ALL

module load bioinfo-tools
module load bowtie2/2.3.5.1
module load samtools/1.12
module load sratools
rm 
dir=/proj/snic2021-22-602/analyses/Mapping_Coverage_results
outdir=/proj/snic2021-22-602/analyses/Mapping_Coverage_results/tsv_files

# build one index for all 21 refs (need to build separate indexes for the refs if metagenomes should be mapped against only specific refs)
#bowtie2-build /proj/snic2021-22-602/data/Reference_data/21refs_nodup.fasta /proj/snic2021-22-602/data/Reference_data/21refs_nodup

# map all subsampled stratfreshDB metagenomes with a 95% identity threshold against the 21 refs then filter sam to retain mapped reads and sort into bam file
for prefix in $(cat /proj/snic2021-22-602/data/Accession_files/accession_split/accession_numbers6.txt)
do
# downloading data
vdb-dump $prefix -r > row_column.txt
awk '{print $7}' row_column.txt > rows_with_colon.txt
rows=$(sed 's/,//g' rows_with_colon.txt)
percent_10_of_rows=$(expr $rows / 10)
fastq-dump $prefix -N 1 -X $percent_10_of_rows --gzip --split-3 -O /proj/snic2021-22-602/data/Fastq_files/

# mapping
bowtie2 -x /proj/snic2021-22-602/data/Reference_data/21refs_nodup -p 4 --ignore-quals --mp 1,1 --rdg 0,1 --rfg 0,1 --score-min L,0,-0.05 -1 /proj/snic2021-22-602/data/Fastq_files/${prefix}_1.fastq.gz -2 /proj/snic2021-22-602/data/Fastq_files/${prefix}_2.fastq.gz | samtools view -@ 4 -h -F 4 | samtools sort -@ 4 -o $dir/${prefix}_sorted.bam

# removing fastq file for storage
rm /proj/snic2021-22-602/data/Fastq_files/${prefix}*

done

rm row_column.txt
rm rows_with_colon.txt

module load BEDTools/2.29.2
module load biopython/1.78

for prefix in $(cat /proj/snic2021-22-602/data/Accession_files/accession_split/accession_numbers6.txt)
do
# determine coverage
genomeCoverageBed -ibam $dir/${prefix}_sorted.bam > $dir/${prefix}.cov
# determine coverage per contig (script slightly modified from https://github.com/inodb/metassemble/blob/master/scripts/validate/map/gen_contig_cov_per_bam_table.py)
python /proj/snic2021-22-602/scripts/Analysis_scripts/contig_depth_cov_and_mapped_bases.py --isbedfiles /proj/snic2021-22-602/data/Reference_data/21refs_nodup.fasta $dir/${prefix}.cov > $dir/${prefix}.covpercont
# remove files that won't be needed anymore (only uncomment when sure that the other steps run as they should)
rm -f ${prefix}.bam ${prefix}.cov
done

### compute average coverage depth for each metagenome over all contigs from...
# Cand. Fonsibacter ubiquis LSUCC0530
echo -e "metaname\tgenomelen_bp\tGC\tmapped_bases\tperc_cov\tavg_depth" > $outdir/cov_Fubi_stratf1M.tsv
for file in $dir/*.covpercont; do python /proj/snic2021-22-602/scripts/Analysis_scripts/covpergenome_from_covpercontig_NOmetasizes.py "$file" CP024034.1 >> $outdir/cov_Fubi_stratf1M.tsv; done
# Cand. Methylopumilus universlis SuperPang core 30kb WO 16S contig
echo -e "metaname\tgenomelen_bp\tGC\tmapped_bases\tperc_cov\tavg_depth" > $outdir/cov_Muni_stratf1M.tsv
for file in $dir/*.covpercont; do python /proj/snic2021-22-602/scripts/Analysis_scripts/covpergenome_from_covpercontig_NOmetasizes.py "$file" Muni_Sc0- >> $outdir/cov_Muni_stratf1M.tsv; done
# Cand. Nanopelagicus abundans MMS-IIB-91
echo -e "metaname\tgenomelen_bp\tGC\tmapped_bases\tperc_cov\tavg_depth" > $outdir/cov_Nabu_stratf1M.tsv
for file in $dir/*.covpercont; do python /proj/snic2021-22-602/scripts/Analysis_scripts/covpergenome_from_covpercontig_NOmetasizes.py "$file" CP016779.1 >> $outdir/cov_Nabu_stratf1M.tsv; done
# Cand. Planktophila vernalis MMS-IIA-15
echo -e "metaname\tgenomelen_bp\tGC\tmapped_bases\tperc_cov\tavg_depth" > $outdir/cov_Pver_stratf1M.tsv
for file in $dir/*.covpercont; do python /proj/snic2021-22-602/scripts/Analysis_scripts/covpergenome_from_covpercontig_NOmetasizes.py "$file" CP016776.1 >> $outdir/cov_Pver_stratf1M.tsv; done
# Polynucleobacter asymbioticus SuperPang core 50kb
echo -e "metaname\tgenomelen_bp\tGC\tmapped_bases\tperc_cov\tavg_depth" > $outdir/cov_Pasy_stratf1M.tsv
for file in $dir/*.covpercont; do python /proj/snic2021-22-602/scripts/Analysis_scripts/covpergenome_from_covpercontig_NOmetasizes.py "$file" Pasy_Sc0- >> $outdir/cov_Pasy_stratf1M.tsv; done
# Polynucleobacter paneuropaeus core 30kb WO ribprot contig
echo -e "metaname\tgenomelen_bp\tGC\tmapped_bases\tperc_cov\tavg_depth" > $outdir/cov_Ppan_stratf1M.tsv
for file in $dir/*.covpercont; do python /proj/snic2021-22-602/scripts/Analysis_scripts/covpergenome_from_covpercontig_NOmetasizes.py "$file" Ppan_Sc0- >> $outdir/cov_Ppan_stratf1M.tsv; done
# Polynucleobacter cosmopolitanus core parts
# echo -e "metaname\tgenomelen_bp\tGC\tmapped_bases\tperc_cov\tavg_depth" > cov_Pcos_stratf1M.tsv

echo -e "metaname\tgenomelen_bp\tGC\tmapped_bases\tperc_cov\tavg_depth" > $outdir/cov_Pcos.tsv
for file in $dir/*.covpercont; do python /proj/snic2021-22-602/scripts/Analysis_scripts/covpergenome_from_covpercontig_NOmetasizes.py "$file" Pcos_MWH-MoIso2 >> $outdir/cov_Pcos.tsv; done

echo -e "metaname\tgenomelen_bp\tGC\tmapped_bases\tperc_cov\tavg_depth" > $outdir/cov_Paci.tsv
for file in $dir/*.covpercont; do python /proj/snic2021-22-602/scripts/Analysis_scripts/covpergenome_from_covpercontig_NOmetasizes.py "$file" Ga0325193_11 >> $outdir/cov_Paci.tsv; done

echo -e "metaname\tgenomelen_bp\tGC\tmapped_bases\tperc_cov\tavg_depth" > $outdir/cov_Pdif.tsv
for file in $dir/*.covpercont; do python /proj/snic2021-22-602/scripts/Analysis_scripts/covpergenome_from_covpercontig_NOmetasizes.py "$file" Ga0325182_11 >> $outdir/cov_Pdif.tsv; done

echo -e "metaname\tgenomelen_bp\tGC\tmapped_bases\tperc_cov\tavg_depth" > $outdir/cov_Pdur.tsv
for file in $dir/*.covpercont; do python /proj/snic2021-22-602/scripts/Analysis_scripts/covpergenome_from_covpercontig_NOmetasizes.py "$file" Ga0077867_11 >> $outdir/cov_Pdur.tsv; done

echo -e "metaname\tgenomelen_bp\tGC\tmapped_bases\tperc_cov\tavg_depth" > $outdir/cov_Psph.tsv
for file in $dir/*.covpercont; do python /proj/snic2021-22-602/scripts/Analysis_scripts/covpergenome_from_covpercontig_NOmetasizes.py "$file" Psph_MWH-Weng1-1 >> $outdir/cov_Psph.tsv; done

echo -e "metaname\tgenomelen_bp\tGC\tmapped_bases\tperc_cov\tavg_depth" > $outdir/cov_Psc1_es-MAR-2.tsv
for file in $dir/*.covpercont; do python /proj/snic2021-22-602/scripts/Analysis_scripts/covpergenome_from_covpercontig_NOmetasizes.py "$file" Ga0081397_11 >> $outdir/cov_Psc1_es-MAR-2.tsv; done

echo -e "metaname\tgenomelen_bp\tGC\tmapped_bases\tperc_cov\tavg_depth" > $outdir/cov_Psc1_Tro8-14-1.tsv
for file in $dir/*.covpercont; do python /proj/snic2021-22-602/scripts/Analysis_scripts/covpergenome_from_covpercontig_NOmetasizes.py "$file" Psc1_Tro8-14-1 >> $outdir/cov_Psc1_Tro8-14-1.tsv; done

echo -e "metaname\tgenomelen_bp\tGC\tmapped_bases\tperc_cov\tavg_depth" > $outdir/cov_Psc2_MWH-Mekk-C3.tsv
for file in $dir/*.covpercont; do python /proj/snic2021-22-602/scripts/Analysis_scripts/covpergenome_from_covpercontig_NOmetasizes.py "$file" Ga0081378_11 >> $outdir/cov_Psc2_MWH-Mekk-C3.tsv; done

echo -e "metaname\tgenomelen_bp\tGC\tmapped_bases\tperc_cov\tavg_depth" > $outdir/cov_Psc7.tsv
for file in $dir/*.covpercont; do python /proj/snic2021-22-602/scripts/Analysis_scripts/covpergenome_from_covpercontig_NOmetasizes.py "$file" Ga0376931_01 >> $outdir/cov_Psc7.tsv; done

echo -e "metaname\tgenomelen_bp\tGC\tmapped_bases\tperc_cov\tavg_depth" > $outdir/cov_Psp_MT-CBaFAMC5.tsv
for file in $dir/*.covpercont; do python /proj/snic2021-22-602/scripts/Analysis_scripts/covpergenome_from_covpercontig_NOmetasizes.py "$file" Ga0068562_11 >> $outdir/cov_Psp_MT-CBaFAMC5.tsv; done

echo -e "metaname\tgenomelen_bp\tGC\tmapped_bases\tperc_cov\tavg_depth" > $outdir/cov_Psp_MWH-Mekk-B1.tsv
for file in $dir/*.covpercont; do python /proj/snic2021-22-602/scripts/Analysis_scripts/covpergenome_from_covpercontig_NOmetasizes.py "$file" Psp_MWH-Mekk-B1 >> $outdir/cov_Psp_MWH-Mekk-B1.tsv; done

echo -e "metaname\tgenomelen_bp\tGC\tmapped_bases\tperc_cov\tavg_depth" > $outdir/cov_Flac.tsv
for file in $dir/*.covpercont; do python /proj/snic2021-22-602/scripts/Analysis_scripts/covpergenome_from_covpercontig_NOmetasizes.py "$file" RGRP01000 >> $outdir/cov_Flac.tsv; done

echo -e "metaname\tgenomelen_bp\tGC\tmapped_bases\tperc_cov\tavg_depth" > $outdir/cov_FspIIIbA1.tsv
for file in $dir/*.covpercont; do python /proj/snic2021-22-602/scripts/Analysis_scripts/covpergenome_from_covpercontig_NOmetasizes.py "$file" AZOF010000 >> $outdir/cov_FspIIIbA1.tsv; done

echo -e "metaname\tgenomelen_bp\tGC\tmapped_bases\tperc_cov\tavg_depth" > $outdir/cov_FspIIIbA2.tsv
for file in $dir/*.covpercont; do python /proj/snic2021-22-602/scripts/Analysis_scripts/covpergenome_from_covpercontig_NOmetasizes.py "$file" ATTB010000 >> $outdir/cov_FspIIIbA2.tsv; done

echo -e "metaname\tgenomelen_bp\tGC\tmapped_bases\tperc_cov\tavg_depth" > $outdir/SAR11_BaikalG1.tsv
for file in $dir/*.covpercont; do python /proj/snic2021-22-602/scripts/Analysis_scripts/covpergenome_from_covpercontig_NOmetasizes.py "$file" NSIJ010000 >> $outdir/SAR11_BaikalG1.tsv; done
