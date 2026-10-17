#!/usr/bin/env bash

#SBATCH --time=04:00:00
#SBATCH --mem-per-cpu=1G
#SBATCH --cpus-per-task=4
#SBATCH --job-name=run_collectHsMetrics
#SBATCH --partition=pibu_el8
#SBATCH --output=/data/users/jli/cancergenomics/05_quality_calibration/bam_qc/collecthsmetrics/%j.o
#SBATCH --error=/data/users/jli/cancergenomics/05_quality_calibration/bam_qc/collecthsmetrics/%j.e

INPUTDIR="/data/users/jli/cancergenomics/01_raw_data/VAR_CALLING/alignments"
OUTPUTDIR="/data/users/jli/cancergenomics/05_quality_calibration/bam_qc/collecthsmetrics"
REFDIR="/data/users/jli/cancergenomics/01_raw_data/VAR_CALLING/reference"

# run the GATK CollectHsMetrics
for ID in normal tumor; do
apptainer exec --bind $INPUTDIR --bind $OUTPUTDIR --bind $REFDIR /containers/apptainer/gatk4_4.6.2.0_samtools_1.21.sif \
gatk CollectHsMetrics -I $INPUTDIR/${ID}.recal.bam -O $OUTPUTDIR/${ID}.recal.bam_hs_metrics.txt \
    -R $REFDIR/ref_genome.fa --BAIT_INTERVALS $REFDIR/exome_regions.bed.interval_list \
    --TARGET_INTERVALS $REFDIR/exome_regions.bed.interval_list
done


 


