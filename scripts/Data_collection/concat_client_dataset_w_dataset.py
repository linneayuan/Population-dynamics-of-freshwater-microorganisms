#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Dec 17 11:29:34 2021

@author: chelsea
"""
#Script for merging filtered accessions with second dataset
import pandas as pd

#Create dataframe of filtered accessions
filtered_accessions = '/home/chelsea/Dokument/X5/Slutkursen/final_sra.csv'
df_filtered_accessions = pd.read_csv(filtered_accessions, sep=',', index_col=0)

#Remove all columns except Latitude and Longitude
df_accessions_coord = df_filtered_accessions[['Latitude', 'Longitude']]

#Create dataframe of second metadata table
metadata = '/home/chelsea/Downloads/metadata_from_data_paper.csv'
df_metadata = pd.read_csv(metadata, sep=',')

#Keep only columns related to coordinates and ID
df_metadata_small = df_metadata[['sample_id','geographic location (longitude)', 'geographic location (latitude)']]
#Rename coordinate columns so names matches columns in filtered accessions
df_metadata_small = df_metadata_small.rename(columns={'geographic location (longitude)': 'Longitude', 'geographic location (latitude)': 'Latitude', 'sample_id':'ID'})
#Set ID as index
df_metadata = df_metadata_small.set_index('ID')

#Put the two datasets together
concat = pd.concat([df_metadata, df_accessions_coord], join="inner", axis=0)

concat.to_csv('/home/chelsea/Dokument/X5/Slutkursen/geo_data_contains_639_organisms.csv', encoding='utf-8')

