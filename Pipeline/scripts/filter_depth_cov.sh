#!/bin/sh -l

mkdir Prescreening_results/filtered_depth_files

for file in Prescreening_results/Coordinate_depth_files/geo_cov*
do
awk -F, '{ if ($8 >= 2)  print }' $file | awk -F, '{ if ($7 >= 50)  print }' > Prescreening_results/filtered_depth_files/filtered_${file##*/}
done
