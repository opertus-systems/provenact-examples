#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
source "${ROOT}/scripts/lib.sh"
require_tools

resolve_provenclaw() {
  if command -v provenclaw >/dev/null 2>&1; then
    echo "provenclaw"
    return 0
  fi

  local sibling_root="${ROOT}/../provenclaw"
  if [[ -x "${sibling_root}/target/debug/provenclaw" ]]; then
    echo "${sibling_root}/target/debug/provenclaw"
    return 0
  fi
  if [[ -f "${sibling_root}/Cargo.toml" ]]; then
    echo "cargo:${sibling_root}/Cargo.toml:provenclaw-cli"
    return 0
  fi

  echo "ERROR: could not find provenclaw on PATH or at ../provenclaw" >&2
  return 1
}

run_provenclaw() {
  local cli
  cli="$(resolve_provenclaw)"
  if [[ "${cli}" == cargo:* ]]; then
    local cargo_manifest
    local cargo_pkg
    IFS=':' read -r _ cargo_manifest cargo_pkg <<< "${cli}"
    cargo run -q --manifest-path "${cargo_manifest}" -p "${cargo_pkg}" -- "$@"
  else
    "${cli}" "$@"
  fi
}

WORKDIR="${ROOT}/artifacts/provenclaw-phase0"
PROVENCLAW_HOME="${WORKDIR}/provenclaw-home"
mkdir -p "${WORKDIR}"
rm -rf "${PROVENCLAW_HOME}"

DIGEST_ONE="sha256:1111111111111111111111111111111111111111111111111111111111111111"
DIGEST_TWO="sha256:2222222222222222222222222222222222222222222222222222222222222222"
INPUT_JSON="${WORKDIR}/input.json"
RUN_JSON="${WORKDIR}/run-output.json"
AUDIT_LOG="${PROVENCLAW_HOME}/audit.ndjson"

cat > "${INPUT_JSON}" <<'JSON'
{
  "actor": "phase0-demo",
  "payload": {
    "invoice_id": "inv_phase0_001"
  }
}
JSON

PROVENCLAW_HOME="${PROVENCLAW_HOME}" run_provenclaw init
PROVENCLAW_HOME="${PROVENCLAW_HOME}" run_provenclaw tools add "${DIGEST_ONE}" --name fetch_invoice --publisher acme.sec --policy policy.default.json
PROVENCLAW_HOME="${PROVENCLAW_HOME}" run_provenclaw tools add "${DIGEST_TWO}" --name summarize_invoice --publisher acme.sec --policy policy.default.json

PROVENCLAW_HOME="${PROVENCLAW_HOME}" run_provenclaw run fetch_invoice --input "${INPUT_JSON}" > "${RUN_JSON}"

RECEIPT_ID="$(python3 - "$RUN_JSON" <<'PY'
import json
import sys

with open(sys.argv[1], "r", encoding="utf-8") as f:
    data = json.load(f)
print(data["receipt_id"])
PY
)"

PROVENCLAW_HOME="${PROVENCLAW_HOME}" run_provenclaw receipts verify "${RECEIPT_ID}"

echo "OK receipt verification succeeded: ${RECEIPT_ID}"
echo "Audit tail (${AUDIT_LOG}):"
tail -n 5 "${AUDIT_LOG}"
