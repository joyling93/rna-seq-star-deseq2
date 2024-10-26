rule rmats:
    input:
        aln=get_bam
    output:
        directory("results/rmats/{contrast}"),
    params:
        contrast=get_contrast,
    log:
        "logs/rmats_{contrast}.log",
    script:
        "../scripts/rmats.py"