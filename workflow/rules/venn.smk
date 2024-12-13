rule venn:
    input:
        expand("results/diffexp/{contrast}.diffexp.symbol.tsv",contrast=config["venn"]["contrasts"]),
    output:
        "results/venn/venn.png"
    conda:
        "/public/home/weiyifan/miniforge3/envs/seurat4",
    log:
        "logs/venn.log",
    script:
        "../scripts/venn.R"