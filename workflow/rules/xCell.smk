rule xCell:
    input:
        "results/rnanorm/tpm.tsv",
    output:
        "results/xCell/xCell.csv",
        "results/xCell/xCell.png",
    conda:
        "seurat4"
    log:
        "logs/xCell.log",
    script:
        "../scripts/xCell.R"