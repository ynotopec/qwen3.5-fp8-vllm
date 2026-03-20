#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODEL_NAME=$(basename "$SCRIPT_DIR")

# Get model URL or use default
MODEL_URL="lovedheart/Qwen3.5-9B-FP8"

echo "Starting vLLM server for Qwen3.5-9B-FP8..."
echo "Model: $MODEL_URL"

# Activate venv (auto-detect .venv structure)
if [ -d "$HOME/venv/$MODEL_NAME/.venv" ]; then
    source "$HOME/venv/$MODEL_NAME/.venv/bin/activate"
elif [ -d "$HOME/venv/$MODEL_NAME/virtualenv" ]; then
    source "$HOME/venv/$MODEL_NAME/virtualenv/bin/activate"
else
    source "$HOME/venv/$MODEL_NAME/bin/activate"
fi

# Start vLLM serving Qwen3.5
vllm serve "$MODEL_URL" \
    --port 8000 \
    --tensor-parallel-size 1 \
    --gpu-memory-utilization 0.22 \
    --max-model-len 262144 \
    --reasoning-parser qwen3 \
    --enable-auto-tool-choice \
    --tool-call-parser qwen3_coder
