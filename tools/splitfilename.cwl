class: CommandLineTool
cwlVersion: v1.0
label: split_filename 

requirements:
- class: ResourceRequirement
  coresMin: 1 
  coresMax: 1 
  ramMin: 4000
  ramMax: 4000
- class: DockerRequirement
  dockerPull: uwgac/topmed-master:2.6.0
- class: InlineJavascriptRequirement

inputs:
  vcf_file:
    label: Variants file
    doc: Input file to sniff for file name splitting
    type: File

outputs:
  file_prefix:
    type: string
    outputBinding:
      outputEval: ${return inputs.vcf_file.basename.split('chr')[0] + 'chr'}

  file_suffix:
    type: string
    outputBinding:
      outputEval: |
        ${
          var suffix = inputs.vcf_file.path.split('chr')[1].split(".");
          suffix.shift(); // Get right of the chrom number
          return "." + suffix.join(".");
        }

baseCommand: [echo]
