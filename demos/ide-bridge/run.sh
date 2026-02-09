#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
source "${ROOT}/scripts/lib.sh"
require_tools

WORKDIR="${ROOT}/artifacts/ide-bridge"
mkdir -p "${WORKDIR}"

BUNDLE_DIR="${WORKDIR}/bundle"
FIXTURE="${ROOT}/fixtures/echo-v0"
KEYS="${FIXTURE}/public-keys.json"

ARCHIVE="${WORKDIR}/minimal-zero-cap.skill.tar.zst"
EXPORT_ROOT="${WORKDIR}/cursor-skills"
PROVENACT_HOME="${WORKDIR}/provenact-home"

DIGEST="$(keys_digest "${KEYS}")"

rm -rf "${BUNDLE_DIR}"
run_provenact pack --bundle "${BUNDLE_DIR}" --wasm "${FIXTURE}/skill.wasm" --manifest "${FIXTURE}/manifest.json"
run_provenact sign --bundle "${BUNDLE_DIR}" --signer alice.dev --secret-key "${FIXTURE}/signer-secret-key.txt"
run_provenact archive --bundle "${BUNDLE_DIR}" --output "${ARCHIVE}"
PROVENACT_HOME="${PROVENACT_HOME}" run_provenact install --artifact "${ARCHIVE}" --keys "${KEYS}" --keys-digest "${DIGEST}" --require-signatures
mkdir -p "${EXPORT_ROOT}"
(
  cd "${EXPORT_ROOT}"
  PROVENACT_HOME="${PROVENACT_HOME}" run_provenact export agentskills --agent cursor --scope repo
)

echo "OK ide-bridge exported skills under ${EXPORT_ROOT}/.cursor/skills"
