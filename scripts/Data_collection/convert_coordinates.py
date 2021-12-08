# This script converts the coordinates that are written as, for example, "43.20 N 79.27 W"
# into the decimal degrees system, for instance "43.20 -79.27". The input is a csv
# file with the coordinates all in one cell. The output writes a new csv file with two  
# new columns, latitude and longitude separately. The original data is still included
# in the output.  
import pandas as pd
import sys

filename = str(sys.argv[1])
lat = []
long = []
coordinates = []

df = pd.read_csv(filename, sep=',', index_col=0)

#Store the coordinates as strings in list. The letters will have indexes 1 and 3. 
for index, row in df.iterrows():
    coordinates.append(str(row[0]).split(" "))

# Go through each of the coordinates and check which cardinal direction (letters) which will 
# determine if the value is positive or negative. 
for list in coordinates:
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
df['Latitude'] = lat 
df['Longitude'] = long

# Write a csv file of the new dataset and save in data folder 
df.to_csv('/Users/linnea/Desktop/tillampad_bioinf/Population-dynamics-of-freshwater-microorganisms/data/converted_coordinate_data.csv', encoding='utf-8')

