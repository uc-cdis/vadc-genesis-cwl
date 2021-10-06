class: CommandLineTool
cwlVersion: v1.0
doc: |
  Wraps the UW-GAC TopMED tool `define_segments.R`. Also produces a list of
  integers representing the lines in the segments.txt file that can be used to
  scatter assoc_single_r.cwl

requirements:
  DockerRequirement:
    dockerPull: python:3.7
  ResourceRequirement:
    coresMin: 1
    coresMax: 1
    ramMin: 2000
    ramMax: 2000
  InlineJavascriptRequirement: {}
  InitialWorkDirRequirement:
    listing:
    - entryname: gds_filenames.list
      entry: $(inputs.gds_filenames.join("\n");)
    - entryname: filter-segments.py
      entry: |
        # Extract lists of chromosomes and segment lines valid for the data
        import os


        def main():
            file_prefix = "$(inputs.file_prefix)"
            file_suffix = "$(inputs.file_suffix)"
            segments_file = "$(inputs.segment_file.path)"

            available_gds_files = set()
            with open("gds_filenames.list", "rt") as f:
                for line in f:
                    available_gds_files.add(os.path.basename(line.rstrip("\r\n")))
            chromosomes_present = set()
            segments = []
            with open(segments_file, "r") as f:
                for n, line in enumerate(f.readlines()):
                    chrom = line.split()[0]
                    if file_prefix + chrom + file_suffix in available_gds_files:
                        chromosomes_present.add(chrom)
                        segments += [n] 
                        # R uses 1 indexing, but line 0 is the header, so it all works out

            with open("chromosomes_present.txt", "w") as f:
                f.write(",".join([str(c) for c in chromosomes_present]))

            with open("segments_present.txt", "w") as f:
                f.write(",".join([str(s) for s in segments]))


        if __name__ == "__main__":
            main()

inputs:
  file_prefix:
    type: string
  file_suffix:
    type: string
  gds_filenames:
    label: GDS filenames
    doc: List of GDS filenames 
    type: string[]
  segment_file:
    doc: segments.txt file produced by define_segments_r.cwl
    type: File

outputs:
  chromosomes:
    type: string[]
    outputBinding:
      glob: chromosomes_present.txt
      outputEval: $(self[0].contents.split(",");)
      loadContents: true
  segments:
    type: string[]
    outputBinding:
      glob: segments_present.txt
      outputEval: $(self[0].contents.split(",");)
      loadContents: true


baseCommand:
- python3
- filter-segments.py
arguments: []
