#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
source "${ROOT}/scripts/lib.sh"
require_tools

WORKDIR="${ROOT}/artifacts/ci-gate"
mkdir -p "${WORKDIR}"

BUNDLE="${WORKDIR}/bundle"
FIXTURE="${ROOT}/fixtures/echo-v0"
KEYS="${FIXTURE}/public-keys.json"
POLICY_DENY="${FIXTURE}/policy.deny-signer.json"
INPUT="${FIXTURE}/input.json"
RECEIPT="${WORKDIR}/receipt.json"
LOG_FILE="${WORKDIR}/run-deny.log"

DIGEST="$(keys_digest "${KEYS}")"
rm -rf "${BUNDLE}"
run_provenact pack --bundle "${BUNDLE}" --wasm "${FIXTURE}/skill.wasm" --manifest "${FIXTURE}/manifest.json"
run_provenact sign --bundle "${BUNDLE}" --signer alice.dev --secret-key "${FIXTURE}/signer-secret-key.txt"

set +e
run_provenact run --bundle "${BUNDLE}" --keys "${KEYS}" --keys-digest "${DIGEST}" --policy "${POLICY_DENY}" --input "${INPUT}" --receipt "${RECEIPT}" >"${LOG_FILE}" 2>&1
rc=$?
set -e

if [[ "${rc}" -eq 0 ]]; then
  echo "ERROR: expected policy-denied run to fail" >&2
  cat "${LOG_FILE}" >&2
  exit 1
fi

echo "OK ci-gate denied as expected (exit=${rc})"
echo "log: ${LOG_FILE}"
