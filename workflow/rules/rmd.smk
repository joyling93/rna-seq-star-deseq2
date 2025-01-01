rule rmd:
    input:
        "results/qc/multiqc_report.html",
    output:
        "results/report.html",
    conda:
        "seurat4",
    script:
        "../scripts/report.Rmd"