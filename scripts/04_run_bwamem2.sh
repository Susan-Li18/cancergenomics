#!/usr/bin/env bash

#SBATCH --time=04:00:00
#SBATCH --mem-per-cpu=5G
#SBATCH --cpus-per-task=20
#SBATCH --job-name=run_bwa_mem2
#SBATCH --partition=pibu_el8
#SBATCH --output=/data/users/jli/cancergenomics/03_alignment/bwa_mem2%j.o
#SBATCH --error=/data/users/jli/cancergenomics/03_alignment/bwa_mem2%j.e

INPUTDIR="/data/users/jli/cancergenomics/02_read_QC/fastp"
INDEX="/data/users/jli/cancergenomics/01_raw_data/VAR_CALLING/bwa_idx"
OUTDIR="/data/users/jli/cancergenomics/03_alignment/bwa_mem2"
PLATFORM=ILLUMINA


mkdir -p $OUTDIR
# download the container from the galaxy websit to my local direction 
for ID in normal tumor; do
singularity exec \
  --bind $INPUTDIR --bind $INDEX --bind $OUTDIR \
  /data/users/jli/container/bwa-mem2-2.2.1--he513fc3_0.img \
  bwa-mem2 mem -t 16 \
  -R "@RG\tID:$ID\tSM:$ID\tPL:$PLATFORM" \
  $INDEX/genome.fa  \
  $INPUTDIR/${ID}.R1_clean.fq.gz $INPUTDIR/${ID}.R2_clean.fq.gz | \
apptainer exec --bind $OUTDIR /containers/apptainer/gatk4_4.6.2.0_samtools_1.21.sif \
  samtools view -b -@ 4 -o "$OUTDIR/${ID}_aligned.bam" -
done