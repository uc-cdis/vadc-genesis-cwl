cwlVersion: v1.0
class: CommandLineTool
id: ld_pruning 
requirements:
  - class: DockerRequirement
    dockerPull: uwgac/topmed-master:2.10.0
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entryname: ld_prune.R
        entry: |-
          library(SeqArray)
          library(SeqVarTools)
          library(SNPRelate)

          # Load gds
          gds <- seqOpen("$(inputs.gds_file.path)", readonly=TRUE)
          variant.id <- seqGetData(gds, "variant.id")

          # Pruning with seed set for reproducibility
          set.seed(100)
          snpset <- snpgdsLDpruning(gds, snp.id=variant.id, maf=$(inputs.maf_threshold),
                                    missing.rate=$(inputs.missing_rate), method="corr",
                                    slide.max.bp=$(inputs.ld_win_size) * 1e6,
                                    ld.threshold=$(inputs.ld_r_threshold),
                                    num.thread=4, verbose=TRUE) 
          pruned <- unlist(snpset, use.names=FALSE)
          save(pruned, file="$(inputs.out_prefix)_$(inputs.chromosome)_pruned_variants.RData")

          seqClose(gds)

          # mem stats
          ms <- gc()
          cat(">>> Max memory: ", ms[1,6]+ms[2,6], " MB")

  - class: ResourceRequirement
    coresMin: 4
    coresMax: 4
    ramMin: 3000
    ramMax: 3000

inputs:
  gds_file:
    type: File
    doc: GDS file for a single chromosome.

  chromosome:
    type: string
    doc: The name of the chromosome you are currently processing.

  out_prefix:
    type: string
    doc: The prefix to use for all output file names.

  maf_threshold:
    type: float
    default: 0.01
    doc: Minor allele frequency threshold.

  missing_rate:
    type: float
    default: 0.01
    doc: Missingness threshold.

  ld_win_size: 
    type: int 
    default: 10 
    doc: LD bp window size. Will be multiplied by 1e6. 

  ld_r_threshold:
    type: float
    default: 0.32
    doc: LD R threshold.

outputs:
  pruned_snpset:
    type: File
    doc: The pruned snpset as an RData object.
    outputBinding:
      glob: $(inputs.out_prefix + '_' + inputs.chromosome + '_pruned_variants.RData')

baseCommand: [Rscript, ld_prune.R]
