#!/usr/bin/env bash

#SBATCH --time=04:00:00
#SBATCH --mem-per-cpu=1G
#SBATCH --cpus-per-task=8
#SBATCH --job-name=run_samtool
#SBATCH --partition=pibu_el8
#SBATCH --output=/data/users/jli/cancergenomics/03_alignment/sort%j.o
#SBATCH --error=/data/users/jli/cancergenomics/03_alignment/sort%j.e

INPUTDIR="/data/users/jli/cancergenomics/03_alignment/bwa_mem2"
OUTDIR="/data/users/jli/cancergenomics/03_alignment/bwa_mem2"

# coordinate sort the alignment output 
for ID in normal tumor; do
apptainer exec --bind $OUTDIR  /containers/apptainer/gatk4_4.6.2.0_samtools_1.21.sif \
  samtools sort -@ 8 "$INPUTDIR/${ID}_aligned.bam" -o "$OUTDIR/${ID}_sorted.bam"
done

# Generate the BAM index file (.bai)
for ID in normal tumor; do
apptainer exec --bind $OUTDIR  /containers/apptainer/samtools-1.19.sif \
  samtools index "$OUTDIR/${ID}_sorted.bam"
done