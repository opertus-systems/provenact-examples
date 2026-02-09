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

  if command -v provenact-cli >/dev/null 2>&1; then
    echo "provenact-cli"
    return 0
  fi

  local root
  root="$(repo_root)"
  local sibling_provenact="${root}/../provenact-cli"
  if [[ -x "${sibling_provenact}/target/debug/provenact-cli" ]]; then
    echo "${sibling_provenact}/target/debug/provenact-cli"
    return 0
  fi
  if [[ -x "${sibling_provenact}/target/debug/provenact-cli" ]]; then
    echo "${sibling_provenact}/target/debug/provenact-cli"
    return 0
  fi

  local sibling_legacy="${root}/../provenact-cli"
  if [[ -x "${sibling_legacy}/target/debug/provenact-cli" ]]; then
    echo "${sibling_legacy}/target/debug/provenact-cli"
    return 0
  fi

  if [[ -f "${sibling_provenact}/Cargo.toml" ]]; then
    echo "cargo-run-provenact:${sibling_provenact}/Cargo.toml"
    return 0
  fi

  if [[ -f "${sibling_legacy}/Cargo.toml" ]]; then
    echo "cargo-run-provenact:${sibling_legacy}/Cargo.toml"
    return 0
  fi

  echo "ERROR: could not find provenact-cli/provenact-cli binary or sibling repo at ${sibling_provenact} or ${sibling_legacy}" >&2
  return 1
}

run_provenact() {
  local cli
  cli="$(resolve_provenact_cli)"
  case "${cli}" in
    cargo-run-provenact:*)
      local manifest="${cli#cargo-run-provenact:}"
      cargo run -q -p provenact-cli --manifest-path "${manifest}" --bin provenact-cli -- "$@"
      ;;
    cargo-run-provenact:*)
      local manifest="${cli#cargo-run-provenact:}"
      cargo run -q -p provenact-cli --manifest-path "${manifest}" --bin provenact-cli -- "$@"
      ;;
    *)
      "${cli}" "$@"
      ;;
  esac
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
