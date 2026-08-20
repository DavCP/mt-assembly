#!/bin/bash
#SBATCH --job-name=mitos
#SBATCH --partition=ripley
#SBATCH --output=logs/%x_%j.out
#SBATCH --error=logs/%x_%j.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=20G
#SBATCH --time=20:00:00

# Definir el contenedor de GetOrganelle
CONTAINER="docker://quay.io/biocontainers/mitos:2.1.10--pyhdfd78af_0"

# Definir directorios de salida
OUTDIR="results/mitos_annot"
INPUT="results/animal_mt_out"

mkdir -p $OUTDIR

# Loop para el ensamble de mitocondria animal
while read ID; do 

mkdir -p ${OUTDIR}/${ID}

     apptainer exec $CONTAINER \
     runmitos -i ${INPUT}/${ID}/*.fasta \
            --code 2 \
            --outdir ${OUTDIR}/${ID}/ \
            --refdir metadata/MITOS/ \
            --refseqver refseq89m \
            --rrna 1 \
            --trna 0 \
            --intron 0 \
            --debug 
done < metadata/list.txt