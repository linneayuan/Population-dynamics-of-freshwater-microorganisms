max(coord) #Get max
max(all) #Get max
min(coord) #Get min
min(all) #Get min
plot(coord[1, 1], all[1, 1], xlim=c(0, 12500), ylim=c(0,0.6), xlab="Distance (km)", ylab="Fst value", main="Density scatter plot (Muni)") #Edit manually; values obtained above goes into xlim and ylim
for(i in 2:110){
for(k in 1:110){
points(coord[i, k], all[i, k])}} #Plot all points onto the plot, except the first row
for(i in 1:110){
points(coord[1,i], all[1,i]) #Plot all points onto the plot from the first row
}
