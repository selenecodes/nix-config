#!/usr/bin/env bash
set -euo pipefail

root="$(git rev-parse --show-toplevel)"

for check in structure output-names targets configurations; do
  "$root/scripts/verify/$check.sh"
done
