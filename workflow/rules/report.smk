rule rmd_report:
    input: 
        directory("resources/template"),
        directory("resources/enrichment"),
        directory("resources/Fusion"),
        directory("resources/rmats"),
        directory("resources/venn")
    output:
        "results/report.html",
    conda:
        "seurat4",
    shell:
        """
            Rscript --vanilla -e 'rmarkdown::render("resources/template/report.Rmd", output_file="../../results/report.html", quiet=FALSE)'
        """