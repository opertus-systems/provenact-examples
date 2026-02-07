#!/usr/bin/env bash
set -euo pipefail

repo_root() {
  local script_dir
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  cd "${script_dir}/.." >/dev/null 2>&1
  pwd
}

resolve_inactu_cli() {
  if command -v inactu-cli >/dev/null 2>&1; then
    echo "inactu-cli"
    return 0
  fi

  local root
  root="$(repo_root)"
  local sibling="${root}/../inactu-cli"
  if [[ -x "${sibling}/target/debug/inactu-cli" ]]; then
    echo "${sibling}/target/debug/inactu-cli"
    return 0
  fi

  if [[ -f "${sibling}/Cargo.toml" ]]; then
    echo "cargo run -q -p inactu-cli --manifest-path ${sibling}/Cargo.toml --bin inactu-cli --"
    return 0
  fi

  echo "ERROR: could not find inactu-cli binary or sibling repo at ${sibling}" >&2
  return 1
}

run_inactu() {
  local cli
  cli="$(resolve_inactu_cli)"
  if [[ "${cli}" == cargo\ run* ]]; then
    eval "${cli} $*"
  else
    "${cli}" "$@"
  fi
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
