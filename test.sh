#!/bin/bash
set -e

echo "Testing vLLM + Qwen3.5-9B-FP8 connection..."

# Activate virtualenv
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODEL_NAME=$(basename "$SCRIPT_DIR")

if [ -d "$HOME/venv/$MODEL_NAME/.venv" ]; then
    source "$HOME/venv/$MODEL_NAME/.venv/bin/activate"
elif [ -d "$HOME/venv/$MODEL_NAME/virtualenv" ]; then
    source "$HOME/venv/$MODEL_NAME/virtualenv/bin/activate"
else
    source "$HOME/venv/$MODEL_NAME/bin/activate"
fi

# Test chat completions API
python << 'EOF'
from openai import OpenAI

client = OpenAI(
    base_url="http://localhost:8000/v1",
    api_key="EMPTY"
)

response = client.chat.completions.create(
    model="Qwen3.5-9B-FP8",
    messages=[
        {"role": "user", "content": "Hello! Who are you?"}
    ],
    temperature=0.7,
    top_p=0.8,
    max_tokens=128
)

print("Test successful!")
print(f"Response: {response.choices[0].message.content[:200]}")
EOF

echo ""
echo "=========================================="
echo "vLLM + Qwen3.5-9B-FP8 test complete!"
echo "API server running at http://localhost:8000/v1"
echo "=========================================="
