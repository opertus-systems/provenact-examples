# ProvenClaw Phase 0 Demo

This demo provides a 5-minute enterprise-evaluable flow:

1. initialize isolated `PROVENCLAW_HOME`
2. register two immutable tool digests
3. run a tool via `provenclaw run`
4. verify emitted receipt
5. print audit log tail (`audit.ndjson`)

Run:

```bash
./demos/provenclaw-phase0/demo.sh
```

Output artifacts:
- run output JSON: `artifacts/provenclaw-phase0/run-output.json`
- receipts/audit under: `artifacts/provenclaw-phase0/provenclaw-home/`

The script resolves `provenclaw` from:
- `PATH`, then
- sibling checkout at `../provenclaw/target/debug/provenclaw`, then
- `cargo run` from sibling `../provenclaw`.
