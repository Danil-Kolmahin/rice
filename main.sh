#!/usr/bin/env bash
set -euo pipefail

uv run ansible-playbook -K -i localhost, -e 'target_hosts=localhost' -c local setup.yml # -v # TODO: explore for debug

# TODO: add rehash command so new commands available instantly

# if device==pc then set FRAME='tower' and run with tags -base -develop -loaf -extended -experiments
# if device==laptop then set FRAME='cart' and run with tags -base -develop -loaf
# if device==phone then set FRAME='pony' and run with tags -base -phone
# if device==vm then set FRAME='mirror' and run with tags -base -vm -server
# if device==server then set FRAME='outpost' and run with tags -base -server -experiments
