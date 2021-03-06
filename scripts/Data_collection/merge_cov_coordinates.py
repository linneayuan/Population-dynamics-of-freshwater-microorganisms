#Script that divides the complete dataset into 
#multiple smaller csv files, one for each organism
import pandas as pd
import os

#Path to existing file that was used to plot all samples from freshwater with geo location 
ex_filename = '/proj/snic2021-22-602/data/geo_data_contains_organisms.csv'
#Read as dataframe
df_ex = pd.read_csv(ex_filename, sep=';', index_col=0)

#Directory of tsv files from calculating the coverage
dir = '/proj/snic2021-22-602/analyses/Mapping_Coverage_results/tsv_files/'

#Iterate through directory containg the tsv files with coverage info
for file in os.listdir(dir):
    accession = []
    #Reading each tsv file into a dataframe
    df_in = pd.read_csv(dir+file, sep='\t')

    #Extracting each accession number from the first column
    for index, row in df_in.iterrows():
        split_str = str(row[0]).split('/')
        split_str = split_str[5].split('.')
        accession.append(split_str[0])
    
    #Inserting a column of accession numbers only and setting them as index
    df_in['Accession'] = accession
    df_in.set_index('Accession', inplace=True)
    df_in = df_in.drop(["metaname"], axis=1)

    #Merge dataset on index
    merge = pd.merge(df_ex, df_in, how="left", left_index=True, right_index=True)
    
    #Getting the organism name
    org = file.split('_')
    org = org[1].split('.')
    org = org[0]
    #Making a csv file containing geo location and coverage of organism
    merge.to_csv('/proj/snic2021-22-602/analyses/Average_depth_files/geo_cov_'+org+'.csv', encoding='utf-8')
