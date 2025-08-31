#!/usr/bin/env bash
set -euo pipefail

uv run ansible-playbook ansible/playbooks/setup.yml
