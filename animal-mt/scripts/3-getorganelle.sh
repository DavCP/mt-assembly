#!/bin/bash
#SBATCH --job-name=getorg
#SBATCH --partition=ripley
#SBATCH --output=logs/%x_%j.out
#SBATCH --error=logs/%x_%j.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=20G
#SBATCH --time=20:00:00

# Definir el contenedor de GetOrganelle
CONTAINER="docker://quay.io/biocontainers/getorganelle:1.7.7.1--pyhdfd78af_0"

# Definir directorios de salida
OUTDIR="results/animal_mt_out"
INPUT="data/trim-reads"

mkdir -p $OUTDIR

# Cargar la base de datos para el genoma o genomas objetivo

apptainer exec $CONATINER \
     get_organelle_config.py --add animal_mt


# Loop para el ensamble de mitocondria animal
while read ID; do 
     apptainer exec $CONTAINER \
     get_organelle_from_reads.py \
     -1 ${INPUT}/trim-${ID}_1.fastq.gz -2 ${INPUT}/trim-${ID}_2.fastq.gz \
     -R 10 -k 21,45,65,85,105 \
     -F animal_mt \
     -o $OUTDIR/$ID \
     -t $SLURM_CPUS_PER_TASK
done < metadata/list.txt
