dropest_dir="$HOME/dropEst/build"
config_file="$HOME/dropEst/configs/split_seq.xml"
star_dir="$HOME/STAR-2.5.2b/bin/Linux_x86_64"

#star_index="/scratch/refdata-cellranger-GRCh38-3.0.0/star/"
#gtf_file="/scratch/refdata-cellranger-GRCh38-3.0.0/genes/genes.gtf"

file_r1=$1
file_r2=$2
star_index=$3
gtf_file=$4
file_id=$5

mkdir 01_dropTag_1_${file_id}
mkdir 02_alignment_${file_id}
mkdir 03_dropEst_${file_id}

cd 01_dropTag_1_${file_id}
$dropest_dir/droptag -c $config_file $file_r2 $file_r1

cd ../02_alignment_${file_id}
zcat ../01_dropTag_*_${file_id}/${file_id}*tagged.*.fastq.gz > ${file_id}.tagged.merged.fastq
$star_dir/STAR --genomeDir $star_index --readFilesCommand cat --outSAMtype BAM Unsorted --readFilesIn ${file_id}.tagged.merged.fastq --outFileNamePrefix ${file_id}.
rm ${file_id}.tagged.merged.fastq

mv ${file_id}.Aligned.out.bam ${file_id}.out.bam

cd ../03_dropEst_${file_id}
$dropest_dir/dropest -w -M -u -G 1 -L iIeEBA -u -m -F -g $gtf_file -c $config_file -o ${file_id} ../02_alignment_${file_id}/${file_id}.out.bam

