# flowcept-test

Local sandbox for working with Flowcept as the baseline for the CS-8903
source-attestation extension project (Staley / Madisetti, Summer 2026).

The goal of this directory is small and concrete: confirm the Flowcept
reference implementation installs, runs end-to-end and captures provenance,
so subsequent work on attestation-tier extensions builds on a verified
baseline.

## Prerequisites

- A recent **Miniconda** (or Miniforge) install on your machine. Apple Silicon
  Macs should use the arm64 installer.
- A POSIX-ish shell (bash, zsh). On Windows use WSL.

## Setup

From the project root:

```bash
./setup.sh
```

This creates a conda env called `flowcept` from `environment.yaml`, installs
Flowcept with the `mongo`, `llm_agent` and `telemetry` extras, and writes a
minimal Flowcept settings file at `~/.flowcept/settings.yaml`.

The script is idempotent. Re-running it updates the env in place rather than
failing.

If `setup.sh` reports that conda is missing, install Miniconda first:

```bash
# Apple Silicon (recommended for new Macs):
# Download from https://docs.conda.io/projects/miniconda/en/latest/
# Or:
brew install --cask miniconda
```

Restart your shell after installing Miniconda, then re-run `./setup.sh`.

## Smoke test

After setup, activate the env and run the quickstart:

```bash
conda activate flowcept
python quickstart.py
```

Expected output:

- `Final output 8` printed to the terminal
- A JSON dump of two captured provenance messages (one per decorated task)
- A new file `flowcept_messages.jsonl` containing the same two records

If you see those, the Flowcept reference implementation is working and the
baseline is verified.

## PyCharm

To use PyCharm with this project:

1. File -> Open -> select this directory
2. Bottom-right of the window, click the interpreter selector
3. Add New Interpreter -> Add Local Interpreter -> Conda Environment
4. Use existing environment -> pick `flowcept`

PyCharm's terminal will then activate the env automatically. Run
`quickstart.py` via right-click -> Run.

## Layout

```
.
├── environment.yaml      # conda env definition (source of truth)
├── setup.sh              # one-command setup
├── quickstart.py         # Flowcept hello-world from the upstream README
├── flowcept_messages.jsonl   # captured provenance (gitignored)
└── README.md
```

## Notes

- `environment.yaml` pins Python to 3.11 for compatibility with ML-adjacent
  dependencies that will be added later (PyTorch, transformers, etc.).
- The `flowcept` settings file lives at `~/.flowcept/settings.yaml`, outside
  the project. Edit there to change MQ/DB backends, log levels, telemetry
  capture, etc.
- For HPC / online persistence work later, see the Flowcept deployment
  Makefile shortcuts at <https://github.com/ORNL/flowcept/tree/main/deployment>.

## References

- Flowcept: <https://github.com/ORNL/flowcept>
- PROV-AGENT (Souza et al., e-Science 2025): arXiv:2508.02866