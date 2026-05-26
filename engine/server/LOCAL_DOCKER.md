# Local Docker

로컬 개발용으로 `postgres + world-server + api-server`를 한 번에 띄우는 구성이 [`docker-compose.local.yml`](/Users/yangjinhwan/Projects/idle-game-generator/engine/server/docker-compose.local.yml) 에 있습니다.

## 시작

```bash
cd /Users/yangjinhwan/Projects/idle-game-generator/engine/server
docker compose -f docker-compose.local.yml up --build
```

## 접속

- Postgres: `localhost:15432`
- WorldServer TCP: `localhost:11177`
- ApiServer HTTP: `http://localhost:15000`
- Swagger: `http://localhost:15000/swagger`

기본 호스트 포트는 환경변수로 바꿀 수 있습니다.

- Postgres: `IDLEZ_LOCAL_PG_PORT` 기본값 `15432`
- WorldServer: `IDLEZ_LOCAL_WORLD_PORT` 기본값 `11177`
- ApiServer: `IDLEZ_LOCAL_API_PORT` 기본값 `15000`

## 초기화

- Postgres 초기화는 [`postgres/initdb/00-init.sql`](/Users/yangjinhwan/Projects/idle-game-generator/engine/server/postgres/initdb/00-init.sql) 이 [`Server/Server/Models/*.sql`](/Users/yangjinhwan/Projects/idle-game-generator/engine/server/Server/Server/Models/WorldModel.sql:1) 을 순서대로 읽는 방식입니다.
- DB를 완전히 다시 만들려면:

```bash
cd /Users/yangjinhwan/Projects/idle-game-generator/engine/server
docker compose -f docker-compose.local.yml down -v
docker compose -f docker-compose.local.yml up --build
```

## 메모

- 리소스는 `engine/client/Client/Assets/PatchResources` 를 `/PatchResources` 로 마운트합니다.
- 로컬 컨테이너에서는 `IDLEZ_ENABLE_PUSH_SERVICES=false` 로 월드 서버의 푸시/크론 서비스를 끕니다.
- `EdgeServer` 는 현재 코드상 비활성 상태라 이 compose에는 포함하지 않았습니다.
