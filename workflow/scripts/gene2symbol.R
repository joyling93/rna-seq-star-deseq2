library(biomaRt)
library(tidyverse)
# useful error messages upon aborting
library("cli")

if(snakemake@config[["ref"]][["source"]] == "local") {
  df <- read.table(snakemake@input[["counts"]], sep='\t', header=1)
  info <- read.table('resources/star_genome/geneInfo.tab', sep='\t',header=0,skip = 1)
  df.sym<-df%>%left_join(info[,1:2],by=c("gene"="V1"))%>%
    select(V2,everything(),-gene)%>%
    rename(gene=V2)
  if(!"padj"%in%colnames(df.sym)) {
    #仅在定量时合并counts
    df.sym<-df.sym%>%group_by(gene)%>%
      summarise(across(everything(),sum))
  }
  write.table(df.sym, snakemake@output[["symbol"]], sep='\t', row.names=F)
  q(save="no")
}

# this variable holds a mirror name until
# useEnsembl succeeds ("www" is last, because 
# of very frequent "Internal Server Error"s)
mart <- "useast"
rounds <- 0
while ( class(mart)[[1]] != "Mart" ) {
  mart <- tryCatch(
    {
      # done here, because error function does not
      # modify outer scope variables, I tried
      if (mart == "www") rounds <- rounds + 1
      # equivalent to useMart, but you can choose
      # the mirror instead of specifying a host
      biomaRt::useEnsembl(
        biomart = "ENSEMBL_MART_ENSEMBL",
        dataset = str_c(snakemake@params[["species"]], "_gene_ensembl"),
        mirror = mart
      )
    },
    error = function(e) {
      # change or make configurable if you want more or
      # less rounds of tries of all the mirrors
      if (rounds >= 3) {
        cli_abort(
          str_c(
            "Have tried all 4 available Ensembl biomaRt mirrors ",
            rounds,
            " times. You might have a connection problem, or no mirror is responsive.\n",
            "The last error message was:\n",
            message(e)
          )
        )
      }
      # hop to next mirror
      mart <- switch(mart,
                     useast = "uswest",
                     uswest = "asia",
                     asia = "www",
                     www = {
                       # wait before starting another round through the mirrors,
                       # hoping that intermittent problems disappear
                       Sys.sleep(30)
                       "useast"
                     }
              )
    }
  )
}


df <- read.table(snakemake@input[["counts"]], sep='\t', header=1)

g2g <- biomaRt::getBM(
            attributes = c( "ensembl_gene_id",
                            "external_gene_name"),
            filters = "ensembl_gene_id",
            values = df$gene,
            mart = mart,
            )

annotated <- merge(df, g2g, by.x="gene", by.y="ensembl_gene_id")
annotated$gene <- ifelse(annotated$external_gene_name == '', annotated$gene, annotated$external_gene_name)
annotated$external_gene_name <- NULL
annotated <- annotated%>%group_by(gene)%>%summarise(across(everything(),sum))
write.table(annotated, snakemake@output[["symbol"]], sep='\t', row.names=F)


