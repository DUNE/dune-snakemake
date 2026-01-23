rule run_lar_null_in_art_out:
    benchmark:
        "benchmarks/test/benchmark0.txt"
    params:
        prefix=""
    shell:
        """
        {params.prefix}
        lar -n {params.n} -c {params.fcl} -o {output} {params.extra}
        """
rule run_lar_single_in_art_out:
    benchmark:
        "benchmarks/test/benchmark1.txt"
    params:
        prefix=""
    shell:
        """
        {params.prefix}
        lar -n {params.n} -c {params.fcl} -o {output} {params.extra} {input}
        """
rule run_lar_list_in_tfile_out:
    benchmark:
        "benchmarks/test/benchmark123.txt"
    params:
        prefix=""
    shell:
        """
        {params.prefix}
        lar -n {params.n} -c {params.fcl} -T {output} {params.extra} -S {input}
        """

rule run_lar_single_in_dump_text:
    benchmark:
        "benchmarks/test/benchmark2.txt"
    params:
        prefix=""
    shell:
        """
        {params.prefix}
        lar -n {params.n} -c {params.fcl} {params.extra} {input} > {output}
        """