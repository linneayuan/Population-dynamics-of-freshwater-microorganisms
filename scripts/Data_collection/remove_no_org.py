#Script that clears the samples that do not contain our organisms of interest
import pandas as pd 

#Specify file and load into dataset
filename = '/Users/linnea/Desktop/tillampad_bioinf/Population-dynamics-of-freshwater-microorganisms/data/visualization_dataset.csv'
df=pd.read_csv(filename, sep=',', index_col=0)

#Go through file and keep all the samples that contain organisms of interes
#according to earlier script that specified 'yes' if the contained them.
for index,row in df.iterrows(): 
    if df['Includes_organism'][index]=='no':
        df.drop(index, axis=0, inplace=True)
df = df.drop("Includes_organism", axis=1)
#Save output 
df.to_csv('/Users/linnea/Desktop/tillampad_bioinf/Population-dynamics-of-freshwater-microorganisms/data/geo_data_containing_organisms.csv', encoding='utf-8')