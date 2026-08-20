#!/bin/bash
#SBATCH --job-name=mitos_ref
#SBATCH --partition=ripley
#SBATCH --output=logs/%x_%j.out
#SBATCH --error=logs/%x_%j.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=2G
#SBATCH --time=10:00:00

# Definir directorios de salida y link de descarga

OUTDIR="metadata/MITOS"

mkdir -p $OUTDIR


# Descargar la referencia

cd $OUTDIR

wget -O refseq89m.tar.bz2 'https://zenodo.org/records/4284483/files/refseq89m.tar.bz2?download=1'

# Descomprimir y eliminar archivo comprimido

tar -xjf *.tar.bz2 && rm *.tar.bz2

