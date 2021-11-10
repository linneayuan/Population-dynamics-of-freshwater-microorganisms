import pandas as pd
datafile = 'convert_data.csv'
lat = []
long = []
coordinates = []

df = pd.read_csv(datafile, sep=',', index_col=0)

for index, row in df.iterrows():
    coordinates.append(str(row[0]).split(" "))

for list in coordinates: 
    if list[1] == 'S':
        value = '-' + str(list[0])
        lat.append(value)
    else: 
        lat.append(list[0])
    if list[3] == 'W':
        value = '-' + str(list[2])
        long.append(value)
    else: 
        long.append(list[2])

df['Latitude'] = lat 
df['Longitude'] = long

df.to_csv('converted_coordinate_data.csv', encoding='utf-8')

