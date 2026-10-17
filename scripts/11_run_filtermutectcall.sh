#!/usr/bin/env bash

#SBATCH --time=04:00:00
#SBATCH --mem-per-cpu=1G
#SBATCH --cpus-per-task=4
#SBATCH --job-name=run_mutect2
#SBATCH --partition=pibu_el8
#SBATCH --output=/data/users/jli/cancergenomics/06_variant_calling/variant_call/%j.o
#SBATCH --error=/data/users/jli/cancergenomics/06_variant_calling/variant_call/%j.e

INPUTDIR="/data/users/jli/cancergenomics/06_variant_calling/variant_call"
OUTDIR="/data/users/jli/cancergenomics/06_variant_calling/variant_call"
REFDIR="/data/users/jli/cancergenomics/01_raw_data/VAR_CALLING/reference"

# filter the variant callings
apptainer exec --bind $INPUTDIR --bind $OUTDIR --bind $REFDIR /containers/apptainer/gatk4_4.6.2.0_samtools_1.21.sif \
  gatk FilterMutectCalls -R $REFDIR/ref_genome.fa \
  -V $INPUTDIR/somatic.vcf.gz \
  -O $OUTDIR/somatic.filtered.vcf.gz
 


