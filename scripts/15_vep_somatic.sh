#!/usr/bin/env bash

#SBATCH --job-name=run_vep
#SBATCH --partition=pibu_el8
#SBATCH --time=01:00:00
#SBATCH --cpus-per-task=2
#SBATCH --mem=8G
#SBATCH --output=/data/users/jli/cancergenomics/07_annotation/%j.out
#SBATCH --error=/data/users/jli/cancergenomics/07_annotation/%j.err

set -euo pipefail

PROJECT_DIR="/data/users/jli/cancergenomics"
OUTPUTDIR="$PROJECT_DIR/07_annotation"
INPUTDIR="$PROJECT_DIR/06_variant_calling/clean_variants"
CACHEDIR="/data/users/jli/vep_cache"
clinvar="$PROJECT_DIR/01_raw_data/VAR_CALLING/resources/clinvar"

mkdir -p $OUTPUTDIR


apptainer exec --bind $OUTPUTDIR --bind $INPUTDIR --bind $CACHEDIR --bind $clinvar /data/users/jli/container/ensembl-vep_116.sif \
vep -i $INPUTDIR/somatic.filtered.PASS.vcf.gz \
	--cache \
    --dir_cache /data/users/jli/vep_cache \
	--species homo_sapiens \
	--offline \
	--force_overwrite \
	--assembly GRCh38 \
	--format vcf \
	--fork 2 \
	--sift b \
    --polyphen b \
    --symbol \
    --variant_class \
    --biotype \
	--custom "$clinvar/clinvar.vcf.gz,ClinVar,vcf,exact,0,CLNSIG,CLNREVSTAT,CLNDN" \
	--output_file $OUTPUTDIR/chr6ch17_mutect2_annotated_with_clinVar.txt

# filter result
apptainer exec --bind $OUTPUTDIR --bind $INPUTDIR --bind $CACHEDIR --bind $clinvar /data/users/jli/container/ensembl-vep_116.sif \
filter_vep \
    -i $OUTPUTDIR/chr6ch17_mutect2_annotated_with_clinVar.txt \
    -o $OUTPUTDIR/chr6ch17_mutect2_annotated_with_clinVar_filtered.txt \
    --force_overwrite \
    --filter "(IMPACT is HIGH or IMPACT is MODERATE) or \
    (SIFT match deleterious or PolyPhen match probably_damaging) or \
    (ClinVar_CLNSIG match pathogenic)"

# Generate summary
echo "Mutation Type Summary:" > $OUTPUTDIR/summary.txt
grep -v "#" $OUTPUTDIR/chr6ch17_mutect2_annotated_with_clinVar_filtered.txt | cut -f7 | sort | uniq -c >> $OUTPUTDIR/summary.txt

    