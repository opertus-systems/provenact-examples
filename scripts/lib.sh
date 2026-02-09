#!/usr/bin/env bash
set -euo pipefail

repo_root() {
  local script_dir
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  cd "${script_dir}/.." >/dev/null 2>&1
  pwd
}

resolve_provenact_cli() {
  if command -v provenact-cli >/dev/null 2>&1; then
    echo "provenact-cli"
    return 0
  fi

  if command -v inactu-cli >/dev/null 2>&1; then
    echo "inactu-cli"
    return 0
  fi

  local root
  root="$(repo_root)"

  local sibling
  for sibling in "${root}/../provenact-cli" "${root}/../inactu-cli"; do
    if [[ -x "${sibling}/target/debug/provenact-cli" ]]; then
      echo "${sibling}/target/debug/provenact-cli"
      return 0
    fi
    if [[ -x "${sibling}/target/debug/inactu-cli" ]]; then
      echo "${sibling}/target/debug/inactu-cli"
      return 0
    fi
    if [[ -f "${sibling}/Cargo.toml" ]]; then
      if [[ "${sibling}" == *"/provenact-cli" ]]; then
        echo "cargo:${sibling}/Cargo.toml:provenact-cli"
      else
        echo "cargo:${sibling}/Cargo.toml:inactu-cli"
      fi
      return 0
    fi
  done

  echo "ERROR: could not find provenact-cli or inactu-cli binary, or sibling repo at ../provenact-cli or ../inactu-cli" >&2
  return 1
}

run_provenact() {
  local cli
  cli="$(resolve_provenact_cli)"
  if [[ "${cli}" == cargo:* ]]; then
    local cargo_manifest
    local cargo_bin
    IFS=':' read -r _ cargo_manifest cargo_bin <<< "${cli}"
    cargo run -q -p "${cargo_bin}" --manifest-path "${cargo_manifest}" --bin "${cargo_bin}" -- "$@"
  else
    "${cli}" "$@"
  fi
}

run_inactu() {
  run_provenact "$@"
}

keys_digest() {
  local keys_file="$1"
  shasum -a 256 "${keys_file}" | awk '{print "sha256:"$1}'
}

require_tools() {
  local missing=0
  for tool in shasum awk; do
    if ! command -v "${tool}" >/dev/null 2>&1; then
      echo "missing required tool: ${tool}" >&2
      missing=1
    fi
  done
  if [[ "${missing}" -ne 0 ]]; then
    exit 1
  fi
}
