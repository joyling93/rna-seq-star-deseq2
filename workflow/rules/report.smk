rule rmd_report:
    input: 
        directory("resources/template"),
        rules.enrichment.output,
        rules.starFusion.output,
        rules.rmats.output,
        rules.venn.output
    output:
        "results/report.html",
    conda:
        "seurat4",
    shell:
        """
            Rscript --vanilla -e 'rmarkdown::render("resources/template/report.Rmd", output_file="../../results/report.html", quiet=FALSE)'
        """