library(sf)
library(mapview)

filename <- 'data/coordinate_data.csv'
samples <- read.csv(filename, sep=";")

samples_sf <- st_as_sf(samples, coords = c("Longitude", "Latitude"),  crs = 4326)

mapview(samples_sf, coords = c("Longitude", "Latitude"), crs = 4326)
