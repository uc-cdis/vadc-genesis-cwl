cwlVersion: v1.0
class: CommandLineTool
id: generate_grm 
requirements:
  - class: DockerRequirement
    dockerPull: uwgac/topmed-master:2.6.0
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entryname: generate_grm.R
        entry: |-
          library(SeqArray)
          library(SNPRelate)
          library(GENESIS)
          library(SeqVarTools)
          library(data.table)

          #phenotype/annotation file
          load("$(inputs.pheno_file.path)")
          #GDS file
          gds <- seqOpen("$(inputs.gds_file.path)", readonly=TRUE)
          #PCs
          load("$(inputs.pca_file.path)")

          #creating SeqVarData obj
          annot@data=annot@data[match(seqGetData(gds, "sample.id"), annot@data$sample.id),]
          all.equal(annot$sample.id, seqGetData(gds, "sample.id"))
          seqData <- SeqVarData(gds, sampleData=annot)

          #pruning
          snpset <- snpgdsLDpruning(gds, method="corr", slide.max.bp=10e6, ld.threshold=sqrt(0.1), verbose=TRUE, num.thread=5, maf=0.05, missing.rate=0.01)
          pruned <- unlist(snpset, use.names=FALSE)
          save(snpset,file="$(inputs.out_prefix)_$(inputs.chromosome)_snpset.RData")

          #PC-relate
          seqSetFilter(seqData, variant.id=pruned)
          iterator <- SeqVarBlockIterator(seqData, variantBlock=1024, verbose=TRUE)
          pcrel <- pcrelate(iterator, pcs=pcs$vectors[,1:2], training.set=pcs$unrels, sample.block.size=1000)
          save(pcrel,file="$(inputs.out_prefix)_$(inputs.chromosome)_pcrel.RData")

          #GRM
          print("Converting to GRM..")
          grm <- pcrelateToMatrix(pcrel, scaleKin=2)
          save(grm,file="$(inputs.out_prefix)_$(inputs.chromosome)_grm.RData")

          seqClose(gds)

          # mem stats
          ms <- gc()
          cat(">>> Max memory: ", ms[1,6]+ms[2,6], " MB\n")

  - class: ResourceRequirement
    coresMin: 5
    coresMax: 5
    ramMin: 3000 
    ramMax: 3000

inputs:
  pheno_file:
    type: File
    doc: AnnotatedDataFrame containing phenotype metadata.

  gds_file:
    type: File
    doc: GDS file for a single chromosome.

  pca_file:
    type: File
    doc: Population structure PCs in RData format.

  chromosome:
    type: string
    doc: The name of the chromosome you are currently processing.

  out_prefix:
    type: string
    doc: The prefix to use for all output file names.

outputs:
  grm_matrix:
    type: File
    doc: The GRM matrix saved as an R binary data object.
    outputBinding:
      glob: $(inputs.out_prefix)_$(inputs.chromosome)_grm.Rdata

  pruned_snpset:
    type: File
    doc: The pruned snpset as an RData object. 
    outputBinding:
      glob: $(inputs.out_prefix)_$(inputs.chromosome)_snpset.Rdata

baseCommand: [Rscript, generate_grm.R]
