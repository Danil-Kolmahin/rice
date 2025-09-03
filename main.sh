#!/usr/bin/env bash
set -euo pipefail

uv run ansible-playbook setup.yml --ask-become-pass
