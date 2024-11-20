# 流程说明
此流程仅bulkrna测序数据分析。

## 流程图示例
![流程图](./dag.svg "流程图示例")
## 流程环境
``conda activate /public/home/weiyifan/miniforge3/envs/sk8``
## 流程部署
``snakedeploy deploy-workflow https://github.com/joyling93/rna-seq-star-deseq2 . --tag v1.1.5``
## 配置信息
config.yaml;
samples.yaml
## 流程运行
``snakemake -c30 --use-conda --cache``

# 样本配置  
样本和单元设置通过制表符分隔的表格文件（`.tsv`）指定。缺失值可以通过空列或写入`NA`来指定。

## 样本表

默认样本表是`config/samples.tsv`（如在`config/config.yaml`中配置）。每个样本指一个实际的物理样本，复制品（包括生物学和技术复制品）可以作为单独的样本指定。对于每个样本，你始终必须指定一个`sample_name`。此外，在`config/config.yaml`中`diffexp:`条目下指定的所有`variables_of_interest`和`batch_effects`都必须在`config/samples.tsv`中有相应的列。最后，样本表可以包含任意数量的其他列。所以，如果你不确定是否在某个时候需要一些手头已有的元数据，那就把它放入样本表中吧——未来的你会感谢你的。

## 单元表

默认单元表是`config/units.tsv`（如在`config/config.yaml`中配置）。对于每个样本，添加一个或多个测序单元（例如，如果每个样本有多个运行或泳道）。
### 接头修剪（adapters）

如果你在`config/config.yaml`中将`trimming: activate:`设置为`True`，则必须在`units.tsv`文件的`adapters`列中为每个单元提供至少一个`cutadapt`接头参数。你需要从测序提供方或已发表数据的研究元数据（或其作者）中找出生成一个单元的测序方案中使用的接头。然后，在该单元的`adapters`列中输入接头序列，前面加上[正确的`cutadapt`接头参数](https://cutadapt.readthedocs.io/en/stable/guide.html#adapter-types)。

### 文库制备方案的链特异性（strandedness）

为了从`STAR`输出中获得正确的`geneCounts`，你可以提供用于一个单元的文库制备方案的链特异性信息。`STAR`可以为非链特异性（`none`——这是默认值）、正向定向（`yes`）和反向定向（`reverse`）方案生成计数。将相应的值输入到`units.tsv`文件的`strandedness`列中。

### `.fastq`文件来源

对于每个单元，你必须为你的`.fastq`文件定义一个来源。这可以通过`fq1`、`fq2`和`sra`列来完成，有以下几种方式：
1. 对于单端读取，一个单一的`.fastq`文件（仅`fq1`列；`fq2`和`sra`列存在但为空）。条目可以是系统上的任何路径，但我们建议在分析目录中使用类似`raw/`数据目录的东西。
2. 对于成对末端读取，两个`.fastq`文件（`fq1`和`fq2`列；`sra`列存在但为空）。对于`fq1`列，`fq2`列也可以指向系统上的任何位置。
3. 一个序列读取档案（SRA）登录号（仅`sra`列；`fq1`和`fq2`列存在但为空）。工作流将自动下载相应的`.fastq`数据（目前假定为成对末端读取）。登录号通常以 SRR 或 ERR 开头，你可以使用[SRA Run/File Selector](https://trace.ncbi.nlm.nih.gov/Traces/study/)找到感兴趣研究的登录号。如果为同一单元同时指定了本地文件和 SRA 登录号，则将使用本地文件。

# 参数配置
## 参考基因组
source: local # 数据来源，可以是local或着根据版本信息去Ensembl下载，一般选local即可，本地有小鼠和人的index直接使用，选用Ensembl下载的话，可能下载失败  
species: homo_sapiens  # Ensembl species name  (e.g. homo_sapiens, mus_musculus, ...)  
release: 100   # Ensembl release (make sure to take one where snpeff data is available, check 'snpEff databases' output)  
build: GRCm38 # Ensembl build (e.g. GRCh38, GRCh37, GRCm38, ...)  

## `DESeq2`差异表达分析配置

为成功运行差异表达分析，你需要告知 DESeq2 使用哪些样本注释（注释是下面描述的`samples.tsv`文件中的列）。这是在`config.yaml`文件中通过`diffexp:`下的条目来完成的。条目的注释应提供所有必要的信息和链接。但如果有疑问，也请查阅[`DESeq2`手册](https://www.bioconductor.org/packages/devel/bioc/vignettes/DESeq2/inst/doc/DESeq2.html)。  
variables_of_interest:   
    condition: # 在samples.tsv中列出的变量名称，用于差异表达分组  
      base_level: untreated # 基准水平，用于计算相对差异表达  
  batch_effects: "" # 在samples.tsv中列出的变量名称，用于批次效应校正，一般不填  
  contrasts: # 定义差异比较的类型  
    treated-vs-untreated: #代表在 condition 分组中，比较treated水平和untreated水平间的差异  
      variable_of_interest: condition # 分组变量名称  
      level_of_interest: treated  # 差异变量名称  
  model: "" # DESeq2模型公式，一般不填

## `Venn`图配置
contrasts: #需和`DESeq2`中的`contrasts`命名一致，至少两个