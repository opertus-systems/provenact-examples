#!/usr/bin/env bash
set -euo pipefail

cat >&2 <<'EOF'
ERROR: demos/provenclaw-phase0 is a legacy demo and is no longer runnable from provenact-examples.

This path depended on the historical `provenclaw` CLI. Use active Provenact demos instead:
  - ./demos/hello-provenance/run.sh
  - ./demos/ci-gate/run.sh
  - ./demos/ide-bridge/run.sh
EOF

exit 2
