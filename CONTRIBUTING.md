# Contributing

`inactu-examples` is intentionally integration-heavy. Keep changes small, runnable, and explicit.

## Rules

1. Do not weaken substrate/runtime trust boundaries in example scripts.
2. Keep demos deterministic and reproducible where possible.
3. Prefer plain shell scripts with strict mode (`set -euo pipefail`).
4. Document prerequisites and expected output for every demo.
5. Avoid embedding secrets or environment-specific credentials.

## Validation

Before opening a PR:

1. Run `./scripts/smoke.sh`.
2. Run the demo(s) you changed end-to-end.
3. Update README/docs for any behavior changes.
