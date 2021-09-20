#!/usr/bin/env cwl-runner

# The report tool (`null_model_report.R`) needs the params file produced by the
# `null_model.R` script. But this dependency is hidden. The params file is given
# a fixed name `null_model.config.null_model.params`. This params file has the
# absolute path to the input files that were originally passed to
# `null_model.R`. 
# For this reason, it is best if the two scripts are run in the same docker
# container, one after the other, rather than as separate tools. 
# If run as separate tools we will have to recreate the 
# `null_model.config.null_model.params` file, replacing the old absolute paths
# with the new paths to the data files. 

class: CommandLineTool
cwlVersion: v1.0
label: UW GAC (GENESIS) Null Model
doc: |
  # Null model
  Association tests are done with a mixed model if a kinship matrix or GRM 
  (`relatedness_matrix_file`) is given in the config file. If 
  `relatedness_matrix_file` is `NA` or missing, testing is done with a fixed 
  effects model.  

  When combining samples from groups with different variances for a trait 
  (e.g., study or ancestry group), it is recommended to allow the null model to 
  fit heterogeneous variances by group using the parameter `group_var`. The 
  default pipeline options will then result in the following procedure:

  1. Fit null mixed model with outcome variable
      - Allow heterogeneous variance by `group_var`
      - Include covariates and PCs as fixed effects
      - Include kinship as random effect
  2. Inverse normal transform marginal residuals (if `inverse_normal = TRUE`)
  3. Rescale variance to match original (if `rescale_variance = "marginal"` or `"varcomp"`)
  4. Fit null mixed model using transformed residuals as outcome
      - Allow heterogeneous variance by `group_var`
      - Include covariates and PCs as fixed effects
      - Include kinship as random effect

requirements:
  DockerRequirement:
    dockerPull: uwgac/topmed-master:2.6.0
  InitialWorkDirRequirement:
    listing:
    - entryname: null_model.config
      entry: |-
        ${
           var arg = [];

           arg.push('out_prefix ' + inputs.out_prefix);
           arg.push('phenotype_file ' + inputs.phenotype_file.path);
           arg.push('outcome ' + inputs.outcome);
           arg.push('binary ' + inputs.outcome_is_binary);
           arg.push('n_pcs ' + inputs.n_pcs);

           if(inputs.pca_file){
             arg.push("pca_file " + inputs.pca_file.path);
           }

           if(inputs.relatedness_matrix_file){
             arg.push("relatedness_matrix_file " + inputs.relatedness_matrix_file.path);
           }

           if(inputs.covariates){
             arg.push("covars '" + inputs.covariates + "'");
           }

           if(inputs.sample_include_file) {
             arg.push("sample_include_file " + inputs.sample_include_file.path);
           }
           arg.push('out_phenotype_file ' + inputs.out_prefix + '_phenotypes.Rdata');
           return arg.join('\n');
         } 

    - entryname: script.sh
      entry: |
        set -xe
        cat null_model.config

        Rscript /usr/local/analysis_pipeline/R/null_model.R null_model.config
        Rscript /usr/local/analysis_pipeline/R/null_model_report.R null_model.config --version 2.6.0
        ls -al

        DATADIR=$(inputs.out_prefix)_datadir
        mkdir $DATADIR
        mv $(inputs.out_prefix)*.RData $DATADIR/

        REPORTDIR=$(inputs.out_prefix)_reports
        mkdir $REPORTDIR
        mv *.html $REPORTDIR/
        mv *.Rmd $REPORTDIR/
  InlineJavascriptRequirement: {}
  ResourceRequirement:
    coresMin: 2
    coresMax: 2
    ramMin: 2000
    ramMax: 2000

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
    default: genesis_topmed_null_model
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
  sample_include_file:
    doc: An RData object containing a vector of sample.id to include. 
    type: File?

outputs:
  null_model_files:
    doc: Null model files
    type: Directory
    outputBinding:
      glob: $(inputs.out_prefix)_datadir
  null_model_phenotype:
    doc: Phenotypes file
    type: File
    outputBinding:
      glob: $(inputs.out_prefix)_phenotypes.Rdata
  reports:
    doc: HTML Reports generated by the tool + Rmd files
    type: Directory
    outputBinding:
      glob: $(inputs.out_prefix)_reports

baseCommand:
- sh
- script.sh
arguments: []
