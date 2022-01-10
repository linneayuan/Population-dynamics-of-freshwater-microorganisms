library(geosphere)
#Load file
file1 <- read.csv2(file.choose(), sep=",")
#Convert latitude and longitude into numeric
file1[,2]<-as.numeric(file1[,2])
file1[,3]<-as.numeric(file1[,3])
coord<-0
temp<-c(0,0)
#Calculate distances for all pairs of coordinates
for(i in 1:nrow(file1)) {
for(k in 1:nrow(file1)) {
temp[k]<-distm(c(file1[i,2], file1[i,3]), c(file1[k,2], file1[k,3]), fun = distGeo)
}
coord<-rbind(coord,temp) #Add the current row of distances into the matrix containing all distances
}
coord<-coord[-1,] #Remove the first row
row.names(coord)<-file1[,1] #Add row names from original file
colnames(coord)<-file1[,1] #Add column names from original file
