library(ggvenn)

l<-purrr::map(snakemake@input,function(x){
    read.table(x,header=T)$gene
})
str(snakemake@config[["venn"]][["contrasts"]])
names(l)<-snakemake@config[["venn"]][["contrasts"]]
p<-ggvenn(l)
ggsave(snakemake@output[[1]],p)