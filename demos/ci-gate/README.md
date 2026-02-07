# CI Gate

This demo validates a fail-closed policy path by denying trusted signer access.

Run:

```bash
./demos/ci-gate/run.sh
```

The script succeeds only when `inactu-cli run` fails due to policy denial.
Use it as a CI guardrail pattern.
