rule rmd_report:
    input: 
        "results/qc/multiqc_report.html"
    output:
        "results/report.html",
    conda:
        "seurat4",
    shell:
        """
            Rscript --vanilla -e 'rmarkdown::render("resources/template/report.Rmd", output_file="../../results/report.html", quiet=FALSE)'
        """