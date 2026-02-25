include: "../utils.smk"

rule test:
    input:
        "justin_pfn_{i}.txt"
    output:
        "test_justin_input_{i}.txt"
    shell:
        """
        echo "test" > {output}
        """
module basic_lar:
    snakefile:
        "../rules/basiclar.smk"

config.setdefault("n", "1")
dunesw_prefix = """
    set +euo pipefail
    echo "Setting up dune UPS"
    source /cvmfs/dune.opensciencegrid.org/products/dune/setup_dune.sh
    echo "Setting up dunesw"
    setup dunesw v10_14_00d00 -q e26:prof
    set -euo pipefail
"""


use rule run_lar_null_in_art_out from basic_lar as gen_cosmics with:
    output:
        "cosmics_{i}.root"
    benchmark: "benchmark/cosmics/{i}.bmk"
    params:
        prefix=dunesw_prefix,
        n=config["n"],
        fcl="prod_cosmics_protodunehd.fcl",
        extra="--no-memcheck --no-timing --no-trace"

use rule run_lar_list_in_tfile_out from basic_lar as pdhdana with:
    output: "pdhdana_{iJGF}.root"
    benchmark: "asdf_{iJGF}"
    input:
        input_list="justin_input_files/justin_pfn_{iJGF}.txt"
    params:
        prefix=dunesw_prefix,
        n="1",
        fcl=local_file("resources/pdhd_ana_MC_nosce_noreco.fcl"),
        extra="--no-memcheck --no-timing --no-trace"

rule merge:
    output: "merged.root"
    input:
        input_with_justin_files('pdhdana_{iJGF}.root')
    shell:
        '''
        set +euo pipefail
        echo "Setting up dune UPS"
        source /cvmfs/dune.opensciencegrid.org/products/dune/setup_dune.sh
        echo "Setting up dunesw"
        setup dunesw v10_14_00d00 -q e26:prof
        set -euo pipefail
        hadd {output} {input}
        '''

rule all:
    input:
        rules.merge.output