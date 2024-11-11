此流程仅bulkrna测序数据分析。

## 流程图示例
![流程图](./dag.svg "流程图示例")
## 流程环境
``conda activate /public/home/weiyifan/miniforge3/envs/sk8``
## 流程部署
``snakedeploy deploy-workflow https://github.com/joyling93/rna-seq-star-deseq2 . --tag v1.1.1``
## 配置信息
config.yaml;
samples.yaml
## 流程运行
``snakemake -c30 --use-conda --cache``