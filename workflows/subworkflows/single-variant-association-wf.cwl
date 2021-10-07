class: Workflow
cwlVersion: v1.0
label: UW GAC (GENESIS) Single Variant Association Workflow
doc: |
  UW GAC (GENESIS) Singe Variant Association Workflow.

  This is a CWL wrapper for the [UW GAC Single-Variant Association pipeline](https://github.com/UW-GAC/analysis_pipeline#single-variant) 

  _Filename requirements_:
  The input GDS file names should follow the pattern <A>chr<X>.<y>
  For example: 1KG_phase3_subset_chr1.gds
  Some of the tools inside the workflow infer the chromosome number from the
  file by expecting this pattern of file name.

requirements:
  InlineJavascriptRequirement: {}
  ScatterFeatureRequirement: {}
  StepInputExpressionRequirement: {}

inputs:
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
  null_model_outputs:
    type: File[]
  out_prefix:
    type: string?
    default: sva_
  phenotype_file:
    type: File
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
  define_segments:
    run: ../../tools/define_segments_r.cwl
    in:
      genome_build: genome_build
      n_segments: n_segments
      segment_length: segment_length
    out: [ segment_file ]

  split_filename:
    run: ../../tools/splitfilename_python.cwl
    in:
      vcf_file:
        source: gds_files
        valueFrom: $(self[0])
    out: [ file_prefix, file_suffix ]

  filter_segments:
    run: ../../tools/filter_segments.cwl
    in:
      file_prefix: split_filename/file_prefix
      file_suffix: split_filename/file_suffix
      gds_filenames:
        source: gds_files
        valueFrom: |-
          ${ var names = []; for(var i = 0; i < self.length; i++) { names.push(self[i].path) } return names }
      segment_file: define_segments/segment_file
    out: [ chromosomes, segments ]

  single_association:
    run: ../../tools/assoc_single_r.cwl
    scatter: segment
    in:
      file_prefix: split_filename/file_prefix
      file_suffix: split_filename/file_suffix
      gds_files: gds_files
      genome_build: genome_build
      null_model_file:
        source: null_model_outputs
        valueFrom: |
          ${
              var fil;
              var suffix = "_reportonly.RData";
              for (var i=0; i < self.length; i++) {
                var curr = self[i];
                if(typeof(curr.basename) == 'undefined' || curr.basename === null) {
                    var is_good = curr.path.indexOf(suffix, curr.path.length - suffix.length) !== -1;
                } else {
                    var is_good = curr.basename.indexOf(suffix, curr.basename.length - suffix.length) !== -1;
                }
                if (is_good) {
                  fil = curr;
                  break;
                }
              }
              return fil;
           }
      out_prefix: out_prefix
      phenotype_file: phenotype_file
      segment: filter_segments/segments
      segment_file: define_segments/segment_file
    out: [ assoc_single ]

  combine_shards:
    run: ../../tools/assoc_combine_r.cwl
    scatter: chromosome
    in:
      chromosome: filter_segments/chromosomes
      file_shards:
        valueFrom: |-
          ${ var file = []; for(var i = 0 ; i < self.length; i++) { if(self[i]) { file.push(self[i]) } } return file }
        source: single_association/assoc_single
      out_prefix: out_prefix
    out: [ combined ]

  plot:
    run: ../../tools/assoc_plots_r.cwl
    in:
      chromosomes:
        source: filter_segments/chromosomes
      combined:
        source: combine_shards/combined
      out_prefix:
        source: out_prefix
    out: [ plots ]
