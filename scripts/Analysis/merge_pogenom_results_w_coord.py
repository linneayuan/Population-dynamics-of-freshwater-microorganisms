#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Dec 17 12:17:11 2021

@author: chelsea
"""
import pandas as pd

#Read csv with accessions from pogenom results
accessions = '/home/chelsea/Dokument/X5/Slutkursen/pogenom_coordinates/FspIIIbA1_accessions.csv'
df_accessions = pd.read_csv(accessions, sep=',', index_col=0) #OBS SPARADE DENNA SOM CSV

#Read csv with full dataset including accessions and coordinates
matthias_and_366 = '/home/chelsea/Dokument/X5/Slutkursen/geo_data_contains_639_organisms.csv'
df_matthias_366 = pd.read_csv(matthias_and_366, sep=',', index_col=0) #OBS SPARADE DENNA SOM CSV

#Merge accessions from pogenom with the full dataset to get pogenom accessions with coordinates
merge = pd.merge(df_matthias_366, df_accessions, how="right", left_index=True, right_index=True)

#save as csv
merge.to_csv('/home/chelsea/Dokument/X5/Slutkursen/FspIIIbA1_accessions_coordinates.csv', encoding='utf-8')
