import os

def local_file(f):
    return os.path.join(workflow.basedir, f)

def jgf_expand_names(inputs):
    def check_jgf(wildcards):
        results = []
        jgf_instances = glob_wildcards(os.path.join('justin_input_files', 'justin_pfn_{iJGF}.txt')).iJGF
        # print('jgf:', jgf_instances)
        for tar in inputs:
            results += expand(tar, iJGF=jgf_instances)
        # print(results)
        return results
    return check_jgf

def expand_with_justin_files(pattern, **kwargs):
    jgf_instances = glob_wildcards(os.path.join('justin_input_files', 'justin_pfn_{iJGF}.txt')).iJGF
    return expand(pattern, iJGF=jgf_instances, **kwargs)

def input_with_justin_files(pattern, **kwargs):
    def check_jgf(wildcards):
        results = expand_with_justin_files(pattern, **kwargs)
        # print(results)
        return results
    return check_jgf

def get_justin_jobstage():
    jobid=os.environ['JUSTIN_JOBSUB_ID'].split('@')[0].replace('.', '_')
    stageid=os.environ['JUSTIN_STAGE_ID']
    wfid=os.environ['JUSTIN_WORKFLOW_ID']
    return (jobid, stageid, wfid)

def tag_justin_ids(name):
    jobid, stageid, wfid = get_justin_jobstage()
    return name.replace(
            'jobid', jobid
        ).replace(
            'stageid', stageid
        ).replace(
            'wfid', wfid
        )

justin_input_list="justin_input_pfns.txt"