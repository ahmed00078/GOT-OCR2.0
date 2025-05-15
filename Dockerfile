# File: Dockerfile
FROM python:3.9-slim

WORKDIR /app

# Install system dependencies (ajout d'optimisations CPU)
RUN apt-get update && apt-get install -y \
    libgl1 \
    libglib2.0-0 \
    git \
    libomp5 \
    libgomp1 \
    && rm -rf /var/lib/apt/lists/*

# Définir des variables d'environnement pour optimiser PyTorch sur CPU
ENV OMP_NUM_THREADS=4
ENV MKL_NUM_THREADS=4
ENV NUMEXPR_NUM_THREADS=4
ENV TOKENIZERS_PARALLELISM=true

# Copy and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Ajouter les optimisations Hugging Face pour CPU
RUN pip install --no-cache-dir optimum

# Copy necessary Python files
COPY globe.py render.py main.py ./

# Copy frontend directory
COPY frontend/ ./frontend/

# Créer le dossier static s'il n'existe pas
RUN mkdir -p static

# Copy the entire render_tools/ directory
COPY render_tools/ ./render_tools/

# Download the model during the build process with optimisations pour CPU
RUN python -c "from transformers import AutoModelForImageTextToText, AutoProcessor; \
    import torch; \
    device = 'cpu'; \
    AutoProcessor.from_pretrained('stepfun-ai/GOT-OCR-2.0-hf'); \
    model = AutoModelForImageTextToText.from_pretrained('stepfun-ai/GOT-OCR-2.0-hf', low_cpu_mem_usage=True, device_map=device); \
    # Optimisation pour CPU \
    optimized_model = model.to('cpu').eval(); \
    print('Model loaded and optimized for CPU')"

# Augmenter le timeout de uvicorn pour les traitements longs
ENV UVICORN_TIMEOUT=300

# Command to run the application with timeout settings
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--timeout-keep-alive", "300"]