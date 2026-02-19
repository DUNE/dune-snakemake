from viper import functions as utils
checkpoint jgf:
    output:
        directory("justin_input_files")
    params:
        nfiles=1 #Default
    shell:
        """
        # touch 
        mkdir justin_input_files/
        for ((i=0; i < {params.nfiles}; i++)); do
            echo "Calling justin get file -- $i"
            DID_PFN_RSE=$($JUSTIN_PATH/justin-get-file)
            echo $?
            if [ "$DID_PFN_RSE" == "" ] ; then
                echo "Could not get file. Exiting loop"
                break
            fi
            echo "justin-get-file successful: $DID_PFN_RSE"
            did=$(echo $DID_PFN_RSE | cut -d' ' -f1)
            pfn=$(echo $DID_PFN_RSE | cut -d' ' -f2)
            echo $did > justin_input_files/justin_did_$i.txt
            echo $pfn > justin_input_files/justin_pfn_$i.txt
        done
        """

rule combine_justin_inputs:
    output:
        dids="justin_input_dids.txt",
        pfns="justin_input_pfns.txt"
    input:
        dids=utils.jgf_expand_names(
            ['justin_input_files/justin_did_{iJGF}.txt'],
            checkpoints,
            expand,
            glob_wildcards,
        ),
        pfns=utils.jgf_expand_names(
            ['justin_input_files/justin_pfn_{iJGF}.txt'],
            checkpoints,
            expand,
            glob_wildcards,
        )

    shell:
        '''
        cat {input.dids} > {output.dids}
        cat {input.pfns} > {output.pfns}
        '''

rule LogInputFiles:
    input:
        'justin_input_dids.txt'
    output:
        'justin-processed-dids.txt'
    shell:
        'cp justin_input_dids.txt {output}'