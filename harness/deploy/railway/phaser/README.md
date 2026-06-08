# Railway Phaser Web Harness

This harness deploys the Phaser runtime as a static Railway service.

It builds a minimal deploy context that includes:

- `harness/runtime/`
- `harness/content/`
- `harness/tools/`
- `harness/game-profiles/`
- `harness/engine-contract/`
- the Phaser Railway Docker/Caddy config in this directory

The Docker image compiles `ninja2` during build and serves:

- `/survivor-runtime.html?game=ninja2`
- `/build/ninja2/*.json`
- runtime assets under `/assets`, `/src`, and `/vendor`

## Deploy

Prerequisite: install Railway CLI permanently and make `railway` available on `PATH`.

```bash
python3 harness/tools/railway_phaser_deploy.py
```

Useful options:

```bash
python3 harness/tools/railway_phaser_deploy.py --dry-run --keep-staging
python3 harness/tools/railway_phaser_deploy.py --docker-check --dry-run
python3 harness/tools/railway_phaser_deploy.py --service ninja2-web --environment production
python3 harness/tools/railway_phaser_deploy.py --game mushroomer --service phaser-web --environment production
python3 harness/tools/railway_phaser_deploy.py --railway-bin /absolute/path/to/railway
```

The script uses `railway` from `PATH` by default. It intentionally does not install or auto-use a temporary CLI.
