#!/usr/bin/env bash
set -euo pipefail

sudo uv run ansible-playbook setup.yml
