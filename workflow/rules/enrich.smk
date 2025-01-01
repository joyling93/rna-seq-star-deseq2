rule enrichment:
    input:
        "results/diffexp/{contrast}.diffexp.symbol.xls",
    output:
        directory("results/enrichment/{contrast}"),
    params:
        contrast=get_contrast,
    threads: 10,
    conda:
        "enrichment"
    log:
        "logs/enrich/{contrast}.log",
    script:
        "../scripts/enrich.R"