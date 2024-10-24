rule tpm:
    input:
        counts="results/counts/all.tsv",
        gtf="resources/genome.gtf",
    output:
        "results/rnanorm/tpm.tsv"
    log:
        "logs/rnanorm.log"
    conda:
        "../envs/rnanorm.yaml"
    script:
        "../scripts/rnanorm.py"


rule tpm_gene_2_symbol:
    input:
        counts="results/rnanorm/tpm.tsv",
    output:
        symbol="results/rnanorm/tpm.symbol.tsv",
    params:
        species=get_bioc_species_name(),
    log:
        "logs/gene2symbol/tpm.log",
    conda:
        "/public/home/weiyifan/miniforge3/envs/biomart2"
    script:
        "../scripts/gene2symbol.R"

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