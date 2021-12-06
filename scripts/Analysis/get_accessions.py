import pandas as pd
import csv
import sys
import os

#Path to existing file that was used to plot all samples from freshwater with geo location 
#ex_filename = '/proj/snic2021-22-602/data/geo_data_contains_organisms.csv'
#Read as dataframe
#df_ex = pd.read_csv(ex_filename, sep=';', index_col=0)
#Add new column that will contain the coverage

#Directory of tsv files from calculating the coverage
dir = '/proj/snic2021-22-602/analyses/Filtered_depth_cov/'
files = []

for file in os.listdir(dir):
    #Reading each tsv file into a dataframe
     file= pd.read_csv(dir+file, sep=',', index_col=0)
     files.append(file)

concat = pd.concat(files, join="outer", axis=0) 

is_duplicate = concat.index.duplicated(keep="first")
concat_nondup = concat[~is_duplicate]   

#Making a csv file containing geo location and coverage of organism
concat_nondup.to_csv('/proj/snic2021-22-602/analyses/Filtered_concat/dataset_pogenom.csv', encoding='utf-8')
