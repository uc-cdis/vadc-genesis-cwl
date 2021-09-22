class: ExpressionTool
cwlVersion: v1.0
label: split_filename 

requirements:
- class: InlineJavascriptRequirement

inputs:
  vcf_file:
    label: Variants file
    doc: Input file to sniff for file name splitting
    type: File

outputs:
  file_prefix: string
  file_suffix: string

expression: |
  ${
     var prefix = inputs.vcf_file.basename.split('chr')[0] + 'chr';
     var suffix = inputs.vcf_file.path.split('chr')[1].split(".");
     suffix.shift();
     return {'file_prefix': prefix, 'file_suffix': "." + suffix.join(".")};
   }
