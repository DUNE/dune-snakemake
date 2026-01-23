checkpoint jgf:
    output:
        pfns="justin_input_pfns.txt",
        dids="justin_input_dids.txt"
    params:
        nfiles=1 #Default
    shell:
        """
        touch {output}
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
            echo $did >> {output.dids}
            echo $pfn >> {output.pfns}
        done
        """

rule NoJustinFiles:
    output:
        "nojustinfiles.snakebite"
    shell:
        """
        echo "Retrieved no files from justin. Exiting safely" > {output}
        """
rule Processing:
    output:
        "processed.snakebite"
    shell:
        """
        touch {output}
        """