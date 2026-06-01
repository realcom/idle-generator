---
name: local-server
description: "로컬 idlez 서버를 Docker로 기동·재기동·중지하고, Unity 에디터가 붙는 기본 주소와 점검 절차를 안내한다."
argument-hint: "[up | restart | down | logs | status]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Bash
model: sonnet
---

# 로컬 서버 (Docker)

`engine/server/docker-compose.local.yml` 기준으로 로컬 `postgres + world-server + api-server`를 다룬다.

## 기본 원칙

- 실행 위치: `engine/server/`
- 기본 호스트 포트:
  - Postgres `15432`
  - WorldServer `11177`
  - ApiServer `15000`
- Unity 에디터 기본 접속 설정:
  - `engine/client/Client/Assets/Resources/Debug.xml`
  - `FixHost=127.0.0.1:11177`
  - `FixWebHost=http://127.0.0.1:15000`
- DB 초기화 source of truth:
  - `engine/server/Server/Server/Models/*.sql`
  - compose는 `engine/server/postgres/initdb/00-init.sql`로 이를 순서대로 읽는다.

## 실행 명령

### 1. 기동

```bash
cd engine/server
docker compose -f docker-compose.local.yml up -d --build
```

### 2. 재기동

```bash
cd engine/server
docker compose -f docker-compose.local.yml restart
```

빌드나 리소스 변경까지 반영하려면:

```bash
cd engine/server
docker compose -f docker-compose.local.yml up -d --build --force-recreate
```

### 3. 상태 확인

```bash
cd engine/server
docker compose -f docker-compose.local.yml ps
```

### 4. 로그 확인

```bash
cd engine/server
docker compose -f docker-compose.local.yml logs --tail=200 world-server api-server postgres
```

### 5. 중지

```bash
cd engine/server
docker compose -f docker-compose.local.yml down
```

### 6. DB까지 완전 초기화

```bash
cd engine/server
docker compose -f docker-compose.local.yml down -v
docker compose -f docker-compose.local.yml up -d --build
```

## 포트 충돌 시

환경변수로 호스트 포트를 바꾼다.

```bash
cd engine/server
IDLEZ_LOCAL_PG_PORT=25432 \
IDLEZ_LOCAL_WORLD_PORT=21177 \
IDLEZ_LOCAL_API_PORT=25000 \
docker compose -f docker-compose.local.yml up -d --build
```

이 경우 Unity `Debug.xml`도 같은 포트로 함께 맞춘다.

## 점검 체크리스트

1. `docker compose ... ps` 에서 세 컨테이너가 `Up` 상태인지 확인.
2. `world-server` 로그에 `Server started on port 11177`가 있는지 확인.
3. `api-server` 로그에 `Now listening on: http://[::]:5000`가 있는지 확인.
4. Unity 에디터는 `Assets/Resources/Debug.xml`이 로드됐는지 콘솔에서 `Loaded Debug.xml.` 로그 확인.
5. Swagger 접속: `http://127.0.0.1:15000/swagger`

## 자주 막히는 지점

- `Commons.projitems` 누락:
  - Docker build context가 `engine/`여야 한다.
  - `engine/server/Dockerfile.local`이 `engine/commons`를 `/src/Server/Commons`로 복사해야 한다.
- 리소스 파싱 실패:
  - `engine/client/Client/Assets/PatchResources/*.json`이 최신인지 확인.
- 포트 충돌:
  - 기본 포트 대신 `IDLEZ_LOCAL_*_PORT` 오버라이드 사용.
