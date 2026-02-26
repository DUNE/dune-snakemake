#/bin/bash
tar \
    --exclude="workflow/benchmarks" \
    --exclude="workflow/*/__pycache__" \
    --exclude="*pdf" \
    --exclude="*.snakemake" \
    --exclude="*cache" \
    --exclude=".config" \
    -cf workflow.tar workflow/