#!/usr/bin/env bash

#SBATCH --job-name=download_vep
#SBATCH --partition=pibu_el8
#SBATCH --time=04:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH --output=/data/users/jli/cancergenomics/vep_download_%j.out
#SBATCH --error=/data/users/jli/cancergenomics/vep_download_%j.err

set -euo pipefail

DATA_DIR="/data/users/jli"
CONTAINERDIR="$DATA_DIR/container"
IMAGE="$CONTAINERDIR/ensembl-vep_116.sif"
CACHE_DIR="$DATA_DIR/vep_cache"
ARCHIVE="$CACHE_DIR/homo_sapiens_vep_116_GRCh38.tar.gz"
CACHE_PATH="$CACHE_DIR/homo_sapiens/116_GRCh38"
DONE="$CACHE_PATH/.extraction_complete"

mkdir -p "$CONTAINERDIR" "$CACHE_DIR"


export APPTAINER_CACHEDIR="$CONTAINERDIR/.apptainer_cache"
export APPTAINER_TMPDIR="$CONTAINERDIR/tmp"

mkdir -p "$APPTAINER_CACHEDIR" "$APPTAINER_TMPDIR"

# if exist image, do not repeat download

if [ ! -f "$IMAGE" ]; then
    apptainer pull \
        "$IMAGE" \
        docker://ensemblorg/ensembl-vep:release_116.0
else
    echo "VEP container already exists: $IMAGE"
fi

# check VEP install successful
apptainer exec \
    "$IMAGE" \
    vep --help

# download cache 
if [ -f "$DONE" ]; then
    echo "Cache already prepared: $CACHE_PATH"
else
    if [ ! -f "$ARCHIVE" ]; then
        curl -fL --retry 3 -C - \
            -o "$ARCHIVE.part" \
            https://ftp.ensembl.org/pub/release-116/variation/indexed_vep_cache/homo_sapiens_vep_116_GRCh38.tar.gz

        
        mv "$ARCHIVE.part" "$ARCHIVE"
    fi

    tar -xzf "$ARCHIVE" -C "$CACHE_DIR"
    test -d "$CACHE_PATH"
    touch "$DONE"
    echo "Cache preparation completed: $CACHE_PATH"
fi

echo "VEP container and cache preparation completed."
