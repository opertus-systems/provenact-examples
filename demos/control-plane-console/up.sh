#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"

for repo in ../../../inactu-control ../../../inactu-control-web; do
  if [[ ! -d "${ROOT}/${repo}" ]]; then
    echo "ERROR: missing sibling repo ${ROOT}/${repo}" >&2
    exit 1
  fi
done

cd "${ROOT}"
docker compose up --build
