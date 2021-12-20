library(geosphere)

file1 <- read.csv2(file.choose(), sep=",")

file1[,2]<-as.numeric(file1[,2])
file1[,3]<-as.numeric(file1[,3])
coord<-0
temp<-c(0,0)

for(i in 1:nrow(file1)) {
for(k in 1:nrow(file1)) {
temp[k]<-distm(c(file1[i,2], file1[i,3]), c(file1[k,2], file1[k,3]), fun = distGeo)
}
coord<-rbind(coord,temp)
}
coord<-coord[-1,]
row.names(coord)<-file1[,1]
colnames(coord)<-file1[,1]
