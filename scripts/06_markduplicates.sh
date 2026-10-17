#!/usr/bin/env bash

#SBATCH --time=04:00:00
#SBATCH --mem-per-cpu=5G
#SBATCH --cpus-per-task=8
#SBATCH --job-name=run_gatk
#SBATCH --partition=pibu_el8
#SBATCH --output=/data/users/jli/cancergenomics/04_BAM_processing/mark_duplicates/%j.o
#SBATCH --error=/data/users/jli/cancergenomics/04_BAM_processing/mark_duplicates/%j.e

INPUTDIR="/data/users/jli/cancergenomics/03_alignment/bwa_mem2"
OUTDIR="/data/users/jli/cancergenomics/04_BAM_processing/mark_duplicates"

# mark the PCR duplicates
for ID in normal tumor; do
apptainer exec --bind $INPUTDIR --bind $OUTDIR  /containers/apptainer/gatk4_4.6.2.0_samtools_1.21.sif \
  gatk MarkDuplicates -I $INPUTDIR/${ID}_sorted.bam -O $OUTDIR/${ID}_marked.bam -M $OUTDIR/${ID}_metrics.txt
done

# Generate the BAM index file (.bai)
for ID in normal tumor; do
apptainer exec --bind $OUTDIR  /containers/apptainer/gatk4_4.6.2.0_samtools_1.21.sif \
  samtools index "$OUTDIR/${ID}_marked.bam"
done












