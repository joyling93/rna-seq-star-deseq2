library(ggvenn)

l<-imap(snakemake@input,function(x){
    read.table(x)$gene
})

p<-ggvenn(l)
ggsave(snakemake@output[1],p)