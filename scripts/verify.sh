#!/usr/bin/env bash
set -euo pipefail

root="$(git rev-parse --show-toplevel)"

for check in structure output-names targets ai-catalog configurations; do
  "$root/scripts/verify/$check.sh"
done
