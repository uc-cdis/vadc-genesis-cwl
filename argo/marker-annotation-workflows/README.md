# Marker Annotation Workflows

## Annotate VCFs, extract rsids and variant metadata - `global-marker-annotation-wf.yml`

Steps:

1. Extract marker metadata (e.g., positions, IDs, and alleles) from GDS files; save to per-chromosome csvs.
2. Convert GDS to siteOnly minimal VCF per-chromosome.
3. Annotate siteOnly VCFs with VEP.
4. Extract RSIDs from annotated VCF; save to per-chromosome tsvs.

The marker metadata csvs and RSID csvs will be saved in the same "directory".

For future work, other considerations about file formats need to be considered and complicated decisions on
how to handle multiple annotations for the same mutation.

## Add additional annotations given already annotated VCFs - `add-from-vep-wf.yml`

* Uses the annotated slim VCFs generated by VEP
* Creates per-chromosome annotation gzipped tsv's for use in the GWAS workflow to add additional annotation
