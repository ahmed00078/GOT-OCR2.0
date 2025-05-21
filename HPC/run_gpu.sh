#!/bin/bash
#SBATCH --job-name=got-ocr-gpu
#SBATCH --output=got-ocr-gpu-%j.out
#SBATCH --error=got-ocr-gpu-%j.err
#SBATCH --time=12:00:00
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G

# Charger l'environnement
source ../venv/bin/activate

# Définir les variables d'environnement pour optimiser l'utilisation GPU
export PYTORCH_CUDA_ALLOC_CONF=max_split_size_mb:128
export CUDA_VISIBLE_DEVICES=0

# Afficher les informations GPU
echo "============= INFORMATIONS GPU ============="
nvidia-smi
echo "CUDA disponible: $(python -c 'import torch; print(torch.cuda.is_available())')"
echo "Nombre de GPUs: $(python -c 'import torch; print(torch.cuda.device_count())')"
if [ $(python -c 'import torch; print(torch.cuda.is_available())') == "True" ]; then
  echo "Nom du GPU: $(python -c 'import torch; print(torch.cuda.get_device_name(0))')"
fi

# Se déplacer dans le répertoire du projet
cd /data/asidimoh/GOT2/GOT-OCR2.0

# Créer le dossier static s'il n'existe pas
mkdir -p static

# Afficher les informations de connexion
echo "Service accessible sur: http://$HOSTNAME:8000/frontend/index.html"
echo "Pour y accéder: ssh -L 8000:$HOSTNAME:8000 asidimoh@10.11.8.2"

# Démarrer l'application avec un timeout plus long
uvicorn main:app --host 0.0.0.0 --port 8000 --timeout-keep-alive 300 --log-level debug