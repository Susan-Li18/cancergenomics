#!/usr/bin/env bash

#SBATCH --time=03:00:00
#SBATCH --mem-per-cpu=1G
#SBATCH --cpus-per-task=4
#SBATCH --job-name=run_bqsr
#SBATCH --partition=pibu_el8
#SBATCH --output=/data/users/jli/cancergenomics/05_quality_calibration/bqsr/%j.o
#SBATCH --error=/data/users/jli/cancergenomics/05_quality_calibration/bqsr/%j.e

INPUTDIR="/data/users/jli/cancergenomics/04_BAM_processing/mark_duplicates"
OUTDIR="/data/users/jli/cancergenomics/05_quality_calibration/bqsr"
RAWDIR="/data/users/jli/cancergenomics/01_raw_data/VAR_CALLING"

# run BQSR
for ID in normal tumor; do
apptainer exec --bind $INPUTDIR --bind $OUTDIR --bind $RAWDIR  /containers/apptainer/gatk4_4.6.2.0_samtools_1.21.sif \
  gatk BaseRecalibrator -I $INPUTDIR/${ID}_marked.bam -R $RAWDIR/bwa_idx/genome.fa --known-sites $RAWDIR/known_indels/resources_broad_hg38_v0_Mills_and_1000G_gold_standard.indels.hg38.vcf.gz \
  --known-sites $RAWDIR/dbsnp/GCF_000001405.40_alias.vcf.gz -O $OUTDIR/${ID}_recal.table
done

