#!/bin/sh -l

# Argument 1: reference fasta file containing all references
# Argument 2: accessions for the metagenomes that are to be prescreened 

#Check if pipe already has been run once
if [[  -f "Prescreening_results/" ]]
then
	echo "Files already exist"
else
	mkdir Prescreening_results/cov_files
	mkdir Prescreening_results/mapping
	mkdir Prescreening_results/mapping/fastq_files
fi

mapdir=Prescreening_results/mapping
outdir=Prescreening_results/cov_files

#Check if indexes for mapping have been built and builds them if they haven't
if [ ! -f "Prescreening_results/mapping/references/" ] && [ ! -d "Prescreening_results/mapping/references/" ]
then
	mkdir Prescreening_results/mapping/references
	# build one index for all 21 refs (need to build separate indexes for the refs if metagenomes should be mapped against only specific refs)
	bowtie2-build $1 Prescreening_results/mapping/references/ref
fi

chmod -R 777 Prescreening_results/

#Process each metagenome one at a time
for accession in $(cat $2)
do
if [[ ! -f "Prescreening_results/cov_files/${accession}.covpercont" ]]
then
# downloading 10% of the metagenome
vdb-dump $accession -r > row_column.txt
awk '{print $7}' row_column.txt > rows_with_colon.txt
rows=$(sed 's/,//g' rows_with_colon.txt)
percent_10_of_rows=$(expr $rows / 10)
fastq-dump $accession -N 1 -X $percent_10_of_rows --gzip --split-3 -O $mapdir/fastq_files

# map all subsampled stratfreshDB metagenomes with a 95% identity threshold against the specified ref(s)
bowtie2 -x $mapdir/references/ref -p 4 --ignore-quals --mp 1,1 --rdg 0,1 --rfg 0,1 --score-min L,0,-0.05 -1  $mapdir/fastq_files/${accession}_1.fastq.gz -2  $mapdir/fastq_files/${accession}_2.fastq.gz | samtools view -@ 4 -h -F 4 | samtools sort -@ 4 -o  $mapdir/${accession}_sorted.bam

# removing fastq file to save space
rm  $mapdir/fastq_files/${accession}*
fi
done

rm -r $mapdir/fastq_files
rm row_column.txt
rm rows_with_colon.txt

module load BEDTools/2.29.2
module load biopython/1.78

for accession in $(cat $2)
do
# determine coverage
genomeCoverageBed -ibam $mapdir/${accession}_sorted.bam > $outdir/${accession}.cov
# determine coverage per contig (script slightly modified from https://github.com/inodb/metassemble/blob/master/scripts/validate/map/gen_contig_cov_per_bam_table.py)
python scripts/contig_depth_cov_and_mapped_bases.py --isbedfiles $1 $outdir/${accession}.cov > $outdir/${accession}.covpercont
# remove files that won't be needed anymore (only uncomment when sure that the other steps run as they should)
rm -f $mapdir/${accession}.bam $outdir/${accession}.cov
done

mkdir $outdir/organism_coverages/

### compute average coverage depth for each metagenome over all contigs from...
# Cand. Fonsibacter ubiquis LSUCC0530
echo -e "metaname\tgenomelen_bp\tGC\tmapped_bases\tperc_cov\tavg_depth" > $outdir/organism_coverages/cov_Fubi_stratf1M.tsv
for file in $outdir/*.covpercont; do NAME=${file##*/}; python scripts/covpergenome_from_covpercontig_NOmetasizes.py "${NAME%.*}" "$file" CP024034.1 >> $outdir/organism_coverages/cov_Fubi_stratf1M.tsv; done
# Cand. Methylopumilus universlis SuperPang core 30kb WO 16S contig
echo -e "metaname\tgenomelen_bp\tGC\tmapped_bases\tperc_cov\tavg_depth" > $outdir/organism_coverages/cov_Muni_stratf1M.tsv
for file in $outdir/*.covpercont; do NAME=${file##*/}; python scripts/covpergenome_from_covpercontig_NOmetasizes.py "${NAME%.*}" "$file" Muni_Sc0- >> $outdir/organism_coverages/cov_Muni_stratf1M.tsv; done
# Cand. Nanopelagicus abundans MMS-IIB-91
echo -e "metaname\tgenomelen_bp\tGC\tmapped_bases\tperc_cov\tavg_depth" > $outdir/organism_coverages/cov_Nabu_stratf1M.tsv
for file in $outdir/*.covpercont; do NAME=${file##*/}; python scripts/covpergenome_from_covpercontig_NOmetasizes.py "${NAME%.*}" "$file" CP016779.1 >> $outdir/organism_coverages/cov_Nabu_stratf1M.tsv; done
# Cand. Planktophila vernalis MMS-IIA-15
echo -e "metaname\tgenomelen_bp\tGC\tmapped_bases\tperc_cov\tavg_depth" > $outdir/organism_coverages/cov_Pver_stratf1M.tsv
for file in $outdir/*.covpercont; do NAME=${file##*/}; python scripts/covpergenome_from_covpercontig_NOmetasizes.py "${NAME%.*}" "$file" CP016776.1 >> $outdir/organism_coverages/cov_Pver_stratf1M.tsv; done
# Polynucleobacter asymbioticus SuperPang core 50kb
echo -e "metaname\tgenomelen_bp\tGC\tmapped_bases\tperc_cov\tavg_depth" > $outdir/organism_coverages/cov_Pasy_stratf1M.tsv
for file in $outdir/*.covpercont; do NAME=${file##*/}; python scripts/covpergenome_from_covpercontig_NOmetasizes.py "${NAME%.*}" "$file" Pasy_Sc0- >> $outdir/organism_coverages/cov_Pasy_stratf1M.tsv; done
# Polynucleobacter paneuropaeus core 30kb WO ribprot contig
echo -e "metaname\tgenomelen_bp\tGC\tmapped_bases\tperc_cov\tavg_depth" > $outdir/organism_coverages/cov_Ppan_stratf1M.tsv
for file in $outdir/*.covpercont; do NAME=${file##*/}; python scripts/covpergenome_from_covpercontig_NOmetasizes.py "${NAME%.*}" "$file" Ppan_Sc0- >> $outdir/organism_coverages/cov_Ppan_stratf1M.tsv; done
# Polynucleobacter cosmopolitanus core parts
echo -e "metaname\tgenomelen_bp\tGC\tmapped_bases\tperc_cov\tavg_depth" > $outdir/organism_coverages/cov_Pcos.tsv
for file in $outdir/*.covpercont; do NAME=${file##*/}; python scripts/covpergenome_from_covpercontig_NOmetasizes.py "${NAME%.*}" "$file" Pcos_MWH-MoIso2 >> $outdir/organism_coverages/cov_Pcos.tsv; done

echo -e "metaname\tgenomelen_bp\tGC\tmapped_bases\tperc_cov\tavg_depth" > $outdir/organism_coverages/cov_Paci.tsv
for file in $outdir/*.covpercont; do NAME=${file##*/}; python scripts/covpergenome_from_covpercontig_NOmetasizes.py "${NAME%.*}" "$file" Ga0325193_11 >> $outdir/organism_coverages/cov_Paci.tsv; done

echo -e "metaname\tgenomelen_bp\tGC\tmapped_bases\tperc_cov\tavg_depth" > $outdir/organism_coverages/cov_Pdif.tsv
for file in $outdir/*.covpercont; do NAME=${file##*/}; python scripts/covpergenome_from_covpercontig_NOmetasizes.py "${NAME%.*}" "$file" Ga0325182_11 >> $outdir/organism_coverages/cov_Pdif.tsv; done

echo -e "metaname\tgenomelen_bp\tGC\tmapped_bases\tperc_cov\tavg_depth" > $outdir/organism_coverages/cov_Pdur.tsv
for file in $outdir/*.covpercont; do NAME=${file##*/}; python scripts/covpergenome_from_covpercontig_NOmetasizes.py "${NAME%.*}" "$file" Ga0077867_11 >> $outdir/organism_coverages/cov_Pdur.tsv; done

echo -e "metaname\tgenomelen_bp\tGC\tmapped_bases\tperc_cov\tavg_depth" > $outdir/organism_coverages/cov_Psph.tsv
for file in $outdir/*.covpercont; do NAME=${file##*/}; python scripts/covpergenome_from_covpercontig_NOmetasizes.py "${NAME%.*}" "$file" Psph_MWH-Weng1-1 >> $outdir/organism_coverages/cov_Psph.tsv; done

echo -e "metaname\tgenomelen_bp\tGC\tmapped_bases\tperc_cov\tavg_depth" > $outdir/organism_coverages/cov_Psc1_es-MAR-2.tsv
for file in $outdir/*.covpercont; do NAME=${file##*/}; python scripts/covpergenome_from_covpercontig_NOmetasizes.py "${NAME%.*}" "$file" Ga0081397_11 >> $outdir/organism_coverages/cov_Psc1_es-MAR-2.tsv; done

echo -e "metaname\tgenomelen_bp\tGC\tmapped_bases\tperc_cov\tavg_depth" > $outdir/organism_coverages/cov_Psc1_Tro8-14-1.tsv
for file in $outdir/*.covpercont; do NAME=${file##*/}; python scripts/covpergenome_from_covpercontig_NOmetasizes.py "${NAME%.*}" "$file" Psc1_Tro8-14-1 >> $outdir/organism_coverages/cov_Psc1_Tro8-14-1.tsv; done

echo -e "metaname\tgenomelen_bp\tGC\tmapped_bases\tperc_cov\tavg_depth" > $outdir/organism_coverages/cov_Psc2_MWH-Mekk-C3.tsv
for file in $outdir/*.covpercont; do NAME=${file##*/}; python scripts/covpergenome_from_covpercontig_NOmetasizes.py "${NAME%.*}" "$file" Ga0081378_11 >> $outdir/organism_coverages/cov_Psc2_MWH-Mekk-C3.tsv; done

echo -e "metaname\tgenomelen_bp\tGC\tmapped_bases\tperc_cov\tavg_depth" > $outdir/organism_coverages/cov_Psc7.tsv
for file in $outdir/*.covpercont; do NAME=${file##*/}; python scripts/covpergenome_from_covpercontig_NOmetasizes.py "${NAME%.*}" "$file" Ga0376931_01 >> $outdir/organism_coverages/cov_Psc7.tsv; done

echo -e "metaname\tgenomelen_bp\tGC\tmapped_bases\tperc_cov\tavg_depth" > $outdir/organism_coverages/cov_Psp_MT-CBaFAMC5.tsv
for file in $outdir/*.covpercont; do NAME=${file##*/}; python scripts/covpergenome_from_covpercontig_NOmetasizes.py "${NAME%.*}" "$file" Ga0068562_11 >> $outdir/organism_coverages/cov_Psp_MT-CBaFAMC5.tsv; done

echo -e "metaname\tgenomelen_bp\tGC\tmapped_bases\tperc_cov\tavg_depth" > $outdir/organism_coverages/cov_Psc7.tsv
for file in $outdir/*.covpercont; do NAME=${file##*/}; python scripts/covpergenome_from_covpercontig_NOmetasizes.py "${NAME%.*}" "$file" Ga0376931_01 >> $outdir/organism_coverages/cov_Psc7.tsv; done

echo -e "metaname\tgenomelen_bp\tGC\tmapped_bases\tperc_cov\tavg_depth" > $outdir/organism_coverages/cov_Psp_MT-CBaFAMC5.tsv
for file in $outdir/*.covpercont; do NAME=${file##*/}; python scripts/covpergenome_from_covpercontig_NOmetasizes.py "${NAME%.*}" "$file" Ga0068562_11 >> $outdir/organism_coverages/cov_Psp_MT-CBaFAMC5.tsv; done

echo -e "metaname\tgenomelen_bp\tGC\tmapped_bases\tperc_cov\tavg_depth" > $outdir/organism_coverages/cov_Psc7.tsv
for file in $outdir/*.covpercont; do NAME=${file##*/}; python scripts/covpergenome_from_covpercontig_NOmetasizes.py "${NAME%.*}" "$file" Ga0376931_01 >> $outdir/organism_coverages/cov_Psc7.tsv; done

echo -e "metaname\tgenomelen_bp\tGC\tmapped_bases\tperc_cov\tavg_depth" > $outdir/organism_coverages/cov_Psp_MT-CBaFAMC5.tsv
for file in $outdir/*.covpercont; do NAME=${file##*/}; python scripts/covpergenome_from_covpercontig_NOmetasizes.py "${NAME%.*}" "$file" Ga0068562_11 >> $outdir/organism_coverages/cov_Psp_MT-CBaFAMC5.tsv; done

echo -e "metaname\tgenomelen_bp\tGC\tmapped_bases\tperc_cov\tavg_depth" > $outdir/organism_coverages/cov_Psp_MWH-Mekk-B1.tsv
for file in $outdir/*.covpercont; do NAME=${file##*/}; python scripts/covpergenome_from_covpercontig_NOmetasizes.py "${NAME%.*}" "$file" Psp_MWH-Mekk-B1 >> $outdir/organism_coverages/cov_Psp_MWH-Mekk-B1.tsv; done

echo -e "metaname\tgenomelen_bp\tGC\tmapped_bases\tperc_cov\tavg_depth" > $outdir/organism_coverages/cov_Flac.tsv
for file in $outdir/*.covpercont; do NAME=${file##*/}; python scripts/covpergenome_from_covpercontig_NOmetasizes.py "${NAME%.*}" "$file" RGRP01000 >> $outdir/organism_coverages/cov_Flac.tsv; done

echo -e "metaname\tgenomelen_bp\tGC\tmapped_bases\tperc_cov\tavg_depth" > $outdir/organism_coverages/cov_FspIIIbA1.tsv
for file in $outdir/*.covpercont; do NAME=${file##*/}; python scripts/covpergenome_from_covpercontig_NOmetasizes.py "${NAME%.*}" "$file" AZOF010000 >> $outdir/organism_coverages/cov_FspIIIbA1.tsv; done

echo -e "metaname\tgenomelen_bp\tGC\tmapped_bases\tperc_cov\tavg_depth" > $outdir/organism_coverages/cov_FspIIIbA2.tsv
for file in $outdir/*.covpercont; do NAME=${file##*/}; python scripts/covpergenome_from_covpercontig_NOmetasizes.py "${NAME%.*}" "$file" ATTB010000 >> $outdir/organism_coverages/cov_FspIIIbA2.tsv; done

echo -e "metaname\tgenomelen_bp\tGC\tmapped_bases\tperc_cov\tavg_depth" > $outdir/organism_coverages/SAR11_BaikalG1.tsv
for file in $outdir/*.covpercont; do NAME=${file##*/}; python scripts/covpergenome_from_covpercontig_NOmetasizes.py "${NAME%.*}" "$file" NSIJ010000 >> $outdir/organism_coverages/SAR11_BaikalG1.tsv; done

for file in $outdir/organism_coverages/*; do sed 's/metaname/Accession/' $file > ${file}.temp; mv ${file}.temp $file; done

