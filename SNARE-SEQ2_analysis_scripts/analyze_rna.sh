
pools="SPLiT_N708_S8
SPLiT_N709_S9
SPLiT_N710_S10
SPLiT_N711_S11
SPLiT_N716_S16
SPLiT_N717_S17"

samples="mBICCN_20190730A"

config="/scratch/SNARE2_MiSeqRuns/config"
raw_fastq="/scratch/SNARE2_MiSeqRuns/RNA/Miseq_20190807_BICCN_20190730_CTRI_LAPMAP_20190731/raw_fastq"
star_index="/scratch/refdata-cellranger-marmoset-3.2/Callithrix_jacchus.ASM275486/star/"
gtf_file="/scratch/refdata-cellranger-marmoset-3.2/Callithrix_jacchus.ASM275486/genes/genes.gtf"

mkdir by_samples_fastq

for f in $pools
do

   demultiplex_split-seq.py $raw_fastq/${f}_R1_001.fastq.gz $raw_fastq/${f}_R2_001.fastq.gz $f $config/R1_barcode_cfg $config/R1_barcode_list_split-seq
   rm ${f}.Round1.idx.fastq

   for sample in $samples
   do
     rm by_samples_fastq/${sample}.${f}_R1.fastq
     rm by_samples_fastq/${sample}.${f}_R2.fastq

     for barcode in `cat $sample.list`
     do
        cat ${f}_deindexed_fastq/*_${barcode}_R1.fastq >> by_samples_fastq/${sample}.${f}_R1.fastq
        cat ${f}_deindexed_fastq/*_${barcode}_R2.fastq >> by_samples_fastq/${sample}.${f}_R2.fastq

     done

     dropEst_SeqToRDS.sh by_samples_fastq/${sample}.${f}_R1.fastq by_samples_fastq/${sample}.${f}_R2.fastq $star_index $gtf_file ${sample}.${f}

   done

   rm -r ${f}_deindexed_fastq

done


