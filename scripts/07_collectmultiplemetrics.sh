#!/usr/bin/env bash

#SBATCH --time=02:00:00
#SBATCH --mem-per-cpu=1G
#SBATCH --cpus-per-task=4
#SBATCH --job-name=run_gatk
#SBATCH --partition=pibu_el8
#SBATCH --output=/data/users/jli/cancergenomics/04_BAM_processing/multiple_metrics/%j.o
#SBATCH --error=/data/users/jli/cancergenomics/04_BAM_processing/multiple_metrics/%j.e

INPUTDIR="/data/users/jli/cancergenomics/04_BAM_processing/mark_duplicates"
OUTDIR="/data/users/jli/cancergenomics/04_BAM_processing/multiple_metrics"
QCDIR="/data/users/jli/cancergenomics/02_read_QC"
REFDIR="/data/users/jli/cancergenomics/01_raw_data/VAR_CALLING/bwa_idx"
# download the container（previous container do not have R, so change the container)
export APPTAINER_TMPDIR="/data/users/jli/cancergenomics/.apptainer-tmp"
mkdir -p "$APPTAINER_TMPDIR"
apptainer pull "/data/users/jli/container/gatk_4.6.2.0.sif" docker://broadinstitute/gatk:4.6.2.0

# collect BAM metrics 
for ID in normal tumor; do
apptainer exec --bind $INPUTDIR --bind $OUTDIR --bind $REFDIR  /data/users/jli/container/gatk_4.6.2.0.sif \
  gatk CollectMultipleMetrics -I $INPUTDIR/${ID}_marked.bam -O $OUTDIR/${ID} -R $REFDIR/genome.fa
done

# update the multiQC
apptainer exec --bind $OUTDIR --bind $QCDIR /containers/apptainer/multiqc-1.19.sif multiqc $OUTDIR $QCDIR -o $OUTDIR -f













