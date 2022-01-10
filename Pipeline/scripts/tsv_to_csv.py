#script for merging coverages with coordinates

import pandas as pd
import csv
import sys
import os

#Path to existing file that was used to plot all samples from freshwater with geo location 
ex_filename = sys.argv[1]
#Read as dataframe
df_ex_org = pd.read_csv(ex_filename, sep=',')

df_ex_no_index = df_ex_org[['Accession', 'Latitude', 'Longitude']]

df_ex = df_ex_no_index.set_index('Accession')

#Directory of tsv files from calculating the coverage
dir = 'Prescreening_results/cov_files/organism_coverages/'

for file in os.listdir(dir):
    #Reading each tsv file into a dataframe
    df_in = pd.read_csv(dir+file, sep='\t', index_col=0)
    print(df_in)
   
    merge = pd.merge(df_ex, df_in, how="inner", left_index=True, right_index=True)

    #Getting the organism name
    org = file.split('_')
    org = org[1].split('.')
    org = org[0]
    #Making a csv file containing geo location and coverage of organism
    merge.to_csv('Prescreening_results/Coordinate_depth_files/geo_cov_'+org+'.csv', encoding='utf-8')
