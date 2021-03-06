library(sf)
library(mapview)

pal = mapviewPalette("mapviewTopoColors")

#Choose file based on organism, these contain avg_depth and perc_cov
filename <- 'data/geo_cov_FspIIIbA1.csv'

filename <- 'data/geo_cov_FspIIIbA2.csv'

filename <- 'data/depth_files_with_all_info/geo_cov_Fubi.csv'

filename <- 'data/geo_cov_Muni.csv'

filename <- 'data/depth_files_with_all_info/geo_cov_Nabu.csv'
filename <- 'data/geo_cov_Pver.csv'
filename <- 'data/depth_files_with_all_info/geo_cov_Pcos.csv'
filename <- 'data/geo_cov_Psp-MWH-Mekk-B1.csv'

samples <- read.csv(filename, sep=";")

# Transform into spatial object
# coords - set the second columns in samples to longitude and latitude
# crs - set the map projection to WGS84
samples_sf <- st_as_sf(samples, coords = c("Longitude", "Latitude"),  crs = 4326)

# Map spatial object on interactive map by coverage percentages
#mapview(samples_sf, zcol=c("perc_cov"), legend="TRUE")

# Map spatial object on interactive map by average depth
depth_thresh_2 <- samples_sf[samples_sf$avg_depth>=2,] #threshold 2
Psp_MWH_Mekk_B1 <- depth_thresh_2[depth_thresh_2$perc_cov>=50,] #threshhold perc_cov>=50
mapview(Psp_MWH_Mekk_B1, at=seq(2,122,10), zcol=c("avg_depth"), legend="TRUE")



