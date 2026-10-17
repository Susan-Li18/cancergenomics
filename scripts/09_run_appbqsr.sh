#!/usr/bin/env bash

#SBATCH --time=01:00:00
#SBATCH --mem-per-cpu=1G
#SBATCH --cpus-per-task=4
#SBATCH --job-name=run_applybqsr
#SBATCH --partition=pibu_el8
#SBATCH --output=/data/users/jli/cancergenomics/05_quality_calibration/applybqsr/%j.o
#SBATCH --error=/data/users/jli/cancergenomics/05_quality_calibration/applybqsr/%j.e

INPUTDIR="/data/users/jli/cancergenomics/04_BAM_processing/mark_duplicates"
OUTDIR="/data/users/jli/cancergenomics/05_quality_calibration/applybqsr"
RAWDIR="/data/users/jli/cancergenomics/01_raw_data/VAR_CALLING"
TABLE="/data/users/jli/cancergenomics/05_quality_calibration/bqsr"
# apply the bqsr tabel
for ID in normal tumor; do
apptainer exec --bind $INPUTDIR --bind $OUTDIR --bind $RAWDIR --bind $TABLE  /containers/apptainer/gatk4_4.6.2.0_samtools_1.21.sif \
  gatk ApplyBQSR -I $INPUTDIR/${ID}_marked.bam -R $RAWDIR/bwa_idx/genome.fa -O $OUTDIR/${ID}_recal.bam --bqsr-recal-file $TABLE/${ID}_recal.table
done

