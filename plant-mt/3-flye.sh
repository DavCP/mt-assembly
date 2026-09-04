#!/bin/bash
#SBATCH --job-name=flye
#SBATCH --partition=ripley
#SBATCH --output=logs/%x_%j.out
#SBATCH --error=logs/%x_%j.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=20G
#SBATCH --time=20:00:00

# Definir el contenedor de GetOrganelle
CONTAINER="docker://quay.io/biocontainers/flye:2.9.6--py313h7fbb527_1"

# Definir directorios de salida
OUTDIR="results/plant_mt_out"
INPUT="data/raw"

mkdir -p $OUTDIR

# Loop para el ensamble de mitocondria animal
while read ID; do 
     apptainer exec $CONTAINER \
     flye --pacbio-raw ${INPUT}/${ID}.fastq.gz \
     --out-dir ${OUTDIR}/${ID} \
     --threads $SLURM_CPUS_PER_TASK
done < metadata/list.txt
