#!/usr/bin/env bash

#SBATCH --time=04:00:00
#SBATCH --mem-per-cpu=1G
#SBATCH --cpus-per-task=4
#SBATCH --job-name=run_mutect2
#SBATCH --partition=pibu_el8
#SBATCH --output=/data/users/jli/cancergenomics/06_variant_calling/variant_call/%j.o
#SBATCH --error=/data/users/jli/cancergenomics/06_variant_calling/variant_call/%j.e

INPUTDIR="/data/users/jli/cancergenomics/01_raw_data/VAR_CALLING/alignments"
OUTDIR="/data/users/jli/cancergenomics/06_variant_calling/variant_call"
REFDIR="/data/users/jli/cancergenomics/01_raw_data/VAR_CALLING"

# varient call
apptainer exec --bind $INPUTDIR --bind $OUTDIR --bind $REFDIR /containers/apptainer/gatk4_4.6.2.0_samtools_1.21.sif \
  gatk Mutect2 -R $REFDIR/reference/ref_genome.fa --intervals "$REFDIR/reference/exome_regions.bed.interval_list" \
  -I $INPUTDIR/normal.recal.bam -I $INPUTDIR/tumor.recal.bam \
  -normal normal \
  --germline-resource $REFDIR/resources/af-only-gnomad.hg38.subset.vcf.gz \
  --panel-of-normals $REFDIR/resources/1000g_pon.hg38.subset.vcf.gz \
  -O $OUTDIR/somatic.vcf.gz 


