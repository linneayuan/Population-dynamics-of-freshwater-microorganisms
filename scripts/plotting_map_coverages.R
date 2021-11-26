library(sf)
library(mapview)

pal = mapviewPalette("mapviewTopoColors")

#Choose file based on organism, the uncommented ones chosen
#filename <- 'data/depth_files/geo_cov_BaikalG1.csv'

#filename <- 'data/depth_files/geo_cov_Flac.csv'

filename <- 'data/depth_files/geo_cov_FspIIIbA1.csv'

filename <- 'data/depth_files/geo_cov_FspIIIbA2.csv'

filename <- 'data/depth_files/geo_cov_Fubi.csv'

filename <- 'data/depth_files/geo_cov_Muni.csv'

filename <- 'data/depth_files/geo_cov_Nabu.csv'

#filename <- 'data/depth_files/geo_cov_Paci.csv'

#filename <- 'data/depth_files/geo_cov_Pasy.csv'

#filename <- 'data/depth_files/geo_cov_Pdif.csv'

#filename <- 'data/depth_files/geo_cov_Pdur.csv'

#filename <- 'data/depth_files/geo_cov_Ppan.csv'

#filename <- 'data/depth_files/geo_cov_Psc1es-MAR-2.csv'

#filename <- 'data/depth_files/geo_cov_Psc1Tro8-14-1.csv'

#filename <- 'data/depth_files/geo_cov_Psc2.csv'

#filename <- 'data/depth_files/geo_cov_Psc7.csv'

#filename <- 'data/depth_files/geo_cov_Psph.csv'

#filename <- 'data/depth_files/geo_cov_Psp-MT-CBaFAMC5.csv'

filename <- 'data/depth_files/geo_cov_Psp-MWH-Mekk-B1.csv'

filename <- 'data/depth_files/geo_cov_Pver.csv'

filename <- 'data/depth_files/geo_cov_Pcos.csv'


#Contains avg_depth and perc_cov
filename <- 'data/depth_files_with_all_info/geo_cov_FspIIIbA1.csv'

filename <- 'data/depth_files_with_all_info/geo_cov_FspIIIbA2.csv'

filename <- 'data/depth_files_with_all_info/geo_cov_Fubi.csv'

filename <- 'data/depth_files_with_all_info/geo_cov_Muni.csv'

filename <- 'data/depth_files_with_all_info/geo_cov_Nabu.csv'

filename <- 'data/depth_files_with_all_info/geo_cov_Psp-MWH-Mekk-B1.csv'

filename <- 'data/depth_files_with_all_info/geo_cov_Pver.csv'

filename <- 'data/depth_files_with_all_info/geo_cov_Pcos.csv'

samples <- read.csv(filename, sep=",")

# Transform into spatial object
# coords - set the second columns in samples to longitude and latitude
# crs - set the map projection to WGS84
samples_sf <- st_as_sf(samples, coords = c("Longitude", "Latitude"),  crs = 4326)

# Map spatial object on interactive map by coverage percentages
mapview(samples_sf, zcol=c("perc_cov"), legend="TRUE")

# Map spatial object on interactive map by average depth
depth_thresh_2 <- samples_sf[samples_sf$avg_depth>=2,] #threshold 2
mapview(depth_thresh_2, zcol=c("avg_depth"), legend="TRUE")



