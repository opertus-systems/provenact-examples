#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

"${ROOT}/demos/hello-provenance/run.sh"
"${ROOT}/demos/ci-gate/run.sh"
"${ROOT}/demos/ide-bridge/run.sh"

echo "OK smoke demos"
