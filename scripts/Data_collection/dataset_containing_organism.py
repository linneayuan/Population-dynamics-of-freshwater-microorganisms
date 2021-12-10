#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# Takes the file output from re-filtering_and_convert_coordinates.py and 
# extracts the samples that contain one or more of the organism of interest (on the genus level)
# using a metadata file that states which samples contain which organisms
"""
Created on Wed Dec  8 14:53:01 2021

@author: chelsea
"""

import pandas as pd
import numpy as np


#Path to organism file and creating dataframe
sra_with_organism_filename = '/home/chelsea/Downloads/gtdbtk.bac120.summary.tsv'
df_species = pd.read_csv(sra_with_organism_filename, sep=',') #OBS SPARADE DENNA SOM CSV
accession_genus = df_species[['user_genome','fastani_af']] #keep two columns in dataframe

#Extract accession numbers and add to list
accession = []
for index, row in accession_genus.iterrows():
        split_str = str(row[0]).split('.')
        accession.append(split_str[0])

#Adds accessions from list to dataframe
accession_genus['Accession'] = accession
accession_genus.set_index('Accession', inplace=True)

#Filter dataset for organisms of interest
organisms_of_interest = accession_genus[accession_genus['fastani_af'].str.contains('g__Polynucleobacter|g__Fonsibacter|g__Methylopumilus|g__Nanopelagicus|g__Planktophila|g__Methylopumilus_A')]

#Remove duplicate accessions from organisms_of_interest
organisms_duplicated = organisms_of_interest.index.duplicated(keep="first")
no_duplicate_organisms = organisms_of_interest[~organisms_duplicated]

#Path to accessions_coordinates file and creating dataframe
accessions_coordinates = '/home/chelsea/Dokument/X5/Slutkursen/accessions_coordinates.csv'
df_accessions_coordinates = pd.read_csv(accessions_coordinates, sep=',', index_col=0)

#Merge acccesions_coordinates with no_duplicate_organisms
merge = pd.merge(df_accessions_coordinates, no_duplicate_organisms, how="inner", left_index=True, right_index=True)
merge.index.name = 'ID'

#Create CSV file
merge.to_csv('/home/chelsea/Dokument/X5/Slutkursen/Project data/final_sra_river.csv', encoding='utf-8')

#Create .txt file
to_txt = merge
to_txt['ID'] = to_txt.index
to_txt = to_txt[['ID']]
to_txt.to_csv('/home/chelsea/Dokument/X5/Slutkursen/Project data/ID_contains_org.txt', header=False, index=False, sep='\n', mode='a')


