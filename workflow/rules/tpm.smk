rule tpm:
    input:
        counts=rules.count_matrix.output,
        gtf="resources/genome.gtf",
    output:
        "results/rnanorm/tpm.tsv",
    log:
        "logs/rnanorm.log",
    conda:
        "/public/home/weiyifan/anaconda3/envs/R_env"
    script:
        "../scripts/rnanorm.py"