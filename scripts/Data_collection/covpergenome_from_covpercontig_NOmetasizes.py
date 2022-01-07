### Usage: python covpergenome_from_covpercontig.py <coverage.percontig.perGBP.tsv> <genomename>

from sys import argv

with open(argv[1], 'r') as covpercont:
    header = covpercont.readline()
    data = covpercont.read().split('\n')

metaname = argv[1].split('_vs_')[0]

genomelen = 0
GCxlen = 0
avgCOVxlen = 0
covPERCxlen = 0
mapped_bases = 0

for line in data:
    if line != '':
        if line.split('\t')[0].startswith(argv[2]):
            genomelen = genomelen + float(line.split('\t')[1])
            GCxlen = GCxlen + (float(line.split('\t')[1]) * float(line.split('\t')[2]))
            avgCOVxlen = avgCOVxlen + (float(line.split('\t')[1]) * float(line.split('\t')[3]))
            covPERCxlen = covPERCxlen + (float(line.split('\t')[1]) * float(line.split('\t')[4]))
            mapped_bases = mapped_bases + float(line.split('\t')[5])

print(metaname + '\t' + str(genomelen) + '\t' + str(GCxlen/genomelen) + '\t' + str(mapped_bases) + '\t' + str(covPERCxlen/genomelen) + '\t' + str(avgCOVxlen/genomelen))
