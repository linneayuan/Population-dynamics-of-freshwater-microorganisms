dir=/proj/snic2021-6-25/uu_students/pogenome_fastq/

#for k in *
#do
#if [ -e "/proj/snic2021-22-602/analyses/Filtered_depth_cov/accessions_filtered_geo_cov_${k}.csv.txt" ]; then
	#for i in $(cat /proj/snic2021-22-602/analyses/Filtered_depth_cov/accessions_filtered_geo_cov_${k}.csv.txt)
	#do
	#if [ -e "rest_genomes/${i}_1.fastq.gz" ]; then
		#cp rest_genomes/${i}*.gz $k
	#fi
	#done
#fi
#done

cd $dir

for i in $(cat /proj/snic2021-22-602/analyses/Filtered_depth_cov/accessions_filtered_geo_cov_Psp-MWH-Mekk-B1.csv.txt)
do
if [ -e "rest_genomes/${i}_1.fastq.gz" ]; then
	cp rest_genomes/${i}*.gz Psp-MWH-Mekk-B1
fi
done

for i in $(cat /proj/snic2021-22-602/analyses/Filtered_depth_cov/accessions_filtered_geo_cov_Pver.csv.txt)
do
if [ -e "rest_genomes/${i}_1.fastq.gz" ]; then
	cp rest_genomes/${i}*.gz Pver
fi
done

for i in $(cat /proj/snic2021-22-602/analyses/Filtered_depth_cov/accessions_filtered_geo_cov_Pcos.csv.txt)
do
if [ -e "rest_genomes/${i}_1.fastq.gz" ]; then
	cp rest_genomes/${i}*.gz Pcos
fi
done

for i in $(cat /proj/snic2021-22-602/analyses/Filtered_depth_cov/accessions_filtered_geo_cov_FspIIIbA1.csv.txt)
do
if [ -e "rest_genomes/${i}_1.fastq.gz" ]; then
	cp rest_genomes/$i*.gz FspIIIbA1
fi
done

for i in $(cat /proj/snic2021-22-602/analyses/Filtered_depth_cov/accessions_filtered_geo_cov_FspIIIbA2.csv.txt)
do
if [ -e "rest_genomes/${i}_1.fastq.gz" ]; then
	cp rest_genomes/$i*.gz FspIIIbA2
fi
done

for i in $(cat /proj/snic2021-22-602/analyses/Filtered_depth_cov/accessions_filtered_geo_cov_Fubi.csv.txt)
do
if [ -e "test_genomes/${i}_1.fastq.gz" ]; then
	cp test_genomes/$i*.gz Fubi
fi
done

for i in $(cat /proj/snic2021-22-602/analyses/Filtered_depth_cov/accessions_filtered_geo_cov_Nabu.csv.txt)
do
if [ -e "rest_genomes/${i}_1.fastq.gz" ]; then
	cp rest_genomes/$i*.gz Nabu
fi
done

for i in $(cat /proj/snic2021-22-602/analyses/Filtered_depth_cov/accessions_filtered_geo_cov_Muni.csv.txt)
do
if [ -e "rest_genomes/${i}_1.fastq.gz" ]; then
	cp rest_genomes/$i*.gz Psp-MWH-Mekk-B1 Muni
fi
done

rm rest_genomes/SRR*
