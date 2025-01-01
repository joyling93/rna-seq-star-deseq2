rule rmats:
    input:
        aln=get_bam,
    output:
        directory("results/rmats/{contrast}"),
        temp(directory("results/rmats/{contrast}_tmp")),
    params:
        contrast=get_contrast,
    threads: 20,
    log:
        "logs/rmats_{contrast}.log",
    conda:
        "rmats",
    script:
        "../scripts/rmats.py"