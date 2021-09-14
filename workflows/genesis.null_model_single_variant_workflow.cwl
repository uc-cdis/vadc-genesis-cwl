class: Workflow
cwlVersion: v1.0
label: GENESIS null model and single variant association workflow
requirements:
  - class: InlineJavascriptRequirement
  - class: ScatterFeatureRequirement
  - class: StepInputExpressionRequirement 

inputs:
  n_pcs:
    doc: Number of PCs to include as covariates.
    type: int?
    default: 0
  covariates:
    doc: |-
      Names of columns phenotype_file containing covariates. Separate by spaces.
      e.g. `gender height healthy`
    type: string?

  out_prefix:
    doc: Prefix for files created by the software
    type: string?
    default: genesis_vadc

  outcome:
    doc: Name of column in Phenotype File containing outcome variable.
    type: string
  outcome_is_binary:
    doc: |-
      TRUE if outcome is a binary (case/control) variable;
      FALSE if outcome is a continuous variable.
    type:
      type: enum
      symbols:
      - 'TRUE'
      - 'FALSE'
    default: 'FALSE'
  pca_file:
    doc: RData file with PCA results created by PC-AiR.
    type: File?
  phenotype_file:
    doc: RData file with AnnotatedDataFrame of phenotypes.
    type: File
  relatedness_matrix_file:
    doc: RData or GDS file with a kinship matrix or GRM.
    type: File?

  gds_files:
    label: GDS file
    doc: List of GDS files produced by VCF2GDS tool.
    type: File[]
  genome_build:
    type:
      type: enum
      symbols:
      - hg38
      - hg19
    default: hg19
  n_segments:
    doc: Number of segments (overrides segment length)
    type: int?
  segment_length:
    doc: Segment length in kb
    type: int?
    default: 10000

outputs:
  data:
    type: File[]
    outputSource: combine_shards/combined
  plots:
    type: File[]
    outputSource: plot/plots

steps:
  run_null_model:
    run: ./subworkflows/null-model-wf.cwl
    in:
      n_pcs: n_pcs
      covariates: covariates
      out_prefix:
        source: out_prefix
        valueFrom: $(self + '_null_model_')
      outcome: outcome
      outcome_is_binary: outcome_is_binary
      pca_file: pca_file
      phenotype_file: phenotype_file
      relatedness_matrix_file: relatedness_matrix_file
    out: [ null_model_files_directory, null_model_phenotype_file, null_model_reports ] 

  run_single_association_wf:
    run: ./subworkflows/single-variant-association-wf.cwl
    in:
      gds_files: gds_files
      genome_build: genome_build
      n_segments: n_segments
      null_model_file:
      out_prefix:
        source: out_prefix
        valueFrom: $(self + '_single_assoc_')
      phenotype_file:
        source: run_null_model/null_model_phenotype_file
      segment_length: segment_length
    out: [ data, plots ]
