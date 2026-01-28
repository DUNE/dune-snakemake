# usage: snakemake --use-singularity  --snakefile test_container.smk  --cores 1
rule test:
    container:
        "/exp/dune/data/users/calcuttj/dunesw_v10_14_00d00.sif"
    shell:
        """
        echo 'hello world'

        ups active
        lar -h
        """