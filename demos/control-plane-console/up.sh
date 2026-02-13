#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"

for repo in ../../../provenact-control ../../../provenact-control-web; do
  if [[ ! -d "${ROOT}/${repo}" ]]; then
    echo "ERROR: missing sibling repo ${ROOT}/${repo}" >&2
    exit 1
  fi
done

generate_secret() {
  if command -v openssl >/dev/null 2>&1; then
    openssl rand -hex 32
    return
  fi
  # Fallback for environments without openssl.
  LC_ALL=C tr -dc 'A-Za-z0-9' </dev/urandom | head -c 64
  printf '\n'
}

if [[ -z "${PROVENACT_API_AUTH_SECRET:-}" ]]; then
  PROVENACT_API_AUTH_SECRET="$(generate_secret)"
  export PROVENACT_API_AUTH_SECRET
  echo "INFO: generated ephemeral PROVENACT_API_AUTH_SECRET for this session"
fi

if [[ -z "${NEXTAUTH_SECRET:-}" ]]; then
  NEXTAUTH_SECRET="$(generate_secret)"
  export NEXTAUTH_SECRET
  echo "INFO: generated ephemeral NEXTAUTH_SECRET for this session"
fi

cd "${ROOT}"
docker compose up --build
