class: Workflow
cwlVersion: v1.0
label: genesis_null_model_wf

inputs:
  n_pcs: int?
  covariates: string?
  out_prefix: string?
  outcome: string
  outcome_is_binary:
    type:
      type: enum
      symbols:
      - 'TRUE'
      - 'FALSE'
    default: 'FALSE'
  pca_file: File?
  phenotype_file: File
  relatedness_matrix_file: File?

outputs:
  null_model_files_directory:
    type: Directory
    outputSource: run_null_model/null_model_files

  null_model_phenotype_file:
    type: File
    outputSource: run_null_model/null_model_phenotype

  null_model_reports:
    type: Directory
    outputSource: run_null_model/reports

steps:
  run_null_model:
    run: ../../tools/genesis_null_model.cwl
    in:
      n_pcs: n_pcs
      covariates: covariates
      out_prefix: out_prefix
      outcome: outcome
      outcome_is_binary: outcome_is_binary
      pca_file: pca_file
      phenotype_file: phenotype_file
      relatedness_matrix_file: relatedness_matrix_file
    out: [ null_model_files, null_model_phenotype, reports ]
