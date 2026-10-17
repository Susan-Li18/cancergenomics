#!/usr/bin/env bash

#SBATCH --job-name=run_vep
#SBATCH --partition=pibu_el8
#SBATCH --time=03:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=16G
#SBATCH --output=/data/users/jli/cancergenomics/07_annotation/%j.out
#SBATCH --error=/data/users/jli/cancergenomics/07_annotation/%j.err

set -euo pipefail

PROJECT_DIR="/data/users/jli/cancergenomics"
OUTPUTDIR="$PROJECT_DIR/07_annotation"
INPUTDIR="$OUTPUTDIR/input"
CACHEDIR="/data/users/jli/vep_cache"

mkdir -p $OUTPUTDIR


apptainer exec --bind $OUTPUTDIR --bind $INPUTDIR --bind $CACHEDIR /data/users/jli/container/ensembl-vep_116.sif \
vep -i $INPUTDIR/cancer_variants.vcf \
	--cache \
    --dir_cache /data/users/jli/vep_cache \
	--species homo_sapiens \
	--offline \
	--force_overwrite \
	--assembly GRCh38 \
	--format vcf \
	--symbol \
	--sift b \
	--polyphen b \
	--pick \
	--domains \
	--output_file $OUTPUTDIR/cancer_variants.txt