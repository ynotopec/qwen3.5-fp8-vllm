#!/bin/bash
set -e

# Get basename of current directory for venv name
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODEL_NAME=$(basename "$SCRIPT_DIR")

VENV_DIR="$HOME/venv/${MODEL_NAME}"
echo "Creating venv at: $VENV_DIR"

rm -rf "$VENV_DIR"
mkdir -p "$VENV_DIR"
cd "$VENV_DIR"

# Install uv via pipx or curl if not available
if ! command -v uv &> /dev/null; then
    echo "uv not installed, installing..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.local/bin:$PATH"
fi

# Create Python venv using uv python and install dependencies
echo "Initializing Python environment..."
uv venv
echo "Installing vllm and transformers with torch backend..."

# Install vLLM with CUDA 13 support (per Unsloth docs)
uv pip install --upgrade --force-reinstall vllm \
    --torch-backend=auto \
    --extra-index-url https://wheels.vllm.ai/nightly/cu130
uv pip install --upgrade --force-reinstall git+https://github.com/huggingface/transformers.git@main

# Install transformers and other dependencies
uv pip install "transformers[serving] @ git+https://github.com/huggingface/transformers.git@main"


echo ""
echo "=========================================="
echo "Installation complete!"
echo "Venv location: $VENV_DIR"
echo "To activate: source ~/venv/${MODEL_NAME}/bin/activate"
echo "=========================================="
