def hello_world():
    print("Hello world")

def make_check_jgf(rules, checkpoints):
    def check_jgf(wildcards):
        with checkpoints.jgf.get().output[0].open() as f:
            nlines = sum(1 for line in f)
        if nlines == 0:
            return rules.NoJustinFiles.output
        else:
            return rules.Processing.output
    return check_jgf

def local_file(workflow, f):
    import os
    return os.path.join(workflow.basedir, f)

def extract_output(*targets):
    return [r.output for r in targets]

justin_input_files="justin_input_pfns.txt"