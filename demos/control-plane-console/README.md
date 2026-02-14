# Control Plane + Web Console Walkthrough

This demo composes sibling repos:

- `provenact-control` (API)
- `provenact-control-web` (Next.js console)
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
- `./up.sh` auto-generates ephemeral `PROVENACT_API_AUTH_SECRET` and
  `NEXTAUTH_SECRET` when they are unset.
- The compose profile sets `PROVENACT_ALLOW_PRIVATE_HTTP=true` so the web app
  can reach `http://provenact-control:8080` on the private docker network.
- If you prefer fixed local values, export those environment variables before
  running `./up.sh`.
