#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"

if [[ -d "${ROOT}/../../../provenact-control" && -d "${ROOT}/../../../provenact-control-web" ]]; then
  :
else
  echo "ERROR: missing sibling repos (expected provenact-control and provenact-control-web)" >&2
  exit 1
fi

cd "${ROOT}"
docker compose up --build
