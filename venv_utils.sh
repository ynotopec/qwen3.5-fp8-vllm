#!/bin/bash

# Centralized venv activation function
# Usage: source "$SCRIPT_DIR/venv_utils.sh" && activate_venv
ACTIVATE_VENV() {
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local model_name="$(basename "$script_dir")"

    if [ -d "$HOME/venv/$model_name/.venv" ]; then
        source "$HOME/venv/$model_name/.venv/bin/activate"
    elif [ -d "$HOME/venv/$model_name/virtualenv" ]; then
        source "$HOME/venv/$model_name/virtualenv/bin/activate"
    else
        source "$HOME/venv/$model_name/bin/activate"
    fi
}