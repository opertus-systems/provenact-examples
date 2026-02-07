# Control Plane + Web Console Walkthrough

This demo composes sibling repos:

- `inactu-control` (API)
- `inactu-control-web` (Next.js console)
- local Postgres

Run:

```bash
./demos/control-plane-console/up.sh
```

Open:

- API health: <http://localhost:8080/healthz>
- Web console: <http://localhost:3000>

Tear down:

```bash
./demos/control-plane-console/down.sh
```

Notes:

- This is a local dev walkthrough, not a production deployment profile.
- `INACTU_API_AUTH_SECRET` is fixed for demo purposes and must be rotated in
  real environments.
