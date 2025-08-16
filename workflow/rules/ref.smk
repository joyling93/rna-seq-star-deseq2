if config["ref"]["source"] == "ensembl":
    rule get_genome:
        output:
            "resources/genome.fasta",
        log:
            "logs/get-genome.log",
        params:
            species=config["ref"]["species"],
            datatype="dna",
            build=config["ref"]["build"],
            release=config["ref"]["release"],
        cache: True
        wrapper:
            "v3.5.3/bio/reference/ensembl-sequence"


    rule get_annotation:
        output:
            "resources/genome.gtf",
        params:
            species=config["ref"]["species"],
            fmt="gtf",
            build=config["ref"]["build"],
            release=config["ref"]["release"],
            flavor="",
        cache: True
        log:
            "logs/get_annotation.log",
        wrapper:
            "v3.5.3/bio/reference/ensembl-annotation"


    rule genome_faidx:
        input:
            "resources/genome.fasta",
        output:
            "resources/genome.fasta.fai",
        log:
            "logs/genome-faidx.log",
        cache: True
        wrapper:
            "v3.5.3/bio/samtools/faidx"


    rule bwa_index:
        input:
            "resources/genome.fasta",
        output:
            multiext("resources/genome.fasta", ".amb", ".ann", ".bwt", ".pac", ".sa"),
        log:
            "logs/bwa_index.log",
        resources:
            mem_mb=369000,
        cache: True
        wrapper:
            "v3.5.3/bio/bwa/index"


    rule star_index:
        input:
            fasta="resources/genome.fasta",
            annotation="resources/genome.gtf",
        output:
            directory("resources/star_genome"),
        threads: 20
        params:
            extra=lambda wc, input: f"--sjdbGTFfile {input.annotation} --sjdbOverhang 100 --limitGenomeGenerateRAM 169632691637",
        log:
            "logs/star_index_genome.log",
        cache: True
        wrapper:
            "v3.5.3/bio/star/index"

else:
    rule get_genome:
        params:
            config["ref"]["species"],
        output:
            "resources/genome.fasta",
        shell:
            """
                ln -s /public/home/xiezhuoming/xzm/ref/starFusion/{params[0]}/ctat_genome_lib_build_dir/ref_genome.fa resources/genome.fasta
            """


    rule get_annotation:
        params:
            config["ref"]["species"],
        output:
            "resources/genome.gtf",
        shell:
            """
                ln -s /public/home/xiezhuoming/xzm/ref/starFusion/{params[0]}/ctat_genome_lib_build_dir/ref_annot.gtf resources/genome.gtf
            """

    rule star_index:
        input:
            fasta="resources/genome.fasta",
            annotation="resources/genome.gtf",
        output:
            directory("resources/star_genome"),
        params:
            config["ref"]["species"],
        shell:
            """
                ln -s /public/home/xiezhuoming/xzm/ref/starFusion/{params[0]}/ctat_genome_lib_build_dir/ref_genome.fa.star.idx resources/star_genome
            """

rule get_template:
    output:
        dir=directory("resources/template"),
    shell:
        """
            cp -r "/public/home/xiezhuoming/xzm/ref/rmd_templete/rna/" resources/template
        """