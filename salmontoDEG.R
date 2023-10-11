# siRNLTR12-int transfected (siR) vs siControl (sic) transfected in P7 OPC. salmon quant.sf files to differential expression analysis

setwd("/path/to/set/directory")
print("starting Tanay's script")
library(tximport)
library(DESeq2)
print("library ready")

files<-c("./sic1/quant.sf", "./sic2/quant.sf", "./sic3/quant.sf", "./sic4/quant.sf", "./siR1/quant.sf", "./siR2/quant.sf", "./siR3/quant.sf")
names(files)<-c("sic1", "sic2", "sic3", "sic4", "siR1","siR2", "siR3")

tx2gene<-read.table("Rnor_mart_export_tx2gene.txt", sep="\t");
txi <- tximport(files, type="salmon", tx2gene=tx2gene, countsFromAbundance="lengthScaledTPM");

setwd("/path/to/store/salmon_quasi_mode-analysis")
save (txi, file="txi.RData")
print("txi completed")
load("txi.RData")
group<-factor(c(rep("sic", 4), rep("siR", 3)))
df<-data.frame(group);
rownames(df)<-colnames(txi$counts);

write.table(txi$counts, "siRNLTR12-int-txicounts_BeforeNormalization.txt",  sep="\t")
dds<-DESeqDataSetFromTximport(txi, df, design= ~group)
dds = DESeq(dds)
normalized_dds<-counts(dds, normalized=TRUE);
write.table(normalized_dds, file="normalised_siRNLTR12-int.txt", sep="\t");

res<-results(dds, contrast=c("group","siR","sic"))

id2s<-read.table("ID2Symbol.txt", sep="\t", header=T, row.names=1)
res_id2s<-as.data.frame(res)
a<-intersect(row.names(res_id2s),row.names(id2s))
id2s_a<-as.data.frame(id2s[a,])
names(id2s_a)<-"Gene_symbol"
res_id2s<-data.frame(id2s_a, res_id2s)

write.table(res_id2s, "Res_effectOfsiRNLTR12-int.txt", sep="\t")

print("Differential expression Successfully completed")
