#!/usr/bin/env bash
#
# setup.sh - one-shot environment setup for the flowcept-test project
#
# What this does:
#   1. Checks for conda. Fails with a helpful message if missing.
#   2. Creates (or updates) the 'flowcept' conda env from environment.yaml.
#   3. Initializes Flowcept's settings file at ~/.flowcept/settings.yaml.
#   4. Prints next-step instructions.
#
# What this does NOT do:
#   - Install conda/miniconda for you. Do that yourself first.
#   - Run anything as root.
#   - Activate the env in your current shell (shells can't do that from a
#     subprocess). You'll be told to run `conda activate flowcept` manually.
#
# Usage:
#   ./setup.sh
#
# Safe to re-run.

set -euo pipefail

ENV_NAME="flowcept"
ENV_FILE="environment.yaml"

# Pretty-print helper
say() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
err() { printf '\033[1;31mERROR:\033[0m %s\n' "$*" >&2; }

# --- Step 1: Check conda is installed and on PATH ---
if ! command -v conda &>/dev/null; then
    err "conda not found on PATH."
    cat <<MSG >&2

Please install miniconda first:
  - Apple Silicon Mac: download the arm64 installer from
    https://docs.conda.io/projects/miniconda/en/latest/
  - or via Homebrew: brew install --cask miniconda

After installing, restart your shell and re-run this script.
MSG
    exit 1
fi

# --- Step 2: Check the environment file exists ---
if [[ ! -f "$ENV_FILE" ]]; then
    err "$ENV_FILE not found in current directory ($PWD)."
    err "Run this script from the project root."
    exit 1
fi

# --- Step 3: Create or update the conda env ---
# `conda env list` exit code is always 0, so we grep for the env name.
if conda env list | awk '{print $1}' | grep -qx "$ENV_NAME"; then
    say "Conda env '$ENV_NAME' already exists. Updating from $ENV_FILE..."
    conda env update -n "$ENV_NAME" -f "$ENV_FILE" --prune
else
    say "Creating conda env '$ENV_NAME' from $ENV_FILE..."
    conda env create -f "$ENV_FILE"
fi

# --- Step 4: Initialize Flowcept settings (idempotent: skip if already there) ---
SETTINGS_PATH="$HOME/.flowcept/settings.yaml"
if [[ -f "$SETTINGS_PATH" ]]; then
    say "Flowcept settings already exist at $SETTINGS_PATH (leaving alone)."
else
    say "Initializing Flowcept settings at $SETTINGS_PATH..."
    # Run flowcept --init-settings inside the env without a full activate.
    conda run -n "$ENV_NAME" flowcept --init-settings
fi

# --- Done ---
cat <<NEXT

\033[1;32mSetup complete.\033[0m

Next steps:
  1. Activate the env in this shell:
       conda activate $ENV_NAME

  2. Verify the install:
       python -c "import flowcept; print(flowcept.__version__)"

  3. Run the quickstart:
       python quickstart.py

  4. (Optional) Point PyCharm at this env:
       Settings -> Project -> Python Interpreter -> Add -> Conda Environment
       -> Use existing -> flowcept

NEXT