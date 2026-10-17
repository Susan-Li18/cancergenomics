#!/usr/bin/env bash

#SBATCH --time=00:30:00
#SBATCH --mem-per-cpu=1000M
#SBATCH --cpus-per-task=2
#SBATCH --job-name=run_fastp
#SBATCH --partition=pibu_el8
#SBATCH --output=/data/users/jli/cancergenomics/02_read_QC/fastp/%j.o
#SBATCH --error=/data/users/jli/cancergenomics/02_read_QC/fastp/%j.e

INPUTDIR="/data/users/jli/cancergenomics/01_raw_data/VAR_CALLING/fastq"
OUTPUTDIR="/data/users/jli/cancergenomics/02_read_QC/fastp"
mkdir -p $OUTPUTDIR
# run fastp for normal，according to the fastqc result, there is no obvious poor quality bases, 
# only GC content have a warning, so choose the default parameter of fastp
apptainer exec --bind $INPUTDIR --bind $OUTPUTDIR \
 /containers/apptainer/fastp_0.24.1.sif \
 fastp -i ${INPUTDIR}/normal.R1.fq.gz \
       -I ${INPUTDIR}/normal.R2.fq.gz \
       -o ${OUTPUTDIR}/normal.R1_clean.fq.gz \
       -O ${OUTPUTDIR}/normal.R2_clean.fq.gz \
       -h ${OUTPUTDIR}/normal.fastp.html \
       -j ${OUTPUTDIR}/normal.fastp.json \
       -w 2

# run fastp for tumor
apptainer exec --bind $INPUTDIR --bind $OUTPUTDIR \
 /containers/apptainer/fastp_0.24.1.sif \
 fastp -i ${INPUTDIR}/tumor.R1.fq.gz \
       -I ${INPUTDIR}/tumor.R2.fq.gz \
       -o ${OUTPUTDIR}/tumor.R1_clean.fq.gz \
       -O ${OUTPUTDIR}/tumor.R2_clean.fq.gz \
       -h ${OUTPUTDIR}/tumor.fastp.html \
       -j ${OUTPUTDIR}/tumor.fastp.json \
       -w 2