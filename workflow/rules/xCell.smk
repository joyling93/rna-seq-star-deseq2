rule xCell:
    input:
        "results/rnanorm/tpm.symbol.xls",
    output:
        "results/xCell/xCell.csv",
        "results/xCell/xCell.png"
    conda:
        "xCell"
    log:
        "logs/xCell.log",
    script:
        "../scripts/xCell.R"