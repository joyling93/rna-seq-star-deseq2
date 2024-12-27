log <- file(snakemake@log[[1]], open = "wt")
sink(log)
sink(log, type = "message")

library("DESeq2")

# load deseq2 data
dds <- readRDS(snakemake@input[[1]])
if(class(dds)[1]=="DGEList"){
    svg(snakemake@output[[1]])
    dev.off()
    q(save="no")
}
# obtain normalized counts
counts <- rlog(dds, blind=FALSE)
svg(snakemake@output[[1]])
plotPCA(counts, intgroup = snakemake@wildcards[["variable"]])
dev.off()
