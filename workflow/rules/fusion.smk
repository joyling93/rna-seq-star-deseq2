rule starFusion:
    input:
        unpack(get_fq),
    output:
        "results/Fusion/{sample}_star-fusion.fusion_predictions.tsv",
        "results/Fusion/{sample}_star-fusion.fusion_predictions.abridged.tsv"
    conda:
        "/public/home/weiyifan/miniforge3/envs/starFusion"
    log:
        "logs/starFusion_{sample}.log",
    shell:
        """
            STAR-Fusion --genome_lib_dir /public/data/public_data/genomic/species/STAR \
            --left_fq {wildcards.fq1} \
            --right_fq {wildcards.fq2} \
            --output_dir results/Fusion/
        """