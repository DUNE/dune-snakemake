config.setdefault('dunesw_module', 'dune-sw')
rule test:
    output: "lar.txt"
    envmodules:
        config['dunesw_module']
    shell: 
        """
        #lar -h > {output}
        justin > {output}
        """

rule all:
    input: rules.test.output
