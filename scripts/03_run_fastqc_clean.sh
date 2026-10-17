#!/usr/bin/env bash

#SBATCH --time=00:30:00
#SBATCH --mem-per-cpu=1000M
#SBATCH --cpus-per-task=4
#SBATCH --job-name=run_fastqc
#SBATCH --partition=pibu_el8
#SBATCH --output=/data/users/jli/cancergenomics/02_read_QC/fastqc_clean/%j.o
#SBATCH --error=/data/users/jli/cancergenomics/02_read_QC/fastqc_clean/%j.e

INPUTDIR="/data/users/jli/cancergenomics/02_read_QC/fastp"
OUTDIR="/data/users/jli/cancergenomics/02_read_QC/fastqc_clean"
mkdir -p $OUTDIR
# run fastqc for normal
apptainer exec --bind $INPUTDIR --bind $OUTDIR /containers/apptainer/fastqc-0.12.1.sif \
fastqc -t 4 -o $OUTDIR $INPUTDIR/normal.R1_clean.fq.gz $INPUTDIR/normal.R2_clean.fq.gz

# run fastqc for tumor
apptainer exec --bind $INPUTDIR --bind $OUTDIR /containers/apptainer/fastqc-0.12.1.sif \
fastqc -t 4 -o $OUTDIR $INPUTDIR/tumor.R1_clean.fq.gz $INPUTDIR/tumor.R2_clean.fq.gz
# run multiqc for all results
apptainer exec --bind $OUTDIR /containers/apptainer/multiqc-1.19.sif multiqc $OUTDIR -o $OUTDIR