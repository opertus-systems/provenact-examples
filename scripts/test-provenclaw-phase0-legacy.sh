#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$(mktemp)"
trap 'rm -f "$OUT"' EXIT

set +e
"$ROOT/demos/provenclaw-phase0/demo.sh" >"$OUT" 2>&1
EXIT_CODE=$?
set -e

if [[ "$EXIT_CODE" -eq 0 ]]; then
  echo "expected legacy demo to fail fast, but it exited 0" >&2
  cat "$OUT" >&2
  exit 1
fi

grep -qi 'legacy demo' "$OUT" || {
  echo "expected legacy warning in output" >&2
  cat "$OUT" >&2
  exit 1
}
grep -qi 'provenclaw' "$OUT" || {
  echo "expected migration context mentioning provenclaw in output" >&2
  cat "$OUT" >&2
  exit 1
}

echo "OK provenclaw-phase0 legacy guard"
