## WGCNA script
## Aim here is to see how differentially expressed genes are organised in a network. Up and downregulated probes were used. 
setwd("set/path")
library(WGCNA)
options(stringsAsFactors = FALSE);
allowWGCNAThreads()
D<-read.table("differentially_expressed.txt", sep="\t",header=1, row.names=1)
# collapse probe with median expression 
agg<-aggregate(D, by=list(D$Probe.Set.Name), FUN=median)
D1<-data.frame(agg[,-c(2,3)], row.names=1)
##names(D1) would be: Probe.set.names in rows (total rows=2127), and 17 samples (of which 9 OPC and 8 OL) in columns
datExpr0<-data.frame(D1)
datExpr<-as.data.frame(t(datExpr0));
traitData = read.delim(file="trait_OPC_OL.txt", sep="\t", header=T,row.names=1);
datTraits<-traitData;
save(datExpr, datTraits, file = "WGCNAInput_OPC_OL.RData");
lnames<-load(file="WGCNAInput_OPC_OL.RData");
powers = c(c(1:10), seq(from = 12, to=20, by=2))
sft = pickSoftThreshold(datExpr, powerVector = powers, verbose = 5)
sizeGrWindow(9, 5);
par(mfrow = c(1,2));
cex1 = 0.9;
plot(sft$fitIndices[,1], -sign(sft$fitIndices[,3])*sft$fitIndices[,2], xlab="Soft Threshold (power)",ylab="Scale Free Topology Model Fit,signed R^2",type="n", main = paste("Scale independence"));
text(sft$fitIndices[,1], -sign(sft$fitIndices[,3])*sft$fitIndices[,2],labels=powers,cex=cex1,col="red");
abline(h=0.5,col="red");
plot(sft$fitIndices[,1], sft$fitIndices[,5],xlab="Soft Threshold (power)",ylab="Mean Connectivity", type="n",main = paste("Mean connectivity"));
text(sft$fitIndices[,1], sft$fitIndices[,5], labels=powers, cex=cex1,col="red");

A=adjacency(datExpr, type="signed", power=16);
print("starting TOM")
TOM = TOMsimilarity(A);
dissTOM = 1-TOM;

geneTree = hclust(as.dist(dissTOM), method = "average");
sizeGrWindow(12,9)
pdf(file="tree.pdf")
plot(geneTree, xlab="", sub="", main = "Gene clustering on TOM-based dissimilarity",labels = FALSE, hang = 0.04);
minModuleSize = 30;
dynamicMods = cutreeDynamic(dendro = geneTree, distM = dissTOM, deepSplit = 2, pamRespectsDendro = FALSE, minClusterSize = minModuleSize);

dynamicColors = labels2colors(dynamicMods);
table(dynamicColors);
dev.off()

sizeGrWindow(8,6)
pdf(file="dendrogram_color.pdf")
plotDendroAndColors(geneTree, dynamicColors, "Dynamic Tree Cut",dendroLabels = FALSE, hang = 0.03, addGuide = TRUE, guideHang = 0.05, main = "Gene dendrogram and module colors");
dev.off()

MEList = moduleEigengenes(datExpr, colors = dynamicColors)
MEs = MEList$eigengenes
MEDiss = 1-cor(MEs);
METree = hclust(as.dist(MEDiss), method = "average");
sizeGrWindow(7, 6)
pdf("MEDissThres_equal_0.05.pdf")
plot(METree, main = "Clustering of module eigengenes", xlab = "", sub = "")
MEDissThres = 0.05 
abline(h=MEDissThres, col = "red")
dev.off()

merge = mergeCloseModules(datExpr, dynamicColors, cutHeight = MEDissThres, verbose = 3);
mergedColors = merge$colors;
mergedMEs = merge$newMEs;
sizeGrWindow(12, 9)
pdf(file = "dendrogram_mergedModule.pdf")

plotDendroAndColors(geneTree, cbind(dynamicColors, mergedColors),c("Dynamic Tree Cut", "Merged dynamic"), dendroLabels = FALSE, hang = 0.03, addGuide = TRUE, guideHang = 0.05);
dev.off() 

moduleColors = mergedColors
colorOrder = c("grey", standardColors(50));
moduleLabels = match(moduleColors, colorOrder)-1;
MEs = mergedMEs;
save(MEs, moduleLabels, moduleColors, geneTree, file = "OPC_OL_networkConstruction-stepByStep.RData")
#module-Trait relatioship
lnames<-load(file="OPC_OL_networkConstruction-stepByStep.RData");
nGenes = ncol(datExpr);
nSamples = nrow(datExpr);
MEs0 = moduleEigengenes(datExpr, moduleColors)$eigengenes
MEs = orderMEs(MEs0)
moduleTraitCor = cor(MEs, datTraits, use = "p");
moduleTraitPvalue = corPvalueStudent(moduleTraitCor, nSamples);
sizeGrWindow(10,6)
pdf("Module_trait_relationship.pdf")
textMatrix = paste(signif(moduleTraitCor, 2), "\n(", signif(moduleTraitPvalue, 1), ")", sep = "");
dim(textMatrix) = dim(moduleTraitCor)
par(mar = c(6, 8.5, 3, 3));
labeledHeatmap(Matrix = moduleTraitCor,xLabels = names(datTraits), yLabels = names(MEs), ySymbols = names(MEs), colorLabels = FALSE,colors = blueWhiteRed(50), textMatrix = textMatrix, setStdMargins = FALSE, cex.text = 0.5, zlim = c(-1,1), main = paste("Module-trait relationships"));
dev.off()
print("completed")
