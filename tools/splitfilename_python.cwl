class: CommandLineTool
cwlVersion: v1.0
requirements:
  DockerRequirement:
    dockerPull: python:3.7
  ResourceRequirement:
    coresMin: 1
    coresMax: 1
    ramMin: 200
    ramMax: 200
  InlineJavascriptRequirement: {}
  InitialWorkDirRequirement:
    listing:
    - entryname: splitfilename.py
      entry: |
        import os
        import sys

        def main(file_path):
            bname = os.path.basename(file_path)
            pfx = bname.split("chr")[0] + 'chr'
            with open('file_prefix', 'wt') as o:
                o.write(pfx)
        
            sfx = "." + ".".join(bname.split("chr")[1].split(".")[1:])
            with open('file_suffix', 'wt') as o:
                o.write(sfx)
        
        if __name__ == "__main__":
            main(sys.argv[1])

inputs:
  vcf_file:
    type: File
    inputBinding:
      position: 0

outputs:
  file_prefix: 
    type: string
    outputBinding:
      glob: file_prefix
      outputEval: $(self[0].contents)
      loadContents: true

  file_suffix:
    type: string
    outputBinding:
      glob: file_suffix
      outputEval: $(self[0].contents)
      loadContents: true

baseCommand:
- python3
- splitfilename.py
arguments: []
