#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# Filters the dataset from the unwante samples that still remained after the 
# manual filtering. Then makes sure the coordinates are in the same format and 
# creates a file that can be used for plotting the samples on a world map. 
"""
Created on Tue Dec  7 11:41:20 2021

@author: chelsea
"""
import pandas as pd
import numpy as np

#Path to file from manual filtering and creating dataframe
samples_filename = '/Users/linnea/Desktop/tillampad_bioinf/Population-dynamics-of-freshwater-microorganisms/data/01_all_samples.csv'
df_samples = pd.read_csv(samples_filename, sep=',', index_col=0)

#Path to SRA_data and creating dataframe
sra_filename = '/Users/linnea/Desktop/tillampad_bioinf/Population-dynamics-of-freshwater-microorganisms/data/sra_data.csv'
df_sra = pd.read_csv(sra_filename, sep=',', index_col=1) 

#Keep only freshwater metagenomes with coordinates
counts = df_samples.index.value_counts() #Counts how many exists of each accession
count_frame = counts.to_frame() #Creates a dataframe with the counts
count_frame = count_frame[count_frame['all_samples'] == 3] #Keep only triplicates
triplicate_accession = count_frame.drop(['all_samples'], axis=1) #removes the count values

#Create whole dataset from only triplicates
merge = pd.merge(triplicate_accession, df_sra, how="inner", left_index=True, right_index=True) #Merge triplicates with original data
merge = merge.fillna('') #exchange NaN to empty cells
merge.index.name = 'ID'

#Manually look at csv file to find rows containing unwanted info
merge.to_csv('/Users/linnea/Desktop/tillampad_bioinf/Population-dynamics-of-freshwater-microorganisms/data/merge.csv', encoding='utf-8')

#Remove rows with unwanted info
merge = merge[~merge.stack().str.contains('sediment').any(level=0)]
merge = merge[~merge.stack().str.contains('freshwater sediment').any(level=0)]
merge = merge[~merge.stack().str.contains('marine').any(level=0)]
merge = merge[~merge.stack().str.contains('tap water').any(level=0)]
merge = merge[~merge.stack().str.contains('filtered water').any(level=0)]
merge = merge[~merge.stack().str.contains('virus').any(level=0)]
merge = merge[~merge.stack().str.contains('Freshwater Virus').any(level=0)]
merge = merge[~merge.stack().str.contains('viral').any(level=0)]
merge = merge[~merge.stack().str.contains('Viral').any(level=0)]
merge = merge[~merge.stack().str.contains('transcriptome').any(level=0)]
merge = merge[~merge.stack().str.contains('transcriptomic').any(level=0)]

#Manually look at csv file to find anything wrong
merge.to_csv('/Users/linnea/Desktop/tillampad_bioinf/Population-dynamics-of-freshwater-microorganisms/data/double_check.csv', encoding='utf-8')

#Join columns related to geographic coordinates
cols = ['lat_lon', 'latitude', 'longitude', 'geographic location (latitude)', 'geographic location (longitude)', 'latitude start', 'Latitude End', 'Longitude End', 'Latitude Start', 'Longitude Start', 'Latitude and longitude', 'latitude and longitude' ]
merge['coordinates'] = merge[cols].apply(lambda row: ' '.join(row.values.astype(str)), axis=1)


#Create dataset with accessions and coordinates
simple = merge[['coordinates']] #Get just coordinates and accessions
simple['coordinates'] = simple['coordinates'].str.strip() #remove space in the beginning of string
simple['coordinates'] = simple['coordinates'].str.strip() #remove space in the beginning of string
simple = simple[~simple.stack().str.contains('°').any(level=0)] #remove coordinates with degree
simple['coordinates'].replace('', np.nan, inplace = True)
simple = simple[simple['coordinates'].notna()] #keep only rows without nan

# Convert coordinates
lat = []
long = []
coordinates = []

for index, row in simple.iterrows():
    coordinates.append(str(row[0]).split(" "))

# Go through each of the coordinates and check which cardinal direction (letters) which will 
# determine if the value is positive or negative. 
for list in coordinates:
    if len(list) == 2:
        lat_value = str(list[0])
        lat.append(lat_value)
        long_value = str(list[1])
        long.append(long_value)
    else:
        if list[1] == 'S':
            lat_value = '-' + str(list[0])
            lat.append(lat_value)
        else: 
            lat.append(list[0])
        if list[3] == 'W':
            lon_value = '-' + str(list[2])
            long.append(lon_value)
        else: 
            long.append(list[2])

# Add the converted values to the dataset
simple['Latitude'] = lat 
simple['Longitude'] = long

#Create csv files of full dataset and simplified dataset
#Save the samples with all their info (all columns)
merge.to_csv('/Users/linnea/Desktop/tillampad_bioinf/Population-dynamics-of-freshwater-microorganisms/data/filtered_sra_data_w_coordinates.csv', encoding='utf-8')
#Save the data with only ID, latitude, longitude (for plotting)
simple.to_csv('/Users/linnea/Desktop/tillampad_bioinf/Population-dynamics-of-freshwater-microorganisms/data/accessions_coordinates.csv', encoding='utf-8')


