rule enrichment:
    input:
        "results/diffexp/{contrast}.diffexp.symbol.tsv",
    output:
        directory("results/enrichment/{contrast}"),
    params:
        contrast=get_contrast,
    conda:
        "/public/home/weiyifan/miniforge3/envs/seurat4"
    log:
        "logs/enrich/{contrast}.log",
    script:
        "../scripts/enrich.R"