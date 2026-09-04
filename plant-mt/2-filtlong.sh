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
CONTAINER="docker://quay.io/biocontainers/filtlong:0.3.1--h077b44d_0"

# Definir directorios de salida
OUTDIR="data/filtered"
INPUT="data/raw"

mkdir -p $OUTDIR

# Loop para el ensamble de mitocondria animal
while read ID; do 
    apptainer exec $CONTAINER \
    filtlong --min_length 1000 \
    --keep_percent 90 \
    --target_bases 500000000 ${INPUT}/${ID}*.fastq.gz \
    | gzip > ${OUTDIR}/${ID}*.fastq.gz
done < metadata/list.txt
