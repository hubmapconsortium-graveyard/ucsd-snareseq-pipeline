cwlVersion: v1.0
class: CommandLineTool
label: droptag
hints:
  DockerRequirement:
    dockerPull: mruffalo/dropest-grch38-genes:0.8.6
baseCommand: droptag

arguments:
  - "-c"
  - /opt/dropEst/configs/split_seq.xml
inputs:
  file_r2:
    type: File
    inputBinding:
      position: 0
  file_r1:
    type: File
    inputBinding:
      position: 1
outputs:
  droptag_output:
    type: File[]
    outputBinding:
      glob: '*.tagged.*.fastq.gz'
