cwlVersion: v1.0
class: CommandLineTool
id: pcrelate
requirements:
  - class: DockerRequirement
    dockerPull: uwgac/topmed-master:2.10.0
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entryname: pcrelate.R
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
          print(length(pca$unrels))
          pcs <- as.matrix(pca$vectors[,1:n_pcs])
          print(dim(pcs))
          sample.include <- samplesGdsOrder(seqData, pca$unrels)
          beta <- getobj("$(inputs.beta_file.path)")

          # iterator
          iterator <- SeqVarBlockIterator(seqData, variantBlock=$(inputs.variant_block_size))
          samp.blocks <- list(sample.include)
          i <- j <- 1

          out <- pcrelateSampBlock(iterator, betaobj=beta, pcs=pcs, sample.include.block1=samp.blocks[[i]],
                                   sample.include.block2=samp.blocks[[j]],
                                   ibd.probs=TRUE)

          save(out, file=paste0("$(inputs.out_prefix)", "_block", i, "_", j, ".RData"))

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

  beta_file:
    type: File
    doc: RData object file for PCrelate betas. 

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

  n_sample_blocks:
    type: int
    default: 1

outputs:
  pcrelate_out:
    type: File
    doc: RData files with PC-Relate results for each sample block. 
    outputBinding:
      glob: "*.RData"

baseCommand: [Rscript, pcrelate.R]
