#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
source "${ROOT}/scripts/lib.sh"
require_tools

WORKDIR="${ROOT}/artifacts/hello-provenance"
mkdir -p "${WORKDIR}"

BUNDLE="${WORKDIR}/bundle"
FIXTURE="${ROOT}/fixtures/echo-v0"
KEYS="${FIXTURE}/public-keys.json"
POLICY="${FIXTURE}/policy.allow.json"
INPUT="${FIXTURE}/input.json"
RECEIPT="${WORKDIR}/receipt.json"

DIGEST="$(keys_digest "${KEYS}")"

rm -rf "${BUNDLE}"
run_provenact pack --bundle "${BUNDLE}" --wasm "${FIXTURE}/skill.wasm" --manifest "${FIXTURE}/manifest.json"
run_provenact sign --bundle "${BUNDLE}" --signer alice.dev --secret-key "${FIXTURE}/signer-secret-key.txt"
run_provenact verify --bundle "${BUNDLE}" --keys "${KEYS}" --keys-digest "${DIGEST}"
run_provenact run --bundle "${BUNDLE}" --keys "${KEYS}" --keys-digest "${DIGEST}" --policy "${POLICY}" --input "${INPUT}" --receipt "${RECEIPT}"
run_provenact verify-receipt --receipt "${RECEIPT}"

echo "OK hello-provenance receipt=${RECEIPT}"
