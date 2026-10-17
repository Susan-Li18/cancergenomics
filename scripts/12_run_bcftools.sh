#!/usr/bin/env bash

#SBATCH --time=04:00:00
#SBATCH --mem-per-cpu=1G
#SBATCH --cpus-per-task=4
#SBATCH --job-name=run_mutect2
#SBATCH --partition=pibu_el8
#SBATCH --output=/data/users/jli/cancergenomics/06_variant_calling/clean_variants/%j.o
#SBATCH --error=/data/users/jli/cancergenomics/06_variant_calling/clean_variants/%j.e

INPUTDIR="/data/users/jli/cancergenomics/06_variant_calling/variant_call"
OUTDIR="/data/users/jli/cancergenomics/06_variant_calling/clean_variants"
REFDIR="/data/users/jli/cancergenomics/01_raw_data/VAR_CALLING/reference"

# create the vcf with the variants passing filter
apptainer exec --bind $INPUTDIR --bind $OUTDIR --bind $REFDIR /containers/apptainer/bcftools:1.21--h8b25389_0 \
  bcftools view \
  -f PASS $INPUTDIR/somatic.filtered.vcf.gz \
  -Oz -o $OUTDIR/somatic.filtered.PASS.vcf.gz

# 
apptainer exec --bind $INPUTDIR --bind $OUTDIR --bind $REFDIR /containers/apptainer/bcftools:1.21--h8b25389_0 \
  bcftools index \
  --tbi $OUTDIR/somatic.filtered.PASS.vcf.gz
 


