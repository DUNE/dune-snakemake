# rule xrdcp:
#     input:
#         vf.justin_input_files
#     output:
#         "temp_input.h5"
#     shell:
#         """
#         xrdcp {input} {output}
#         ls -lht temp_input.h5
#         """
rule test:
    container: "/cvmfs/fifeuser2.opensciencegrid.org/sw/dune/2edc51222b88969999a17f5d2d7771937b9b7e50/lardon_sandbox"
    input:
        # "temp_input.h5"
        vf.justin_input_files
    output: "test.txt"
    shell:
        """
        echo "input:"
        input_file=$(head -n 1 {input})

        echo "Path: $PATH"
        #echo "xrd posix preload: ${{xrootd_posix_preload}}"

        if [ -z "${{xrootd_posix_preload:-}}" ]; then
          export xrootd_posix_preload=$(find /local_software/lardon/.pixi -name "libXrdPosixPreload.so")
          echo "Found xrootd_posix_preload: ${{xrootd_posix_preload}}"
        fi

        LD_PRELOAD=$xrootd_posix_preload lardon -file $input_file -out lardon -trk
        output_file=$(ls *lardon.h5 | head -n 1)
        echo $output_file > {output}
        """
final_stages = [
    rules.test,
]
