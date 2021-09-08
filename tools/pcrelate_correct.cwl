cwlVersion: v1.0
class: CommandLineTool
id: pcrelate_correct
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: uwgac/topmed-master:2.10.0
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entryname: pcrelate_correct.R
        entry: |-
          library(TopmedPipeline)
          library(SeqVarTools)
          library(GENESIS)

          nsampblock <- $(inputs.n_sample_blocks)
          pcrelate_prefix <- "$(inputs.pcrelate_block_files[0].nameroot.split('_block_')[0])"

          kinSelf <- NULL
          kinBtwn <- NULL
          kin.thresh <- $(inputs.sparse_threshold)
          
          ### correct IBD results and combine
          # i know the order seems weird, but this should make sure all the correct data is loaded when needed
          for (i in nsampblock:1){
              for (j in i:nsampblock){
                  message('Sample Blocks ', i, ' and ', j)
                  
                  ## load the data
                  res <- getobj(paste0(pcrelate_prefix, "_block_", i, "_", j, ".RData"))

                  if(i == j) kinSelf <- rbind(kinSelf, res$kinSelf)

                  # correct the IBD estimates
                  res$kinBtwn <- correctK2(kinBtwn = res$kinBtwn, 
                                           kinSelf = kinSelf, 
                                           small.samp.correct = FALSE, 
                                           pcs = NULL, 
                                           sample.include = NULL)

                  res$kinBtwn <- correctK0(kinBtwn = res$kinBtwn)
                  
                  # this should replace the original results, but i probably wouldn't overwrite them yet
                  #save(res, file=paste0("$(inputs.out_prefix)", "_", "$(inputs.chromosome)", "_block_", i, "_", j, "_corrected.RData"))
          
                  # save results above threshold in combined file
                  kinBtwn <- rbind(kinBtwn, res$kinBtwn[kin > kin.thresh])

                  rm(res); gc()
              }
          }
          
          # save pcrelate object
          pcrelobj <- list(kinSelf = kinSelf, kinBtwn = kinBtwn)
          class(pcrelobj) <- "pcrelate"
          save(pcrelobj, file="$(inputs.out_prefix)_$(inputs.chromosome)_pcrelate.RData")

          rm(kinBtwn, kinSelf); gc()

          # save sparse kinship matrix
          km <- pcrelateToMatrix(pcrelobj, thresh = 2*kin.thresh, scaleKin = 2)
          save(km, file="$(inputs.out_prefix)_$(inputs.chromosome)_pcrelate_Matrix.RData")
          
          # mem stats
          ms <- gc()
          cat(">>> Max memory: ", ms[1,6]+ms[2,6], " MB\\n")

  - class: ResourceRequirement
    coresMin: 4
    coresMax: 4
    ramMin: 3000
    ramMax: 3000

inputs:
  pcrelate_block_files: 
    type: File[]
    doc: PC Relate files for all sample blocks. 

  chromosome:
    type: string
    doc: The name of the chromosome you are currently processing.

  out_prefix:
    type: string
    doc: The prefix to use for all output file names.

  n_sample_blocks:
    type: int
    default: 1

  sparse_threshold:
    type: float
    default: 0.02209709
    doc: Threshold for making sparse kingship matrix.

outputs:
  pcrelate_corrected_out:
    type: File
    doc: RData file with corrected PC-Relate results for each sample block.
    outputBinding:
      glob: "*_pcrelate.RData"

  pcrelate_matrix:
    type: File
    doc: Block diagonal sparse matrix of pairwise kinship estimates. 
    outputBinding:
      glob: "*_pcrelate_Matrix.RData"

baseCommand: []
arguments:
- prefix: ''
  position: 0
  valueFrom: |-
    ${
        var cmd_line = ""
        
        for (var i=0; i<inputs.pcrelate_block_files.length; i++)
            cmd_line += "ln -s " + inputs.pcrelate_block_files[i].path + " " + inputs.pcrelate_block_files[i].basename + " && "
        return cmd_line
    }
  shellQuote: false
- prefix: ''
  position: 1
  valueFrom: Rscript
  shellQuote: false
- prefix: '' 
  position: 2
  valueFrom: pcrelate_correct.R
  shellQuote: false
