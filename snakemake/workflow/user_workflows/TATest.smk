from viper import functions as utils
import os
module basic_lar:
    snakefile:
        "../rules/basiclar.smk"
config.setdefault("n", "1")
dunesw_prefix = """
    set +euo pipefail
    echo "Setting up dune UPS"
    source /cvmfs/dune.opensciencegrid.org/products/dune/setup_dune.sh
    echo "Setting up dunesw"
    source /cvmfs/fifeuser1.opensciencegrid.org/sw/dune/1438eeae45f7657c6ae4e0227fb5fe3585b648ca/ProtoDUNE-BSM/v10_01_04d00/localProducts_larsoft_v10_01_04d00_e26_prof/setup
    setup dunesw v10_01_04d00 -q e26:prof
    set -euo pipefail

    export FHICL_FILE_PATH=/cvmfs/fifeuser1.opensciencegrid.org/sw/dune/1438eeae45f7657c6ae4e0227fb5fe3585b648ca/ProtoDUNE-BSM/v10_01_04d00/work/fcl/:$FHICL_FILE_PATH
"""

rule make_threshold_fcl:
    input:
        utils.local_file(workflow, "resources/run_ta_threshold_custom.fcl"),
    output:
        "run_ta_threshold_custom_{thresh}M.fcl"
    shell:
        """
        sed -e "s/changeme/{wildcards.thresh}/" {input} > {output}
        """

use rule run_lar_list_in_art_out from basic_lar as ta_threshold with:
    output: "custom_ta_{thresh}_{iJGF}.root"
    benchmark: "bmk_{thresh}_{iJGF}"
    input:
        # input_list=utils.justin_input_files,
        input_list="justin_input_files/justin_pfn_{iJGF}.txt",
        fcl="run_ta_threshold_custom_{thresh}M.fcl"
    shadow: 'shallow'
    params:
        prefix=dunesw_prefix,
        n="10",
        fcl=rules.make_threshold_fcl.output,
        extra="--no-timing --no-trace"

justin_jobid, justin_stage, justin_wf = utils.get_justin_jobstage()

rule multi_thresh:
    input:
        utils.jgf_expand_names(
            [f'custom_ta_{thresh}' + '_{iJGF}.root' for thresh in range(1,20)],
            checkpoints,
            expand,
            glob_wildcards
        )
    output:
        "custom_ta_merged_jjjustinjob_jsjustinstage_jwjustinwf.tar.gz".replace(
            'justinjob', justin_jobid
        ).replace(
            'justinstage', justin_stage
        ).replace('justinwf', justin_wf)
    shell:
        """
        tar -czf {output} {input}
        """

rule print_env:
    output:
        "env.txt"
    shell:
        "env | tee -a env.txt"

final_stages = [
    rules.multi_thresh
]