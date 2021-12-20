#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Dec 17 12:17:11 2021

@author: chelsea
"""
import pandas as pd
import os

#Read csv with full dataset including accessions and coordinates
all_organisms = '/proj/snic2021-22-602/data/geo_data_contains_639_organisms.csv'
df_all_organisms = pd.read_csv(all_organisms, sep=',', index_col=0)

#Define directory in which each organisms result directory lies
dir = '/proj/snic2021-22-602/analyses/POGENOM_results/'

#Merge pogenom accessions with coordinates by iterating over each organism POGENOM result directory 
for organism_dir in os.listdir(dir): 
	df_in = pd.read_csv(dir+organism_dir+'/'+organism_dir+'_accessions.csv', sep = ',', index_col=0)
	#Merge accessions from pogenom with the full dataset to get pogenom accessions with coordinates
	merge = pd.merge(df_all_organisms, df_in, how="right", left_index=True, right_index=True)
	merge.to_csv(dir+organism_dir+'/'+organism_dir+'_accessions_coordinates.csv', encoding='utf-8')
