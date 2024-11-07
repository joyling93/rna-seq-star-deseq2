rule starFusion:
    input:
        unpack(get_fq),
    output:
        "results/Fusion/{unit}/{sample}_star-fusion.fusion_predictions.tsv",
        "results/Fusion/{unit}/{sample}_star-fusion.fusion_predictions.abridged.tsv"
    conda:
        "/public/home/weiyifan/miniforge3/envs/starFusion"
    params:
        db=f'/public/home/weiyifan/xzm/ref/starFusion/{config["ref"]["species"]}/ctat_genome_lib_build_dir',
    log:
        "logs/starFusion_{sample}_{unit}.log",
    shell:
        """
            STAR-Fusion --genome_lib_dir {params.db} \
            --left_fq {input.fq1} \
            --right_fq {input.fq2} \
            --output_dir results/Fusion/{wildcards.unit}
        """