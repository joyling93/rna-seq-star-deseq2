
library(xCell)
exprMatrix = read.table(snakemake@input[[1]],header=TRUE,row.names=1, as.is=TRUE)

data=xCellAnalysis(t(exprMatrix))
out_dir=snakemake@output[[1]]
write.table(data,file=file.path(out_dir,"xCell.csv"))
library(pheatmap)
png(file.path(out_dir,"xCell.png"),height=8,width=4)
pheatmap(data,cluster_rows = F,cluster_cols = F)
dev.off()
