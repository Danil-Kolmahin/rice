#!/usr/bin/env bash
set -euo pipefail

uv sync
uv run ansible-galaxy collection install -r requirements.yml
