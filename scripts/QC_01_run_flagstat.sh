#!/usr/bin/env bash

#SBATCH --time=04:00:00
#SBATCH --mem-per-cpu=1G
#SBATCH --cpus-per-task=4
#SBATCH --job-name=run_flagstat
#SBATCH --partition=pibu_el8
#SBATCH --output=/data/users/jli/cancergenomics/05_quality_calibration/bam_qc/flagstat/%j.o
#SBATCH --error=/data/users/jli/cancergenomics/05_quality_calibration/bam_qc/flagstat/%j.e

INPUTDIR="/data/users/jli/cancergenomics/01_raw_data/VAR_CALLING/alignments"


# run the samtools flagstat
for ID in normal tumor; do
apptainer exec --bind $INPUTDIR /containers/apptainer/gatk4_4.6.2.0_samtools_1.21.sif \
samtools flagstat -@ 4 $INPUTDIR/${ID}.recal.bam
done


 


