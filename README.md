# provenact-examples

Runnable examples for Provenact adoption.

This repository is intentionally integration-heavy and separate from the
hardened execution substrate repositories.

## Demos

- `demos/hello-provenance`: verify, execute, and verify receipt with a signed
  skill bundle.
- `demos/ci-gate`: enforce a policy-denial path suitable for CI gates.
- `demos/ide-bridge`: export installed skills as AgentSkills wrappers.
- `demos/provenclaw-phase0`: register immutable tools, run via ProvenClaw,
  verify receipt, and print audit NDJSON tail.
- `demos/control-plane-console`: local walkthrough tying `provenact-control` and
  `provenact-control-web`.

## Prerequisites

- `provenact-cli` in `PATH`, or sibling checkout at `../provenact-cli`.
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
