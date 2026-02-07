# inactu-examples

Runnable examples for Inactu adoption.

This repository is intentionally integration-heavy and separate from the
hardened execution substrate repositories.

## Demos

- `demos/hello-provenance`: verify, execute, and verify receipt with a signed
  skill bundle.
- `demos/ci-gate`: enforce a policy-denial path suitable for CI gates.
- `demos/ide-bridge`: export installed skills as AgentSkills wrappers.
- `demos/control-plane-console`: local walkthrough tying `inactu-control` and
  `inactu-control-web`.

## Prerequisites

- `inactu-cli` in `PATH`, or sibling checkout at `../inactu-cli`.
- `bash`, `shasum`, and `awk`.
- `docker` + `docker compose` for control-plane demo.
- `node >= 20` for control-web demo.

## Quickstart

```bash
./scripts/smoke.sh
```

## Why separate from core runtime

Examples include integration glue, local wrappers, and higher-risk workflows
that should not expand the trusted core runtime threat surface.

## Repository policy docs

- Contribution guidelines: `CONTRIBUTING.md`
- Security reporting: `SECURITY.md`
