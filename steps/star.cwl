cwlVersion: v1.0
class: CommandLineTool
label: STAR aligner, 2.6.1e with GRCh38 index
hints:
  DockerRequirement:
    dockerPull: mruffalo/star-grch38:2.6.1e
baseCommand: STAR

arguments:
  - "--genomeDir"
  - /opt/refdata-cellranger-GRCh38-3.0.0/star
  - "--readFilesCommand"
  - cat
  - "--outSAMtype"
  - BAM
  - Unsorted
inputs:
  threads:
    type: int
    default: 1
    inputBinding:
      prefix: "--runThreadN"
  fastq_file:
    type: File
    inputBinding:
      prefix: "--readFilesIn"
  out_filename_prefix:
    type: string
    inputBinding:
      prefix: "--outFileNamePrefix"
outputs:
  bam_file:
    type: File
    outputBinding:
      glob: '*.Aligned.out.bam'
