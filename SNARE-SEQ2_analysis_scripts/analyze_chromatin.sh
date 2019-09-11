raw_fastq_dir="/scratch/SNARE2_MiSeqRuns/CHROMATIN/Miseq_20190809_BICCN_20190730/raw_fastq/"
config="/scratch/SNARE2_MiSeqRuns/config"
pools="Ad1_N501-506"
samples="mBICCN_20190730A"

genome_mmi="/scratch/refdata-cellranger-marmoset-3.2/Callithrix_jacchus.ASM275486/fasta/genome.fa.mmi"
genome_csize="/scratch/refdata-cellranger-marmoset-3.2/Callithrix_jacchus.ASM275486/fasta/genome.fa.fai"
genome_name="calJac3"

mkdir by_samples_fastq

# demultiplex by sample fastq
for f in $pools
do

  demultiplex_SNARE2.py $raw_fastq_dir/${f}_R1_001.fastq.gz $raw_fastq_dir/${f}_R2_001.fastq.gz $raw_fastq_dir/${f}_R3_001.fastq.gz $f $config/R1_barcode_cfg $config/R1_barcode_list_SNARE2
  rm ${f}.Round1.idx.fastq

  rm by_samples_fastq/${sample}.${f}_R1.fastq
  rm by_samples_fastq/${sample}.${f}_R2.fastq
  rm by_samples_fastq/${sample}.${f}_R3.fastq
  for sample in $samples
  do

    for barcode in `cat $sample.list`
    do
       cat ${f}_deindexed_fastq/*_${barcode}_R1.fastq >> by_samples_fastq/${sample}.${f}_R1.fastq
       cat ${f}_deindexed_fastq/*_${barcode}_R2.fastq >> by_samples_fastq/${sample}.${f}_R2.fastq
       cat ${f}_deindexed_fastq/*_${barcode}_R3.fastq >> by_samples_fastq/${sample}.${f}_R3.fastq
    done
  done

  rm -r ${f}_deindexed_fastq
   
done


# merge fastq files, grab cell barcodes, and map
rm master_file_list

for sample in $samples
do

  for f in $pools
  do
    echo "${sample}.${f}.snap,${sample}.${f},by_samples_fastq,${sample}.${f}" >> master_file_list
  done

done

merge_and_map.pl $genome_mmi $genome_csize $genome_name < master_file_list &> merge_and_map.log

 
