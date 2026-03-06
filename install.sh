#!/bin/bash
set -e

# Source shared utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/venv_utils.sh"

# Get basename of current directory for venv name
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

# Install vLLM with CUDA 13 support
uv pip install --upgrade --force-reinstall vllm==0.7.3 \
    --torch-backend=auto \
    --extra-index-url https://wheels.vllm.ai/nightly/cu130

# Install serving client dependencies
uv pip install "transformers[serving] @ git+https://github.com/huggingface/transformers.git@refs/tags/v4.48" openai

# Verify installation
if ! python -c "import vllm; import transformers" &> /dev/null; then
    echo "Error: Installation verification failed"
    exit 1
fi

echo ""
echo "Installation complete!"
echo "Venv location: $VENV_DIR"
