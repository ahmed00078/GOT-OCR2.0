cd /data/asidimoh/GOT2/
source venv/bin/activate
cd GOT-OCR2.0
sbatch run_gpu.sh
cat got-ocr-gpu-883.out  
cat got-ocr-gpu-883.err 

# nouveau terminale
ssh -L 8000:hpc-vaader-php-cln01:8000 asidimoh@10.11.8.2



scancel 890
squeue -u $USER




# Singularity

nano got-ocr-simple.def
singularity build got-ocr-simple.sif got-ocr-simple.def
singularity run got-ocr-simple.sif


srun singularity build got-ocr-simple-slurm.sif got-ocr-simple.def


sbatch run_got_ocr.slurm





srun --partition=gpu --gres=gpu:1 --pty bash -i




# Sur votre PC local
cd ~/Documents/PFE/GOT-OCR-2/FastAPI-GOT-OCR-2-Transformers
# Exclure les dossiers inutiles
rsync -avz --progress --exclude env --exclude __pycache__ --exclude .git ./ asidimoh@10.11.8.2:/data/asidimoh/GOT2/