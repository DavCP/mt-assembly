#!/bin/bash
#SBATCH --job-name=fastp
#SBATCH --partition=ripley
#SBATCH --output=logs/%x_%j.out
#SBATCH --error=logs/%x_%j.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=10G
#SBATCH --time=01:00:00

# Definir variable
CONTAINER="docker://quay.io/biocontainers/fastp:1.3.6--h43da1c4_0"

INPUT="data/raw"
OUTDIR="data/trim-reads"
REPORT="results/fastp"

# Crear directior de datos de salida
mkdir -p $OUTDIR
mkdir -p $REPORT

# Ejecutar un loop while
while read ID; do
   apptainer exec $CONTAINER \
   fastp \
   -i ${INPUT}/${ID}_1.fastq.gz -I ${INPUT}/${ID}_2.fastq.gz \
   -o ${OUTDIR}/trim-${ID}_1.fastq.gz -O ${OUTDIR}/trim-${ID}_2.fastq.gz \
   --html=${REPORT}/${ID}-fastp.html \
   --json=${REPORT}/${ID}-fastp.json \
   --qualified_quality_phred=20 \
   --thread=${SLURM_CPUS_PER_TASK}
done < metadata/list.txt
