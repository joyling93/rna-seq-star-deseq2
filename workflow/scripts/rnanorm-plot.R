library("ggplot2")
library(tidyverse)


data=read.table(snakemake@input[[1]],sep="\t",header = T)
data=column_to_rownames(data,var = 'X')%>%t()
data=subset(data,rowSums(data)>0)

p <- data %>%as.tibble()%>%
  pivot_longer(cols = colnames(data), names_to = "variable", values_to = "value")%>%
  mutate(value=log2(value+1))%>%
  ggplot(aes(x = variable, y = value)) +
  geom_boxplot(outlier.shape = NA) +
  labs(title = "TPM箱线图", x = "Gene", y = "log2(TPM+1)") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5))
ggsave(snakemake@output[[1]],p)

#相关矩阵
library(corrplot)
png(snakemake@output[[2]],width = 800, height = 800)
colmat <- colorRampPalette(c("#4B79B6","white", "#FDECA4", "#D33129"))
correlation_matrix <- cor(data)
corrplot(correlation_matrix, method = "color",# type = "upper",
         order = "hclust", tl.col = "black", tl.srt = 45,cl.lim=c(min(correlation_matrix),max(correlation_matrix)),is.corr=FALSE,col=colmat(200),
         addCoef.col = "blue", diag = FALSE)
dev.off()

#相关热图
library(pheatmap)
col_data <- read.table(
  snakemake@config[["samples"]],
  header = TRUE,
  row.names = "sample_name",
  check.names = FALSE
)
col_data <- col_data[order(row.names(col_data)), , drop = FALSE]
png(snakemake@output[[3]],width = 800, height = 800)
pheatmap(log2(data+1),show_rownames = F,annotation_col = col_data)
dev.off()

library(FactoMineR)
library("factoextra")
data.pca<-PCA(t(data), graph = F, scale.unit = T)
p <- fviz_pca_ind(data.pca, col.ind=col_data[,1], mean.point=F, addEllipses = T, 
                  legend.title="Groups", #ellipse.type="confidence", 
                  label="none",pointsize =3,
                  #ellipse.level=0.9, 
                  palette = c("#CC3333", "#339999"))+ #Cell配色哦 
  theme(panel.border = element_rect(fill=NA,color="black", size=1, linetype="solid"))
ggsave(snakemake@output[[4]],p)