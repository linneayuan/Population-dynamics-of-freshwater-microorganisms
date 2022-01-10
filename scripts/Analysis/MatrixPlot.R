max(coord)
max(all)
min(coord)
min(all)
plot(coord[1, 1], all[1, 1], xlim=c(0, 12500), ylim=c(0,0.6), xlab="Distance (km)", ylab="Fst value", main="Density scatter plot (Muni)")
for(i in 2:110){
for(k in 1:110){
points(coord[i, k], all[i, k])}}
for(i in 2:110){
points(coord[1,i], all[1,i])
}
