rule rmd:
    input:
        "results/qc/multiqc_report.html",
    output:
        "results/report.html",
    script:
        "../scripts/report.Rmd"