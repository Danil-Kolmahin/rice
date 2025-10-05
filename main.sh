#!/usr/bin/env bash
set -euo pipefail

uv run ansible-playbook -K -i localhost, -e 'target_hosts=localhost' -c local setup.yml
