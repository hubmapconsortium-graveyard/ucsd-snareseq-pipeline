cwlVersion: v1.0
class: CommandLineTool
label: Concatenate dropEst .fastq.gz files
hints:
  DockerRequirement:
    # Can use almost any image; many contain 'zcat', but may as well
    # reduce the number of distinct images required for the pipeline
    dockerPull: mruffalo/dropest-grch38-genes:0.8.6
baseCommand: zcat

inputs:
  fastq_files:
    type: File[]
    inputBinding:
      position: 1
stdout: merged.fastq
outputs:
  merged_fastq:
    type: File
    outputBinding:
      glob: merged.fastq
