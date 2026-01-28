# TeamCoperation v2 리뉴얼 설계서 (Bun + TypeScript + MySQL 8.4 + React/Vite)

작성일: 2026-01-18  
대상: `teamcoperation/` (현행 v1: Node.js + Express + MySQL + React16/Redux/Webpack)  
목표: 팀코퍼레이션(교육/이벤트 운영 시스템)을 **기술 스택 + DB + 핵심 게임/미션 플로우** 기준으로 재설계(v2)

> 이 문서는 “팀레이스(teamrace)”가 아니라 **팀코퍼레이션(teamcoperation)** 리뉴얼을 위한 계획서입니다.  
> 현행 기능/DB/구조는 `teamcoperation/FEATURES.md`, `teamcoperation/ref/create_tables_only.sql` 를 기준으로 파악했습니다.

---

## 0. 결론(Executive Summary)

### 지금 문제의 본질
- v1은 **Node+Express** 기반으로 빠르게 만들어졌고, 기능은 많지만
  - DB/보안/감사(누가 왜 점수를 줬는지) 구조가 약하고
  - 파일 업로드가 서버 디스크에 쌓이며
  - 프론트가 React16 + Redux + Webpack으로 분산되어 유지보수가 어렵습니다.

### v2에서 “반드시” 바꿔야 하는 3가지
1) **업로드는 서버가 받지 않기**  
   - 휴대폰 → S3 직업로드, 서버는 presign 발급 + 메타 저장 + 업로드 완료 검증만
2) **머니(cash)와 리워드(reward)를 분리하기**  
   - 머니: 미션 검수로 지급, 땅(블럭) 구매에 소모  
   - 리워드: 땅 구매 시 적립, **리워드로 순위 집계**
3) **땅따먹기는 “구매 트랜잭션”으로**  
   - 모바일에서 블럭 클릭 → 돈(머니) 차감 → 타일 owner 변경(팀색) → 리워드 적립  
   - 동시 클릭/재시도에도 중복 결제/중복 리워드가 절대 발생하지 않게(트랜잭션 + idempotency)

### v2 아키텍처(추천)
- Backend: **Bun + TypeScript**
- DB: **MySQL 8.4** + 마이그레이션 체계(필수)
- Storage: **S3 + CloudFront(OAC)** (미디어 “공개 노출” 요구사항 충족, 운영 안정성↑)
- Frontend: **React 최신 + Vite**
  - 모바일 사용자 앱(땅따먹기 + 미션 업로드)
  - 관리자 앱(미션 검수/머니 지급 + 맵 크기 설정 + 리워드 랭킹/현황)
- 상태/데이터:
  - 서버 데이터: **TanStack Query**
  - UI 상태: **Zustand**

---

## 1. 요구사항 정리(사용자 확정 사항)

### 1.1 땅따먹기(모바일 전용)
- 휴대폰에서만 진행
- 땅(블럭)을 클릭하면:
  - **자신의 점수(머니)를 소모해서** 땅을 구매/뒤집음
  - 뒤집으면 **팀 색상**으로 바뀜
- 맵 크기(width/height)는 **관리자 페이지에서 설정** 가능
- 구매에 쓰는 돈(머니)과 구매해서 얻는 리워드는 **서로 다른 유형**
- 추후 순위는 **리워드 기준으로 집계**

### 1.2 미디어 업로드(사진/영상)
- 업로드 포맷: 이미지/영상
- 서버 용량이 커지지 않게:
  - **사용자 폰 → AWS(S3)로 직접 업로드**
  - 업로드 성공 후 **파일 정보(메타)를 서버로 전송**
- 미디어는 “모두에게 노출” 가능

### 1.3 미션 운영(관리자 검수 → 머니 지급)
- 관리자는 관리자 페이지에서 교육생들의 미션(사진/영상)을 보고
  - **머니(점수/돈)를 부여**하는 방식

### 1.4 기술 스택 변경
- 런타임: Node 대신 **Bun**
- DB: MySQL **버전 업그레이드**
- 언어: **TypeScript**
- 프론트: React 최신 + **Vite**
- 상태/데이터: Zustand + TanStack Query

---

## 2. 현행(v1) 구조 요약(리뉴얼 관점에서 중요한 것만)

### 2.1 서버/DB/프론트 현황
- 서버: `teamcoperation/src/index.js`
  - Express + `express-session` + `express-mysql-session`
  - CORS 전면 허용(`app.use(cors())`)
  - Socket.IO(퍼즐 보드 실시간)
- 업로드:
  - 유저 업로드: `multer`로 서버 디스크에 저장(`public/user/uploads/...`)
  - 관리자 업로드(맵/이미지): 서버 디스크에 저장(`public/admin/uploads/...`)
- DB:
  - 테이블: `dc_*` (예: `dc_points`, `dc_uploads`, `dc_metas` 등)
  - 스키마 참고: `teamcoperation/ref/create_tables_only.sql`
  - 점수는 team row에 카테고리 컬럼으로 누적(`useable`, `puzzle`, `eniac` 등)

### 2.2 v1에서 v2로 바꿀 때 핵심 변경점
- v1 “업로드 → 서버 저장 → admin이 점수 지급” 흐름은 유지하되,
  - 업로드 저장 위치만 **S3 direct upload**로 변경
- v1 “구역 오픈(openBox)”은 v2에서 “블럭 구매(purchase tile)”로 치환
  - v2는 “cost(머니 소모)”와 “reward(리워드 적립)”이 분리됨
- v1은 팀 단위 점수 중심이지만, v2는 “교육생 미션”이 중심이므로
  - **머니를 개인 지갑으로 할지(추천)**, 팀 지갑으로 할지 결정이 필요(아래 4.2 참고)

---

## 3. v2 전체 아키텍처

### 3.1 구성요소
- **API 서버 (Bun + TypeScript)**
  - REST API + WebSocket(지도 업데이트, 잔액/리워드 업데이트)
  - 세션/권한(유저/관리자)
  - MySQL 트랜잭션 기반 “미션 승인(머니 지급)” + “땅 구매(머니 차감/리워드 적립)” 로직
  - S3 presign 발급 + 업로드 완료 검증(HeadObject)
- **DB (MySQL 8.4)**
  - 원장/이력 기반: 돈/리워드/땅 이벤트/미션 리뷰를 “기록”으로 남김
- **Object Storage (AWS S3)**
  - 이미지/영상 저장(서버 디스크 0)
  - 미디어 공개: 권장 = CloudFront(OAC)로 공개 URL 제공
- **Frontend**
  - Mobile Web App: 땅따먹기 + 미션 업로드/제출
  - Admin Web App: 미션 검수/머니 지급 + 맵 크기 설정 + 랭킹/현황

### 3.2 리포지토리 구조(추천: 새 v2는 별도 폴더에서 시작)
`teamcoperation/`은 v1 레거시로 유지하고, v2는 새 루트에서 시작하는 편이 안전합니다.

권장:
- v1: `teamcoperation/` (현재 운영/참고용)
- v2: `teamcoperation-renewal/` (새 코드 + 새 DB + 새 배포)

#### v2 모노레포(추천)
```text
teamcoperation-renewal/
  apps/
    api/                 # Bun + TS
      src/
        main.ts
        env.ts
        http/
          router.ts
          middleware/
            auth.ts
            requireAdmin.ts
          routes/
            auth.ts
            uploads.ts
            media.ts
            missions.ts
            balances.ts
            territory.ts
            admin.ts
        ws/
          index.ts
          channels.ts
        db/
          client.ts
          migrations/
          repos/
          services/
    web/                 # Mobile web app (player)
      src/
        app/
        routes/
        features/
          territory/
          missions/
          uploads/
          scoreboard/
        api/              # TanStack Query hooks
        state/            # Zustand stores (UI)
        ui/
    admin/               # Admin web app
      src/
        app/
        routes/
        features/
          dashboard/
          missions/
          territory/
          balances/
          teams/
          media/
        api/
        state/
        ui/               # `teamrace/client/admin/src` 스타일 참고
  packages/
    contracts/
      src/
        schemas/          # zod schemas (req/res)
        types.ts
  docker/
    compose.yml
  README.md
```

---

## 4. 핵심 도메인 모델(머니/리워드/미션/땅)

### 4.1 용어
- **머니(cash)**: 사용 가능한 돈. 미션 검수로 지급되며, 블럭 구매에 소모됨.
- **리워드(reward)**: 순위 집계용 포인트. 블럭 구매 시 적립됨(기본적으로 소모되지 않음).
- **미션 제출(submission)**: 유저가 업로드한 미디어를 특정 미션으로 “제출”한 기록.
- **땅(블럭) 구매(purchase)**: (mapId, x, y) 타일을 구매하여 팀 소유로 만드는 행위.

### 4.2 “머니의 소유 단위” (중요 결정)
요구사항 표현이 “자신의 점수” + “교육생 미션”이므로 v2에서는 기본적으로 **개인 지갑(유저 cash)**을 추천합니다.

- 안 A: 팀 지갑(팀 공용 머니)
  - 장점: 가장 단순(팀별 1개 잔액)
  - 단점: 교육생 개인 기여/동기부여가 약해질 수 있음
- 안 B: 개인 지갑(유저 cash) + 팀 리워드(팀 랭킹)
  - 장점: “교육생 미션 → 개인 보상(머니) → 팀 게임 기여(땅 구매로 리워드)” 흐름이 명확
  - 단점: 잔액 테이블/조회가 조금 더 복잡

본 문서의 기본 설계는 **안 B를 우선**으로 작성하되, 안 A로도 전환 가능한 구조(컬럼/쿼리)를 제안합니다.

---

## 5. 미디어 업로드: S3 Direct Upload(서버 디스크 0)

### 5.1 플로우(핵심)
1) 클라이언트 → 서버: `POST /api/uploads/presign` (업로드 세션 생성 + presigned POST 발급)
2) 클라이언트 → S3: presigned로 직접 업로드(진행률 표시 가능)
3) 클라이언트 → 서버: `POST /api/uploads/complete` (업로드 완료 알림)
4) 서버: S3 `HeadObject`로 검증 후 `media` 레코드 생성 → `mediaId/publicUrl` 반환
5) (선택) 클라이언트 → 서버: 미션 제출 API에 `mediaId` 전달

### 5.2 용량 정책(“동영상은 최저화질”의 현실적 강제)
- 브라우저가 촬영 품질을 완전 강제하기는 어렵습니다.
- 따라서 **용량 제한**을 강하게 두는 것이 가장 확실합니다.
  - 이미지: 예) 최대 10MB
  - 영상: 예) 최대 50MB (최저화질 촬영 전제)
- 통제 수단 3종 세트(권장):
  - (1) 클라이언트 업로드 전 크기 검사(초과면 업로드 차단 + 안내)
  - (2) presigned POST 정책의 `content-length-range`로 S3 단 차단
  - (3) UI 안내(“480p/최저화질, Wi‑Fi 권장, 최대 50MB”)

### 5.3 공개 노출(미디어는 모두에게 노출)
권장: **S3 private + CloudFront(OAC) + 공개 URL**
- 버킷은 비공개로 유지하면서도, 결과물 URL은 누구나 접근 가능
- 운영상 실수/사고(버킷 정책/ACL) 가능성을 줄임

---

## 6. DB 설계(MySQL 8.4) — v2 스키마 제안

### 6.1 원칙
- charset/collation: `utf8mb4` / `utf8mb4_unicode_520_ci`
- 모든 핵심 변경(돈/리워드/구매/검수)은 **이력 테이블(ledger/event)** 로 남김
- “현재 값”은 캐시 테이블로 관리(조회/랭킹 성능)
- 모든 핵심 액션은 트랜잭션으로 묶음

> 아래 테이블 prefix는 `tc_`(teamcoperation v2)로 제안합니다.  
> v1(`dc_*`)과 충돌 없이 병행 운영하기 쉽게 만들기 위함입니다.

### 6.2 계정/세션/팀

#### (1) 관리자: `tc_admin_users`
```sql
CREATE TABLE tc_admin_users (
  admin_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(64) NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  role VARCHAR(16) NOT NULL DEFAULT 'admin', -- admin|assist
  display_name VARCHAR(64) NULL,
  created_at TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  updated_at TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  last_login_at TIMESTAMP(3) NULL,
  UNIQUE KEY uniq_admin_username (username),
  CHECK (role IN ('admin', 'assist'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
```

#### (2) 이벤트(행사): `tc_events`
```sql
CREATE TABLE tc_events (
  event_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  slug VARCHAR(64) NOT NULL,
  name VARCHAR(128) NOT NULL,
  status VARCHAR(16) NOT NULL DEFAULT 'draft', -- draft|running|ended
  active_territory_map_id BIGINT UNSIGNED NULL,
  config_json JSON NULL,
  created_at TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  updated_at TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  UNIQUE KEY uniq_event_slug (slug),
  KEY idx_event_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
```

#### (3) 팀: `tc_teams`
```sql
CREATE TABLE tc_teams (
  team_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  event_id BIGINT UNSIGNED NOT NULL,
  team_no INT NOT NULL, -- 1..N (현장 운영 편의)
  name VARCHAR(64) NOT NULL,
  color VARCHAR(16) NULL, -- 예: #RRGGBB
  join_code VARCHAR(16) NOT NULL,
  created_at TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  updated_at TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  UNIQUE KEY uniq_team_no (event_id, team_no),
  UNIQUE KEY uniq_team_join_code (event_id, join_code),
  KEY idx_team_event (event_id),
  CONSTRAINT fk_team_event FOREIGN KEY (event_id) REFERENCES tc_events(event_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
```

#### (4) 유저(교육생): `tc_users`
```sql
CREATE TABLE tc_users (
  user_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  event_id BIGINT UNSIGNED NOT NULL,
  team_id BIGINT UNSIGNED NOT NULL,
  nickname VARCHAR(64) NOT NULL,
  created_at TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  updated_at TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  last_seen_at TIMESTAMP(3) NULL,
  UNIQUE KEY uniq_user_nickname_in_team (event_id, team_id, nickname),
  KEY idx_user_team (event_id, team_id),
  CONSTRAINT fk_user_event FOREIGN KEY (event_id) REFERENCES tc_events(event_id),
  CONSTRAINT fk_user_team FOREIGN KEY (team_id) REFERENCES tc_teams(team_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
```

#### (5) 세션: `tc_sessions`
```sql
CREATE TABLE tc_sessions (
  token CHAR(36) NOT NULL PRIMARY KEY,
  role VARCHAR(16) NOT NULL, -- admin|user
  admin_id BIGINT UNSIGNED NULL,
  user_id BIGINT UNSIGNED NULL,
  created_at TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  expires_at TIMESTAMP(3) NOT NULL,
  last_used_at TIMESTAMP(3) NULL,
  KEY idx_session_expires (expires_at),
  KEY idx_session_user (role, user_id),
  CONSTRAINT fk_session_admin FOREIGN KEY (admin_id) REFERENCES tc_admin_users(admin_id),
  CONSTRAINT fk_session_user FOREIGN KEY (user_id) REFERENCES tc_users(user_id),
  CHECK (role IN ('admin', 'user'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
```

---

### 6.3 미디어/업로드

#### (6) 업로드 세션: `tc_upload_sessions`
```sql
CREATE TABLE tc_upload_sessions (
  upload_id CHAR(36) NOT NULL PRIMARY KEY,
  event_id BIGINT UNSIGNED NOT NULL,
  team_id BIGINT UNSIGNED NOT NULL,
  user_id BIGINT UNSIGNED NOT NULL,
  purpose VARCHAR(32) NOT NULL, -- mission
  kind VARCHAR(16) NOT NULL,    -- image|video
  original_filename VARCHAR(255) NULL,
  content_type VARCHAR(128) NOT NULL,
  size_bytes BIGINT UNSIGNED NOT NULL,
  s3_bucket VARCHAR(63) NOT NULL,
  s3_key VARCHAR(1024) NOT NULL,
  status VARCHAR(16) NOT NULL DEFAULT 'created', -- created|completed|expired
  expires_at TIMESTAMP(3) NOT NULL,
  created_at TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  completed_at TIMESTAMP(3) NULL,
  media_id BIGINT UNSIGNED NULL,
  UNIQUE KEY uniq_upload_s3_key (s3_bucket, s3_key),
  KEY idx_upload_status_exp (status, expires_at),
  KEY idx_upload_team_time (event_id, team_id, created_at),
  CONSTRAINT fk_upload_event FOREIGN KEY (event_id) REFERENCES tc_events(event_id),
  CONSTRAINT fk_upload_team FOREIGN KEY (team_id) REFERENCES tc_teams(team_id),
  CONSTRAINT fk_upload_user FOREIGN KEY (user_id) REFERENCES tc_users(user_id),
  CHECK (purpose IN ('mission')),
  CHECK (kind IN ('image', 'video'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
```

#### (7) 미디어: `tc_media`
```sql
CREATE TABLE tc_media (
  media_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  event_id BIGINT UNSIGNED NOT NULL,
  team_id BIGINT UNSIGNED NOT NULL,
  user_id BIGINT UNSIGNED NOT NULL,
  kind VARCHAR(16) NOT NULL, -- image|video
  content_type VARCHAR(128) NOT NULL,
  size_bytes BIGINT UNSIGNED NOT NULL,
  s3_bucket VARCHAR(63) NOT NULL,
  s3_key VARCHAR(1024) NOT NULL,
  public_url VARCHAR(1024) NOT NULL,
  width INT NULL,
  height INT NULL,
  duration_ms INT NULL,
  created_at TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  status VARCHAR(16) NOT NULL DEFAULT 'active', -- active|deleted
  UNIQUE KEY uniq_media_s3_key (s3_bucket, s3_key),
  KEY idx_media_team_time (event_id, team_id, created_at),
  CONSTRAINT fk_media_event FOREIGN KEY (event_id) REFERENCES tc_events(event_id),
  CONSTRAINT fk_media_team FOREIGN KEY (team_id) REFERENCES tc_teams(team_id),
  CONSTRAINT fk_media_user FOREIGN KEY (user_id) REFERENCES tc_users(user_id),
  CHECK (kind IN ('image', 'video')),
  CHECK (status IN ('active', 'deleted'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
```

---

### 6.4 미션(제출/검수/머니 지급)

#### (8) 미션: `tc_missions`
```sql
CREATE TABLE tc_missions (
  mission_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  event_id BIGINT UNSIGNED NOT NULL,
  title VARCHAR(128) NOT NULL,
  description TEXT NULL,
  required_media_kind VARCHAR(16) NOT NULL, -- image|video
  cash_default INT NOT NULL DEFAULT 0,
  requires_approval TINYINT(1) NOT NULL DEFAULT 1,
  starts_at TIMESTAMP(3) NULL,
  ends_at TIMESTAMP(3) NULL,
  created_at TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  updated_at TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  KEY idx_mission_event (event_id),
  CONSTRAINT fk_mission_event FOREIGN KEY (event_id) REFERENCES tc_events(event_id),
  CHECK (required_media_kind IN ('image', 'video')),
  CHECK (cash_default >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
```

#### (9) 미션 제출물: `tc_mission_submissions`
```sql
CREATE TABLE tc_mission_submissions (
  submission_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  mission_id BIGINT UNSIGNED NOT NULL,
  event_id BIGINT UNSIGNED NOT NULL,
  team_id BIGINT UNSIGNED NOT NULL,
  user_id BIGINT UNSIGNED NOT NULL,
  media_id BIGINT UNSIGNED NOT NULL,
  status VARCHAR(16) NOT NULL DEFAULT 'pending', -- pending|approved|rejected
  submitted_at TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  reviewed_at TIMESTAMP(3) NULL,
  reviewer_admin_id BIGINT UNSIGNED NULL,
  cash_awarded INT NULL,
  note VARCHAR(255) NULL,
  KEY idx_submission_status_time (event_id, status, submitted_at),
  KEY idx_submission_team_time (event_id, team_id, submitted_at),
  CONSTRAINT fk_sub_mission FOREIGN KEY (mission_id) REFERENCES tc_missions(mission_id),
  CONSTRAINT fk_sub_event FOREIGN KEY (event_id) REFERENCES tc_events(event_id),
  CONSTRAINT fk_sub_team FOREIGN KEY (team_id) REFERENCES tc_teams(team_id),
  CONSTRAINT fk_sub_user FOREIGN KEY (user_id) REFERENCES tc_users(user_id),
  CONSTRAINT fk_sub_media FOREIGN KEY (media_id) REFERENCES tc_media(media_id),
  CONSTRAINT fk_sub_admin FOREIGN KEY (reviewer_admin_id) REFERENCES tc_admin_users(admin_id),
  CHECK (status IN ('pending', 'approved', 'rejected')),
  CHECK (cash_awarded IS NULL OR cash_awarded >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
```

---

### 6.5 잔액/리워드(원장 + 캐시)

#### (10) 팀 리워드 캐시: `tc_team_balances`
```sql
CREATE TABLE tc_team_balances (
  event_id BIGINT UNSIGNED NOT NULL,
  team_id BIGINT UNSIGNED NOT NULL,
  reward_total INT NOT NULL DEFAULT 0,
  updated_at TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (event_id, team_id),
  CONSTRAINT fk_tb_event FOREIGN KEY (event_id) REFERENCES tc_events(event_id),
  CONSTRAINT fk_tb_team FOREIGN KEY (team_id) REFERENCES tc_teams(team_id),
  CHECK (reward_total >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
```

#### (11) (안 B) 유저 머니 캐시: `tc_user_balances`
```sql
CREATE TABLE tc_user_balances (
  event_id BIGINT UNSIGNED NOT NULL,
  user_id BIGINT UNSIGNED NOT NULL,
  cash_balance INT NOT NULL DEFAULT 0,
  updated_at TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (event_id, user_id),
  CONSTRAINT fk_ub_event FOREIGN KEY (event_id) REFERENCES tc_events(event_id),
  CONSTRAINT fk_ub_user FOREIGN KEY (user_id) REFERENCES tc_users(user_id),
  CHECK (cash_balance >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
```

#### (12) 잔액 원장: `tc_balance_transactions`
```sql
CREATE TABLE tc_balance_transactions (
  tx_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  event_id BIGINT UNSIGNED NOT NULL,
  team_id BIGINT UNSIGNED NOT NULL,
  user_id BIGINT UNSIGNED NULL,
  asset VARCHAR(16) NOT NULL,   -- cash|reward
  delta INT NOT NULL,
  source_type VARCHAR(32) NOT NULL, -- mission_submission|territory_event|manual
  source_id BIGINT UNSIGNED NULL,
  created_by_admin_id BIGINT UNSIGNED NULL,
  created_at TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  reason VARCHAR(255) NULL,
  UNIQUE KEY uniq_tx_source_asset (source_type, source_id, asset),
  KEY idx_tx_team_time (event_id, team_id, created_at),
  KEY idx_tx_user_time (event_id, user_id, created_at),
  CONSTRAINT fk_tx_event FOREIGN KEY (event_id) REFERENCES tc_events(event_id),
  CONSTRAINT fk_tx_team FOREIGN KEY (team_id) REFERENCES tc_teams(team_id),
  CONSTRAINT fk_tx_user FOREIGN KEY (user_id) REFERENCES tc_users(user_id),
  CONSTRAINT fk_tx_admin FOREIGN KEY (created_by_admin_id) REFERENCES tc_admin_users(admin_id),
  CHECK (asset IN ('cash', 'reward'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
```

> idempotency(중복 지급 방지):
> - 미션 승인/땅 구매는 각각 `source_type/source_id`가 고유하므로,
>   `UNIQUE(source_type, source_id, asset)`로 “같은 이벤트의 cash/reward 중복 반영”을 DB가 막습니다.

---

### 6.6 땅따먹기(맵/타일/구매 이벤트)

#### (13) 맵: `tc_territory_maps`
```sql
CREATE TABLE tc_territory_maps (
  map_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  event_id BIGINT UNSIGNED NOT NULL,
  name VARCHAR(64) NOT NULL,
  width INT NOT NULL,
  height INT NOT NULL,
  default_cost_cash INT NOT NULL DEFAULT 1,
  default_reward_points INT NOT NULL DEFAULT 1,
  created_at TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  updated_at TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  UNIQUE KEY uniq_map_name (event_id, name),
  KEY idx_map_event (event_id),
  CONSTRAINT fk_map_event FOREIGN KEY (event_id) REFERENCES tc_events(event_id),
  CHECK (width > 0),
  CHECK (height > 0),
  CHECK (default_cost_cash >= 0),
  CHECK (default_reward_points >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
```

#### (14) 타일(현재 상태): `tc_territory_cells`
```sql
CREATE TABLE tc_territory_cells (
  map_id BIGINT UNSIGNED NOT NULL,
  x INT NOT NULL,
  y INT NOT NULL,
  cost_cash INT NOT NULL,
  reward_points INT NOT NULL,
  owner_team_id BIGINT UNSIGNED NULL,
  last_purchased_at TIMESTAMP(3) NULL,
  last_event_id BIGINT UNSIGNED NULL,
  updated_at TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (map_id, x, y),
  KEY idx_cell_owner (map_id, owner_team_id),
  KEY idx_cell_updated (map_id, updated_at),
  CONSTRAINT fk_cell_map FOREIGN KEY (map_id) REFERENCES tc_territory_maps(map_id),
  CONSTRAINT fk_cell_owner FOREIGN KEY (owner_team_id) REFERENCES tc_teams(team_id),
  CHECK (cost_cash >= 0),
  CHECK (reward_points >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
```

#### (15) 구매 이벤트(이력): `tc_territory_events`
```sql
CREATE TABLE tc_territory_events (
  territory_event_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  event_id BIGINT UNSIGNED NOT NULL,
  map_id BIGINT UNSIGNED NOT NULL,
  x INT NOT NULL,
  y INT NOT NULL,
  request_id CHAR(36) NULL,
  action VARCHAR(16) NOT NULL, -- purchase|reset|admin_set
  from_team_id BIGINT UNSIGNED NULL,
  to_team_id BIGINT UNSIGNED NULL,
  user_id BIGINT UNSIGNED NULL,
  admin_id BIGINT UNSIGNED NULL,
  cost_cash INT NOT NULL DEFAULT 0,
  reward_points INT NOT NULL DEFAULT 0,
  created_at TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  UNIQUE KEY uniq_territory_request (event_id, request_id),
  KEY idx_territory_event_time (event_id, created_at),
  KEY idx_territory_cell_time (map_id, x, y, created_at),
  CONSTRAINT fk_te_event FOREIGN KEY (event_id) REFERENCES tc_events(event_id),
  CONSTRAINT fk_te_map FOREIGN KEY (map_id) REFERENCES tc_territory_maps(map_id),
  CONSTRAINT fk_te_user FOREIGN KEY (user_id) REFERENCES tc_users(user_id),
  CONSTRAINT fk_te_admin FOREIGN KEY (admin_id) REFERENCES tc_admin_users(admin_id),
  CHECK (action IN ('purchase', 'reset', 'admin_set')),
  CHECK (cost_cash >= 0),
  CHECK (reward_points >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
```

---

## 7. 트랜잭션 설계(정합성의 핵심)

### 7.1 미션 승인(머니 지급)
승인 시 한 트랜잭션에서:
1) `tc_mission_submissions`를 `approved`로 업데이트(+ `cash_awarded`, `reviewed_at`, `reviewer_admin_id`)
2) `tc_balance_transactions`에 `asset='cash', delta=+cash_awarded, source_type='mission_submission'` 삽입
3) (안 B) `tc_user_balances.cash_balance += cash_awarded` 갱신  
   (안 A면 team balance에 반영)

중복 승인 방지:
- `tc_balance_transactions.UNIQUE(source_type, source_id, asset)`로 “같은 submission이 두 번 cash 지급”되는 것을 차단

### 7.2 타일 구매(머니 소모 + 리워드 적립 + 팀색 변경)
구매 요청: `POST /api/territory/purchase { requestId, mapId, x, y }`

한 트랜잭션에서:
1) `tc_user_balances`(또는 team cash)를 `SELECT ... FOR UPDATE`로 잠금
2) `tc_territory_cells`를 `SELECT ... FOR UPDATE`로 잠금
3) 잔액 체크: `cash_balance >= cost_cash`
4) 이미 우리팀이면 실패(권장) / 상대팀이면 구매 가능(뒤집기)
5) `tc_territory_cells.owner_team_id` 변경(팀색 변경)
6) `tc_territory_events` 삽입(request_id 포함)
7) 잔액/원장 반영
   - `tc_balance_transactions`에
     - cash: `delta=-cost_cash`, `source_type='territory_event'`, `source_id=territory_event_id`
     - reward: `delta=+reward_points` (팀 리워드)
8) 캐시 테이블 갱신
   - user cash 감소
   - team reward 증가

중복 클릭/재시도 방지:
- `tc_territory_events.UNIQUE(event_id, request_id)`로 동일 request를 차단

---

## 8. API 설계(초안)

### 8.1 Auth
- `POST /api/auth/join` (join_code + nickname → user 세션 발급)
- `POST /api/auth/admin/login`
- `POST /api/auth/logout`
- `GET /api/session`

### 8.2 Uploads / Media
- `POST /api/uploads/presign`
- `POST /api/uploads/complete`
- `GET /api/media/:mediaId` (public_url 제공)

### 8.3 Missions
- `GET /api/missions`
- `POST /api/missions/:missionId/submissions` (body: `{ mediaId }`)
- `GET /api/me/submissions`
- `GET /api/admin/missions/submissions?status=pending`
- `POST /api/admin/missions/submissions/:submissionId/review`
  - body: `{ status: "approved"|"rejected", cashAwarded: number, note?: string }`

### 8.4 Territory
- `GET /api/territory/map` (active map + width/height + 기본 cost/reward)
- `GET /api/territory/cells?mapId=...` (ownerTeamIds를 “압축 배열”로 제공 권장)
- `POST /api/territory/purchase`
- `PUT /api/admin/territory/map` (맵 생성/리셋 + 크기/기본값 설정)

### 8.5 Balances / Scoreboard
- `GET /api/scoreboard` (팀별 reward_total + (선택) 팀 머니 합계)
- `GET /api/me/balance` (내 머니 + 내 팀 리워드)
- `GET /api/admin/balances/ledger?asset=cash|reward&teamId=&userId=&cursor=`
- `POST /api/admin/balances/adjust` (운영 수동 조정)

---

## 9. 모바일 웹앱(땅따먹기) 렌더링 전략

### 9.1 성능 목표
- 관리자 설정으로 맵이 커져도 휴대폰에서 버벅이지 않게
- 네트워크 사용량을 최소화

### 9.2 데이터 표현(권장)
- 타일의 핵심 상태는 `ownerTeamId`만으로 충분
- 프론트는 `Uint16Array(width*height)` 같은 1차원 배열로 유지(메모리/렌더링 효율)
- 서버 응답도 가능하면:
  - `{ width, height, ownerTeamIdsBase64 }` 형태로 전달(옵션)

### 9.3 렌더링 방식(권장)
- `<= 50x50`: DOM grid도 가능(2,500 div)
- 그 이상: canvas 렌더링 권장
  - 초기 스냅샷: 전체 draw
  - WS diff: 변경 타일만 부분 draw

### 9.4 UX(터치/실수 방지)
- 상단 sticky bar: 내 머니 / 팀 리워드 표시
- 구매 UX:
  - 1탭: 선택(가격/리워드 표시)
  - 2탭(또는 버튼): 구매 확정
  - “즉시 구매 모드”는 운영 설정으로 제공 가능

---

## 10. 관리자 페이지(구성 제안)

참고 디자인: `teamrace/client/admin/src`의 스타일(상단 sticky + 좌측 메뉴 + 카드 UI + Toast/Confirm)을 v2 admin에 적용

### 10.1 관리자 메뉴(추천 IA)
- Dashboard
  - 팀 리워드 랭킹
  - 팀별 머니 현황(안 B면 “팀 머니 합계”는 참고 지표)
  - 최근 땅 구매 이벤트, 최근 미션 승인/반려
- Missions(핵심)
  - pending 제출물 큐(이미지/영상 미리보기)
  - 승인/반려 + 지급 머니 입력
- Territory
  - 맵 생성/리셋(크기, 기본 cost/reward)
  - 현재 맵 미리보기(그리드/캔버스)
- Balances
  - 원장 조회(cash/reward)
  - 수동 조정(운영)
- Teams
  - 팀 생성/색상/번호/join_code 관리
- Media(선택)
  - 전체 미디어 모음(공개 노출이면 사실상 “갤러리” 역할 가능)

---

## 11. 보안/운영 체크리스트(필수)

### 11.1 서버 보안
- CORS: v1처럼 `*` 금지(운영 도메인만 허용)
- 세션 쿠키:
  - `HttpOnly`, `Secure`, `SameSite=Lax`
  - 프록시 뒤면 `trust proxy` 설정
- rate limit:
  - 타일 구매 API(스팸/자동화 방지)
  - 업로드 presign API(남용 방지)

### 11.2 데이터 감사/복구
- “돈/리워드”는 반드시 원장 기반 → 캐시 재계산 가능
- 운영상 필요하면 감사 로그 테이블 추가(`audit_logs`)

---

## 12. 단계별 실행 계획(현실적인 로드맵)

### Phase 1 — 기반 구축
- v2 모노레포 스캐폴딩(Bun/TS/Vite)
- MySQL 8.4 + 마이그레이션
- 기본 Auth(유저 join, admin login)
- S3 presign/complete + media 등록

### Phase 2 — 미션 MVP(핵심: 관리자 검수 → 머니 지급)
- 미션 목록/제출
- admin 검수 큐 UI
- 승인 시 user cash 반영 + 원장 기록

### Phase 3 — 땅따먹기 MVP(모바일)
- admin 맵 생성/리셋(크기/기본값)
- 유저 맵 렌더링(성능 기준에 따라 DOM→canvas 선택)
- 구매 트랜잭션(머니 차감/리워드 적립/팀색 변경)
- WS diff 적용

### Phase 4 — 스코어보드/운영 고도화
- 리워드 랭킹(대시보드)
- 원장/수동 조정
- 데이터 복구(원장 → 캐시 재계산) 툴

---

## 13. 남은 질문(확정되면 설계가 더 단단해짐)
1) 머니는 **개인 지갑(추천)** 으로 갈까요, 팀 지갑으로 갈까요?
2) 맵 크기 최대치(모바일 성능 기준)를 어디까지로 할까요? (예: max 50x50 / 80x80)
3) 기본값:
   - `default_cost_cash`(블럭 1개 가격)
   - `default_reward_points`(블럭 1개 리워드)
   를 어떤 수준으로 시작할까요?
4) 영상 업로드 최대 용량(MB) 확정(문서 기본안: 50MB)

