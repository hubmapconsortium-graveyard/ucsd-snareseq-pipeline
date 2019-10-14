cwlVersion: v1.0
class: CommandLineTool
label: dropEst pipeline, v0.8.6
hints:
  DockerRequirement:
    dockerPull: mruffalo/dropest-grch38-genes:0.8.6
baseCommand: dropest

arguments:
  - "-w"
  - "-M"
  - "-u"
  - "-G"
  - "1"
  - "-L"
  - "iIeEBA"
  - "-m"
  - "-F"
  - "-g"
  - /opt/refdata-cellranger-GRCh38-3.0.0/genes/genes.gtf
  - "-c"
  - /opt/dropEst/configs/split_seq.xml
  - prefix: "-o"
    valueFrom: $(inputs.bam_file.nameroot)
inputs:
  bam_file:
    type: File
outputs:
  tsv_output:
    type: File[]
    outputBinding:
      glob: "*.tsv"
  rds_output:
    type: File
    outputBinding:
      glob: "*.rds"
  mtx_output:
    type: File
    outputBinding:
      glob: "*.mtx"
