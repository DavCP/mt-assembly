#!/bin/bash
#SBATCH --job-name=fasterq-dump
#SBATCH --partition=ripley
#SBATCH --output=logs/%x_%j.out
#SBATCH --error=logs/%x_%j.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=2G
#SBATCH --time=01:00:00

#Ve al directorio desde que se lanzó el script
cd $SLURM_SUBMIT_DIR

# Definir variable
CONTAINER="docker://ncbi/sra-tools:3.4.1"

OUTDIR="data/raw"

# Crear directior de datos de salida
mkdir -p $OUTDIR

# Ejecutar un loop while
while read ID; do
   apptainer exec $CONTAINER \
   fasterq-dump \
   --split-files $ID \
   --outdir $OUTDIR \
   --threads $SLURM_CPUS_PER_TASK
done < metadata/list.txt 

# Comprimir los datos 
pigz -p $SLURM_CPUS_PER_TASK \
${OUTDIR}/*.fastq