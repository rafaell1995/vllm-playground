# Use a fuller Python image instead of slim for better compatibility
FROM nvcr.io/nvidia/pytorch:23.10-py3

# Set the working directory in the container
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential libssl-dev libffi-dev

# Upgrade pip and install necessary Python packages for building other packages
RUN pip install --upgrade pip && \
    pip install cmake ninja packaging setuptools wheel filelock typing-extensions sympy networkx jinja2 fsspec MarkupSafe mpmath numpy torch

# Create and activate a virtual Python environment
RUN python -m venv /venv
ENV PATH="/venv/bin:$PATH"
ENV VLLM_VERSION=0.4.0
ENV PYTHON_VERSION=39

# Install vLLM with CUDA 11.8.
RUN pip install https://github.com/vllm-project/vllm/releases/download/v${VLLM_VERSION}/vllm-${VLLM_VERSION}+cu118-cp${PYTHON_VERSION}-cp${PYTHON_VERSION}-manylinux1_x86_64.whl --extra-index-url https://download.pytorch.org/whl/cu118

# Install other Python dependencies
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt --verbose

# Copy the rest of the application
COPY . .

# Make port 8000 available to the world outside this container
EXPOSE 8000

# Command to run the application
CMD ["python", "-m", "vllm.entrypoints.openai.api_server", "--model", "facebook/opt-125m"]
