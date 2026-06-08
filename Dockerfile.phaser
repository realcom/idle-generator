ARG GAME_ID=ninja2

FROM python:3.12-slim AS content-build

ARG GAME_ID

WORKDIR /app

COPY harness/tools/requirements.txt harness/tools/requirements.txt
RUN python3 -m pip install --no-cache-dir -r harness/tools/requirements.txt

COPY harness/tools harness/tools
COPY harness/content harness/content
COPY harness/game-profiles harness/game-profiles
COPY harness/engine-contract harness/engine-contract

RUN python3 harness/tools/idlez_compile.py "${GAME_ID}"

FROM caddy:2-alpine

ARG GAME_ID

WORKDIR /srv

COPY harness/runtime/ /srv/
COPY --from=content-build /app/harness/build/${GAME_ID}/ /srv/build/${GAME_ID}/
COPY engine/commons/ /srv/engine/commons/
COPY harness/deploy/railway/phaser/Caddyfile /etc/caddy/Caddyfile
