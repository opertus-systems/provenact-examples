# SECURITY.md

## Security Policy — provenact-examples

`provenact-examples` contains runnable integration demos. It is not a trust root.

### Scope

This policy applies to:
- demo scripts and compose assets
- fixture handling and local setup flows

This policy does not redefine substrate guarantees; those belong to `provenact-cli` and `provenact-spec`.

### Reporting

Report vulnerabilities privately:
- Email: security@opertus.systems
- Include affected demo path and reproduction details.

Do not disclose unpatched vulnerabilities publicly.

### Guidance

- Treat all demo inputs as untrusted.
- Never commit secrets in scripts, fixtures, or docs.
- Keep local-development-only defaults explicit (for example `localhost` HTTP URLs).
