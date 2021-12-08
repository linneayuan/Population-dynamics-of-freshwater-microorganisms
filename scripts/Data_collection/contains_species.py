# Script that checks a list of the samples containing species 
# of interest agains the data set and adds a column in the data
# that specifies if the sample contains the species or not 
# Running the script: python contains_species.py input_file text_file
import pandas as pd 
import sys

filename = str(sys.argv[1])
idfile = str(sys.argv[2])
ids = []
contains_org = []

# Load data
df = pd.read_csv(filename, sep=',', index_col=0)

# Store IDs from text file in list 
with open(idfile) as infile:
    for id in infile:
        id = id.strip('\n')
        ids.append(id)



# Check if ids in list match the ids in dataframe. Store the results 
# in a list. 
for index, row in df.iterrows():
    contains = []
    for id in ids: 
        if id == index:
           contains.append("yes")
        else:
            contains.append("no")

# For each row in the dataframe, if the list contains a yes
# store it in the final column that will be added to the dataframe
    if any("yes" in contains for string in contains): 
        contains_org.append("yes")
    else:
        contains_org.append("no")
    
# Add column into datafile 
df["Includes_organism"] = contains_org

# Save new csv file
df.to_csv('/Users/linnea/Desktop/tillampad_bioinf/Population-dynamics-of-freshwater-microorganisms/scripts/visualization_dataset.csv', encoding='utf-8')
    
