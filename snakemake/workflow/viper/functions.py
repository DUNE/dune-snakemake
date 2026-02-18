def hello_world():
    print("Hello world")

def make_check_jgf(checkpoints, final_stages, expand, processing_style='bulk'):

    def check_jgf(wildcards):
        with checkpoints.jgf.get().output[0].open() as f:
            nlines = sum(1 for line in f)
        if nlines == 0:
            return []
        elif processing_style == 'bulk':
            print('bulk output')
            return extract_output(final_stages) + ['justin-processed-dids.txt']
        elif processing_style == 'parallel':
            output = []
            for tar in final_stages:
                for out in tar.output:
                    output += expand(out, i=[i for i in range(nlines)])
                print(output)
            return output + ['justin-processed-dids.txt']
            # return parallel_output(nlines, final_stages) + ['justin-processed-dids.txt']
        else:
            raise RuntimeError(f'Unknown Processing style {processing_style}')
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