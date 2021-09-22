cwlVersion: v1.0
class: CommandLineTool
id: pcrelate_beta 
requirements:
  - class: DockerRequirement
    dockerPull: uwgac/topmed-master:2.6.0
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entryname: pcrelate_betas.R
        entry: |-
          library(TopmedPipeline)
          library(SeqVarTools)
          library(GENESIS)

          gds <- seqOpen("$(inputs.gds_file.path)", readonly=TRUE)
          seqData <- SeqVarData(gds)

          # Filter to specified variants
          filterByFile(seqData, "$(inputs.variant_include_file.path)")

          pca <- getobj("$(inputs.pca_file.path)")
          n_pcs <- min($(inputs.n_pcs), length(pca$unrels))
          pcs <- as.matrix(pca$vectors[,1:n_pcs])
          sample.include <- samplesGdsOrder(seqData, pca$unrels)

          # iterator
          iterator <- SeqVarBlockIterator(seqData, variantBlock=$(inputs.variant_block_size))

          beta <- calcISAFBeta(iterator, pcs=pcs, sample.include=sample.include)

          save(beta, file="$(inputs.out_prefix)_$(inputs.chromosome)_pcrelate_beta.RData")

          seqClose(seqData)

          # mem stats
          ms <- gc()
          cat(">>> Max memory: ", ms[1,6]+ms[2,6], " MB\\n")

  - class: ResourceRequirement
    coresMin: 4
    coresMax: 4
    ramMin: 3000
    ramMax: 3000

inputs:
  gds_file:
    type: File
    doc: GDS file for a single chromosome.

  pca_file:
    type: File
    doc: RData object file for population PCs. 

  variant_include_file:
    type: File
    doc: RData object file for variants to include. 

  chromosome:
    type: string
    doc: The name of the chromosome you are currently processing.

  out_prefix:
    type: string
    doc: The prefix to use for all output file names.

  n_pcs:
    type: int
    default: 3
    doc: Number of PCs to use in adjusting for ancestry.

  variant_block_size:
    type: int
    default: 1024 

outputs:
  beta:
    type: File
    doc: Estimated PC-relate beta values.
    outputBinding:
      glob: "*.RData"

baseCommand: [Rscript, pcrelate_betas.R]
