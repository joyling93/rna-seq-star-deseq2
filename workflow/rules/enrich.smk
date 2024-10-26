rule enrichment:
    input:
        "results/diffexp/{contrast}.diffexp.symbol.tsv",
    output:
        directory("results/enrichment/{contrast}"),
    params:
        contrast=get_contrast,
    threads: 10,
    conda:
        "/public/home/weiyifan/miniforge3/envs/enrichment"
    log:
        "logs/enrich/{contrast}.log",
    script:
        "../scripts/enrich.R"