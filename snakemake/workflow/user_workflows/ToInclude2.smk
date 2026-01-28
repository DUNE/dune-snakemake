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
        "cosmics.root"
    params:
        prefix=dunesw_prefix,
        n=config["n"],
        fcl="prod_cosmics_protodunehd.fcl",
        extra="--no-memcheck --no-timing --no-trace"

use rule run_lar_single_in_art_out from basic_lar as g4 with:
    output:
        "g4_cosmics.root"
    input:
        "cosmics.root"
    params:
        prefix=dunesw_prefix,
        n=1,
        fcl=vf.local_file(workflow, "resources/run_g4_only.fcl"),
        extra="--no-memcheck --no-timing --no-trace"

use rule run_lar_single_in_dump_text from basic_lar as dump_g4 with:
    output: "g4_cosmics.txt"
    input:
        "g4_cosmics.root"
    params:
        prefix=dunesw_prefix,
        n="-1",
        fcl="eventdump.fcl",
        extra="--no-memcheck --no-timing --no-trace"

use rule run_lar_single_in_dump_text from basic_lar as dump_gen with:
    output: "cosmics.txt"
    input:
        "cosmics.root"
    params:
        prefix=dunesw_prefix,
        n="-1",
        fcl="eventdump.fcl",
        extra="--no-memcheck --no-timing --no-trace"
use rule run_lar_list_in_tfile_out from basic_lar as pdhdana with:
    output: "pdhdana.root"
    input:
        vf.justin_input_files
    params:
        prefix=dunesw_prefix,
        n="-1",
        fcl=vf.local_file(workflow, "resources/pdhd_ana_MC_nosce_noreco.fcl"),
        extra="--no-memcheck --no-timing --no-trace"

final_stages = [
    rules.dump_gen,
]