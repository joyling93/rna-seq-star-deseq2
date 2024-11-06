rule starFusion:
    input:
        unpack(get_fq),
    output:
        "results/Fusion/{sample}_{unit}_star-fusion.fusion_predictions.tsv",
        "results/Fusion/{sample}_{unit}_star-fusion.fusion_predictions.abridged.tsv"
    conda:
        "/public/home/weiyifan/miniforge3/envs/starFusion"
    log:
        "logs/starFusion_{sample}_{unit}.log",
    shell:
        """
            STAR-Fusion --genome_lib_dir f'/public/home/weiyifan/xzm/ref/starFusion/{config["ref"]["species"]}/ctat_genome_lib_build_dir' \
            --left_fq {wildcards.fq1} \
            --right_fq {wildcards.fq2} \
            --output_dir results/Fusion/
        """