#!/usr/bin/env bash
set -euo pipefail

uv run ansible-playbook playbooks/setup.yml
