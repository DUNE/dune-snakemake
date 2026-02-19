def hello_world():
    print("Hello world")

# def make_check_jgf(checkpoints, final_stages, expand):

#     def check_jgf(wildcards):
#         with checkpoints.jgf.get().output[0].open() as f:
#             nlines = sum(1 for line in f)
#         if nlines == 0:
#             return []
#         else:
#             output = []
#             for tar in final_stages:
#                 for out in tar.output:
#                     output += expand(out, i=[i for i in range(nlines)])
#                 print(output)
#             return output + ['justin-processed-dids.txt']
#     return check_jgf

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