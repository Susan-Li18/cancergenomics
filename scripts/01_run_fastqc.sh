#!/usr/bin/env bash

#SBATCH --time=00:30:00
#SBATCH --mem-per-cpu=1000M
#SBATCH --cpus-per-task=4
#SBATCH --job-name=fastqc
#SBATCH --partition=pibu_el8
#SBATCH --output=/data/users/jli/cancergenomics/read_QC/fastqc/output_fastqc_%j.o
#SBATCH --error=/data/users/jli/cancergenomics/read_QC/fastqc/error_fastqc_%j.e

INPUTDIR="/data/users/jli/cancergenomics/raw_data/VAR_CALLING/fastq"
OUTDIR="/data/users/jli/cancergenomics/read_QC/fastqc"

mkdir -p $OUTDIR
# run fastqc for normal
apptainer exec --bind $INPUTDIR --bind $OUTDIR /containers/apptainer/fastqc-0.12.1.sif \
fastqc -t 4 -o $OUTDIR $INPUTDIR/normal.R1.fq.gz $INPUTDIR/normal.R2.fq.gz

# run fastqc for tumor
apptainer exec --bind $INPUTDIR --bind $OUTDIR /containers/apptainer/fastqc-0.12.1.sif \
fastqc -t 4 -o $OUTDIR $INPUTDIR/tumor.R1.fq.gz $INPUTDIR/tumor.R2.fq.gz

