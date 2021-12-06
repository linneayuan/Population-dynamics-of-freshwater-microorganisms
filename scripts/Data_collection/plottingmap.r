library(sf)
library(mapview)

pal = mapviewPalette("mapviewTopoColors")
# Load data
filename <- 'data/visualization_dataset.csv'
samples <- read.csv(filename, sep=",")

# Transform into spatial object
# coords - set the second columns in samples to longitude and latitude
# crs - set the map projection to WGS84
samples_sf <- st_as_sf(samples, coords = c("Longitude", "Latitude"),  crs = 4326)

# Map spatial object on interactive map
mapview(samples_sf, zcol=c("Includes_organism"), legend="TRUE")
