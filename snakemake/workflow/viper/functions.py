import os 

def hello_world():
    print("Hello world")

def make_check_jgf(checkpoints, final_stages, expand, glob_wildcards):
    def check_jgf(wildcards):
        checkpoint_output = checkpoints.jgf.get().output[0]

        output = []
        jgf_instances = glob_wildcards(os.path.join('justin_input_files', 'justin_pfn_{i}.txt')).i
        print(jgf_instances)
        for tar in final_stages:
            for out in tar.output:
                output += expand(out, i=jgf_instances)
            print(output)
        if len(output) == 0:
            return []
        else:
            return output # + ['justin-processed-dids.txt']
    return check_jgf

def jgf_expand_names(inputs, checkpoints, expand, glob_wildcards):
    def check_jgf(wildcards):
        checkpoint_output = checkpoints.jgf.get().output[0]
        results = []
        jgf_instances = glob_wildcards(os.path.join('justin_input_files', 'justin_pfn_{iJGF}.txt')).iJGF
        for tar in inputs:
            results += expand(tar, iJGF=jgf_instances)
        print(results)
        return results
    return check_jgf

def local_file(workflow, f):
    import os
    return os.path.join(workflow.basedir, f)

def extract_output(targets):
    output = []
    for tar in targets:
        for out in tar.output:
            output.append(out)
    # print(output)
    return output

justin_input_files="justin_input_pfns.txt"