# Probe level analysis of affymetrix data

setwd("/set/path")

library(affy)
library(rae230aprobe)
library(rat2302probe)

m1<-data(rae230aprobe)
mdf1<-as.data.frame(rae230aprobe);

m2<-data(rat2302probe)
mdf2<-as.data.frame(rat2302probe);

######## extract probe level intensity from .CELL file:

cel_directory1<-"/path/to/directory/GSE5940 230A .CEL files"

cel_files1 <- list.files(cel_directory1, pattern = "\\.CEL$", full.names = TRUE)
setwd(cel_directory1)
Dat<-ReadAffy(filenames = cel_files1)
Datb<-bg.correct(Dat, method="mas")
Datbpm<-pmcorrect.mas(Datb)
Data1<-cbind(mdf1, Datbpm)
Data1<-Data1[,c(1,4,7:length(Data1))]
unique_Dat1 <- Data1[!duplicated(Data1$sequence), ]
unique_Dat1<-data.frame(unique_Dat1, row.names=1)

cel_directory2<-"/path/to/directory/GSE11218 .CEL files"
cel_files2 <- list.files(cel_directory2, pattern = "\\.CEL$", full.names = TRUE)
setwd(cel_directory2)
Dat<-ReadAffy(filenames = cel_files2)
Datb<-bg.correct(Dat, method="mas")
Datbpm<-pmcorrect.mas(Datb)
Data2<-cbind(mdf2, Datbpm)
Data2<-Data2[, c(1,4,7:length(Data2))]
unique_Dat2 <- Data2[!duplicated(Data2$sequence), ]
unique_Dat2<-data.frame(unique_Dat2, row.names=1)


## there were duplicate seq in both Rat230 (968 dup, 341442 unique) and rat230a (502 dup, 174976 unique). Duplicates spots (with respect to seq) were removed. Then take intersection Rat230 with Rat230a expt.


a<- intersect(rownames(unique_Dat2), row.names(unique_Dat1))
unique_Dat2_a<-unique_Dat2[a,]
combined_dat<-cbind(unique_Dat1,unique_Dat2_a[-1])
log_combined_dat<-data.frame("Probe.Set.Name"=combined_dat$Probe.Set.Name, log(combined_dat[, c(2:length(combined_dat))], base=2))

#remove negatives

df<-log_combined_dat[apply(log_combined_dat[-1],1,function(row) all(row>=0)), ]

#do quantile normalization

library("preprocessCore")
norm_dat<-normalize.quantiles(as.matrix(df[-1]))
norm_dat<-data.frame(rownames(df),"Probe.Set.Name"=df$Probe.Set.Name, norm_dat, row.names=1)
names(norm_dat)<-c(colnames(df))

#remove controls
df_filtered <- norm_dat[!startsWith(norm_dat[,1], "AFFX"), ]
df_filtered<-df_filtered[,c(1,11:14,2:6,15:18,7:10)]

#Remove 'absent' probes

FILENAMEpresent1<-cbind ((ifelse(df_filtered[,2:10]>c(median(df_filtered[,2]), median(df_filtered[,3]), median(df_filtered[,4]), median(df_filtered[,5]),median(df_filtered[,6]), median(df_filtered[,7]), median(df_filtered[,8]), median(df_filtered[,9]), median(df_filtered[,10])), 1,0)))
FILENAMEpresent1<-cbind(FILENAMEpresent1, apply(FILENAMEpresent1,1,sum))
FILENAMEpresent2<-cbind ((ifelse(df_filtered[,11:18]>c(median(df_filtered[,11]), median(df_filtered[,12]), median(df_filtered[,13]),median(df_filtered[,14]), median(df_filtered[,15]), median(df_filtered[,16]), median(df_filtered[,17]), median(df_filtered[,18])),1,0)))
FILENAMEpresent2<-cbind(FILENAMEpresent2, apply(FILENAMEpresent2,1,sum))
FILENAMEpresent3<-cbind ((ifelse(FILENAMEpresent1[,10]>=4.5 | FILENAMEpresent2[,9]>=4,1,0)))
selNdata_FILENAME <- D[FILENAMEpresent3[,1] > 0,]


#Differential expression analysis

library(limma)

L<-selNdata_FILENAME
design <- model.matrix(~ 0+factor(c(1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2)));
colnames(design) <- c("OPC", "OL");
fit <- lmFit(L[-c(1)], design);
cont.matrix<-makeContrasts(OLvsOPC=OL-OPC, levels=design);
fit2<-contrasts.fit(fit,cont.matrix);
fit2<-eBayes(fit2);
limres<-topTable(fit2,coef="OLvsOPC",number=90507,sort.by="none", adjust="BH");
limres_combined<-data.frame(limres,L)

## Probe.set.name to gene symbol is available for download: annotation_platformGPL1355-10794 (web link: https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GPL1355)
## differential expression criteria: OL vs OPC comparison: Probes for which the difference between groups were > 2 fold and the adjusted p-value < 0.05 were considered differentially expressed. 

## TE specific probes are available in this github repository. file name: Rat230_2.sorted.creps.annotated.txt












