enrich_ora<- function(gene_symbol,db,out_dir,use_internal_data=F){
                suppressMessages(library(clusterProfiler))
                suppressMessages(library(org.Hs.eg.db))
                suppressMessages(library(org.Mm.eg.db))
                #suppressMessages(library(org.Rn.eg.db))
                #suppressMessages(library(org.Ss.eg.db))
                suppressMessages(library(KEGG.db))
                dir.create(out_dir,recursive = T)
                db<-
                        switch(db,
                               homo_sapiens=c('org.Hs.eg.db','Homo sapiens','hsa'),
                               mus_musculus=c('org.Mm.eg.db','Mus musculus','mmu'),
                               rno=c('org.Rn.eg.db','Rattus norvegicus','rno'),
                               ss=c('org.Ss.eg.db','Sus scrofa','susScr')
                        )
                gene_symbol <- gene_symbol$gene
                print(head(gene_symbol))
                eg = bitr(gene_symbol, fromType="SYMBOL", toType="ENTREZID", OrgDb=db[1])
                geneList<-eg$ENTREZID
                pl <- list()
                
                safe_enrichGO<-possibly(enrichGO,'no results')
                ego1 <- enrichGO(gene         = geneList,
                                 OrgDb         = db[1],
                                 keyType       = 'ENTREZID',
                                 ont           = "BP",
                                 pAdjustMethod = "BH",
                                 pvalueCutoff  = 0.01,
                                 qvalueCutoff  = 0.05,
                                 readable=T)
                write.table(ego1,file=file.path(out_dir,'GO_bp_enrich_result.tsv'),quote=F,sep='\t',row.names=F,col.names=T)
                
                if(!is.null(ego1)){
                        p<-dotplot(ego1, showCategory=30) + ggtitle("BP for ORA")
                        if(dim(p$data)[1]>0){
                                pl<-append(pl,list(p))
                                ggsave(file.path(out_dir,'bp_ora.png'),p,width=20,height = 12)
                                ggsave(file.path(out_dir,'bp_ora.pdf'),p,width=20,height = 12)
                        }
                }
                print('bp done')
                
                ego2 <- enrichGO(gene         = geneList,
                                 OrgDb         = db[1],
                                 keyType       = 'ENTREZID',
                                 ont           = "MF",
                                 pAdjustMethod = "BH",
                                 pvalueCutoff  = 0.01,
                                 qvalueCutoff  = 0.05,
                                 readable=T)
                write.table(ego2,file=file.path(out_dir,'GO_mf_enrich_result.tsv'),quote=F,sep='\t',row.names=F,col.names=T)
                
                if(!is.null(ego2)){
                        p<-dotplot(ego2, showCategory=30) + ggtitle("MF for ORA")
                        if(dim(p$data)[1]>0){
                                pl<-append(pl,list(p))
                                ggsave(file.path(out_dir,'mf_ora.png'),p,width=20,height = 12)
                                ggsave(file.path(out_dir,'mf_ora.pdf'),p,width=20,height = 12)
                        }
                }
                print('mf done')
                
                ego5 <- enrichGO(gene         = geneList,
                                 OrgDb         = db[1],
                                 keyType       = 'ENTREZID',
                                 ont           = "CC",
                                 pAdjustMethod = "BH",
                                 pvalueCutoff  = 0.01,
                                 qvalueCutoff  = 0.05,
                                 readable=T)
                write.table(ego5,file=file.path(out_dir,'GO_cc_enrich_result.tsv'),quote=F,sep='\t',row.names=F,col.names=T)
                
                if(!is.null(ego5)){
                        p<-dotplot(ego5, showCategory=30) + ggtitle("CC for ORA")
                        if(dim(p$data)[1]>0){
                                pl<-append(pl,list(p))
                                ggsave(file.path(out_dir,'CC_ora.png'),p,width=20,height = 12)
                                ggsave(file.path(out_dir,'CC_ora.pdf'),p,width=20,height = 12)
                        }
                }
                print('cc done')
                
                safe_enrichKEGG<-possibly(enrichKEGG,'no results')
                ego4 <- enrichKEGG(gene         = geneList,
                                   organism     = db[3],
                                   pvalueCutoff = 0.05,
                                   use_internal_data = use_internal_data
                                   )
                
                if(!is.null(ego4)){
                        p<-dotplot(ego4, showCategory=30) + ggtitle("kegg for ORA")
                        if(dim(p$data)[1]>0){
                                pl<-append(pl,list(p))
                                ggsave(file.path(out_dir,'kegg_ora.png'),p,width=20,height = 12)
                                ggsave(file.path(out_dir,'kegg_ora.pdf'),p,width=20,height = 12)
                                ego4<-setReadable(ego4,OrgDb = db[1], keyType="ENTREZID")
                                write.table(ego4,file=file.path(out_dir,'kegg_enrich_result.tsv'),quote=F,sep='\t',row.names=F,col.names=T)
                                
                        }
                }
                print('kegg done')
                
                dl <- 
                list('anno_index'=eg,
                     'bp_ora'=ego1,
                     'mf_ora'=ego2,
                     'cc_ora'=ego5,
                     'kegg_ora'=ego4)
                #saveRDS(dl,file.path(out_dir,'enrich_list.rds'))
                openxlsx::write.xlsx(dl,file.path(out_dir,'enrich_list.xlsx'),overwrite =T)
                
                Sys.sleep(30)
}

#读取差异表达基因
library(tidyverse)
gene_list=read.table(snakemake@input[[1]],header = T)
##ora
gl<-gene_list%>%
    mutate(type=ifelse(padj>0.99,'not_significant',
        ifelse(log2FoldChange>0,'up','down')))%>%split(.$type)
db<-snakemake@config[['ref']][['species']]
if(!db%in%c("homo_sapiens","org.Mm.eg.db")){
    db<-"homo_sapiens"
}
walk(gl,safely(enrich_ora),
    db=db,out_dir=snakemake@output[[1]])
##gsea