#!/usr/bin/env bash

#SBATCH --job-name=vep_visualization
#SBATCH --partition=pibu_el8
#SBATCH --time=00:30:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=8G
#SBATCH --output=/data/users/jli/cancergenomics/07_annotation/R_%j.out
#SBATCH --error=/data/users/jli/cancergenomics/07_annotation/R_%j.err

set -euo pipefail

PROJECT_DIR="/data/users/jli/cancergenomics"
cd "$PROJECT_DIR"

# Initialize environment modules if they are unavailable in the batch shell.
if ! type module >/dev/null 2>&1; then
    source /etc/profile.d/modules.sh
fi
module load R/4.2.1-foss-2021a

export OMP_NUM_THREADS="$SLURM_CPUS_PER_TASK"
export OPENBLAS_NUM_THREADS="$SLURM_CPUS_PER_TASK"
export MKL_NUM_THREADS="$SLURM_CPUS_PER_TASK"

Rscript "$PROJECT_DIR/scripts/16_visulization.R"
