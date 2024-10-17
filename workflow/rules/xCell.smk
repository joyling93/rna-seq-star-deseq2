rule xCell:
    input:
        "results/rnanorm/tpm.symbol.tsv",
    output:
        "results/xCell/xCell.csv",
        "results/xCell/xCell.png"
    conda:
        "/public/home/weiyifan/miniforge3/envs/xCell"
    log:
        "logs/xCell.log",
    script:
        "../scripts/xCell.R"