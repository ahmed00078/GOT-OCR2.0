#!/bin/bash
#SBATCH --job-name=got-ocr
#SBATCH --partition=gpu     # Remplacez par le nom de la partition GPU
#SBATCH --gres=gpu:1        # Demande 1 GPU
#SBATCH --time=1:00:00      # Limite de temps: 1 heure
#SBATCH --output=got-ocr-%j.out
#SBATCH --error=got-ocr-%j.err

# Charger les modules nécessaires (adaptez selon votre HPC)
module purge
module load singularity
module load cuda/11.7 # Adaptez à votre version

# Afficher les informations GPU
nvidia-smi

# Exécuter le conteneur
singularity run --nv got-ocr-simple.sif