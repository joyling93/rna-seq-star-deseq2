rule venn:
    input:
        expand("results/diffexp/{contrast}.diffexp.symbol.xls",contrast=config["venn"]["contrasts"]),
    output:
        "results/venn/venn.png"
    conda:
        "enrichment",
    log:
        "logs/venn.log",
    script:
        "../scripts/venn.R"