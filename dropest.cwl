#!/usr/bin/env cwl-runner

class: Workflow
cwlVersion: v1.0
requirements:
  StepInputExpressionRequirement: {}
label: dropEst pipeline
inputs:
  fastq_r1:
    label: "R1 FASTQ file"
    type: File
  fastq_r2:
    label: "FASTQ file 2"
    type: File
  threads:
    label: "Number of threads for STAR aligner"
    type: int
    default: 1
outputs:
  bam_file:
    outputSource: star/bam_file
    type: File
    label: "Aligned reads"
  tsv_output:
    outputSource: dropest/tsv_output
    type: File[]
    label: "Gene/cell metadata"
  rds_output:
    outputSource: dropest/rds_output
    type: File
    label: "Output in RDS format"
  mtx_output:
    outputSource: dropest/mtx_output
    type: File
    label: "Count matrix in .mtx format"
steps:
  - id: droptag
    in:
      - id: fastq_r1
        source: fastq_r1
      - id: fastq_r2
        source: fastq_r2
      - id: threads
        source: threads
    out:
      - droptag_output
    run: steps/droptag.cwl
    label: "droptag 0.8.6"
  - id: concat_fastq_gz
    in:
      - id: fastq_files
        source: droptag/droptag_output
    out:
      - merged_fastq
    run: steps/concat-fastq-gz.cwl
    label: "Decompress and concatenate FASTQ files"
  - id: star
    in:
      - id: threads
        source: threads
      - id: fastq_file
        source: concat_fastq_gz/merged_fastq
    out:
      - bam_file
    run: steps/star.cwl
    label: Additional filtering and normalization
  - id: dropest
    in:
      - id: bam_file
        source: star/bam_file
    out:
      - tsv_output
      - rds_output
      - mtx_output
    run: steps/dropest.cwl
    label: "dropest 0.8.6"
