rule tpm:
    input:
        counts=rules.count_matrix.output,
        gtf="resources/genome.gtf",
    output:
        "results/rnanorm/tpm.tsv"
    log:
        "logs/rnanorm.log"
    conda:
        "../envs/rnanorm.yaml"
    script:
        "../scripts/rnanorm.py"

rule rnanorm_plot:
    input:
        tpm="results/rnanorm/tpm.tsv",
    output:
        "results/rnanorm/tpm_box.png",
        "results/rnanorm/tpm_cor.png",
        "results/rnanorm/tpm_heat.png",
        "results/rnanorm/tpm_pca.png",
    log:
        "logs/rnanorm_plot.log"
    conda:
        "../envs/rnanorm.yaml"
    script:
        "../scripts/rnanorm-plot.R"