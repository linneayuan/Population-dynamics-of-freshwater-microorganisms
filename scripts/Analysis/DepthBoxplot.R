#Load files
fsp1 <- read.csv2("filtered_geo_cov_FspIIIbA1.csv", sep=",")
fsp2 <- read.csv2("filtered_FspIIIbA1.csv", sep=",")
colnames(fsp2)[1] <- "ID"
fsp<-rbind(fsp1,fsp2)
remove(fsp1, fsp2)
pver1 <- read.csv2("filtered_geo_cov_Pver.csv", sep=",")
pver2 <- read.csv2("filtered_Pver.csv", sep=",")
colnames(pver2)[1] <- "ID"
pver<-rbind(pver1,pver2)
remove(pver1, pver2)
muni1 <- read.csv2("filtered_geo_cov_Muni.csv", sep=",")
muni2 <- read.csv2("filtered_Muni.csv", sep=",")
colnames(muni2)[1] <- "ID"
muni<-rbind(muni1,muni2)
remove(muni1, muni2)
nabu1 <- read.csv2("filtered_geo_cov_Nabu.csv", sep=",")
nabu2 <- read.csv2("filtered_Nabu.csv", sep=",")
colnames(nabu2)[1] <- "ID"
nabu<-rbind(nabu1,nabu2)
remove(nabu1, nabu2)
fubi1 <- read.csv2("filtered_geo_cov_Fubi.csv", sep=",")
fubi2 <- read.csv2("filtered_Fubi.csv", sep=",")
colnames(fubi2)[1] <- "ID"
fubi<-rbind(fubi1,fubi2)
remove(fubi1, fubi2)
mekk1 <- read.csv2("filtered_geo_cov_Psp-MWH-Mekk-B1.csv", sep=",")
mekk2 <- read.csv2("filtered_Psp-MWH-Mekk-B1.csv", sep=",")
colnames(mekk2)[1] <- "ID"
mekk<-rbind(mekk1,mekk2)
remove(mekk1, mekk2)

#Transpose files
pver<-t(pver)
fubi<-t(fubi)
muni<-t(muni)
nabu<-t(nabu)
fsp<-t(fsp)
mekk<-t(mekk)

#Keep only average depth
pver<-pver[8,]
fubi<-fubi[8,]
muni<-muni[8,]
nabu<-nabu[8,]
fsp<-fsp[8,]
mekk<-mekk[8,]

#Fill out to equal length by adding NaNs
for(i in 37:80){fsp[i]<-"NaN"}
for(i in 47:80){fubi[i]<-"NaN"}
for(i in 64:80){mekk[i]<-"NaN"}
for(i in 46:80){nabu[i]<-"NaN"}
for(i in 67:80){pver[i]<-"NaN"}

#Convert to numeric
pver<-as.numeric(pver)
fubi<-as.numeric(fubi)
muni<-as.numeric(muni)
nabu<-as.numeric(nabu)
fsp<-as.numeric(fsp)
mekk<-as.numeric(mekk)

#Create matrix containing all organisms and transpose it
mergeall<-rbind(fsp, fubi, mekk, muni, nabu, pver)
mergeall<-t(mergeall)

library(ggplot2)
library(ggrepel)

#Prepare for plot
group <- rep(c("FspIIIbA1\nrho=0.764\np-value<0.001", "Fubi\nrho=0.415\np-value<0.001", "Mekk\nrho=0.0296\np-value=0.12", 
               "Muni\nrho=0.898\np-value<0.001", "Nabu\nrho=0.955\np-value<0.001", "Pver\nrho=0.627\np-value<0.001"), 
               each=80)
duration <- c(fsp, fubi, mekk, muni, nabu, pver)
dat <- data.frame(group=group, duration=duration)

#Create boxplot
ggplot(dat, aes(x=group, y=duration)) + 
  geom_boxplot() + 
  labs(title="Average depth for all organisms") + 
  xlab("Organism + Mantel test rho and p-value") + 
  ylab("Average depth") + 
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(text=element_text(size=12), axis.text=element_text(size=12))

