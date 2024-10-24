def get_bam(wildcards):
    return [f"results/star/{sample}_{unit}/Aligned.sortedByCoord.out.bam" for sample,unit in zip(wildcards.samples,wildcards.units)]

rule rmats:
    input:
        aln=get_bam
    output:
        directory("results/rmats/{sample}_{unit}"),
    log:
        "logs/rmats.log",
    scripts:
        "../scripts/rmats.py"