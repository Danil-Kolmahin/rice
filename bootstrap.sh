#!/usr/bin/env bash
set -euo pipefail

uv sync
ansible-galaxy collection install -r requirements.yml
