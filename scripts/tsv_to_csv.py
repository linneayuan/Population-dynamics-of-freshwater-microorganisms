import pandas as pd
import csv
import sys
import os

#Path to existing file that was used to plot all samples from freshwater with geo location 
ex_filename = '/Users/linnea/Desktop/tillampad_bioinf/Population-dynamics-of-freshwater-microorganisms/data/visualization_dataset.csv'
#Read as dataframe
df_ex = pd.read_csv(ex_filename, sep=',', index_col=0)
#Add new column that will contain the coverage
df_ex.insert(3, 'Average_depth', '')

#Directory of tsv files from calculating the coverage
dir = '/Users/linnea/Desktop/tsv_files/'

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

    #Seeing which accession numbers in the dataset with coverage matches the accesssions in existing dataset
    for index, row in df_ex.iterrows(): 
        if index in accession:
            df_ex.at[index,'Average_depth']= df_in['avg_depth'][index]      #Add the coverage information to the existing dataset
    
    #Getting the organism name
    org = file.split('_')
    org = org[1].split('.')
    org = org[0]
    #Making a csv file containing geo location and coverage of organism
    df_ex.to_csv('/Users/linnea/Desktop/tillampad_bioinf/Population-dynamics-of-freshwater-microorganisms/data/geo_cov_'+org+'.csv', encoding='utf-8')