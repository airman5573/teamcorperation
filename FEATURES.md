# Teamcoperation (Discovery) 기능 정리 — 현행(v1 기준)

이 문서는 `/teamcoperation` 폴더의 **현재 구현(서버 + 클라이언트)** 을 기반으로, 리뉴얼을 위한 **기능/화면/API/DB 규칙**을 최대한 빠짐없이 정리한 것입니다.

- 서버 엔트리: `teamcoperation/src/index.js`
- 주요 라우트: `teamcoperation/src/*/*Route.js`
- DB 쿼리/규칙: `teamcoperation/src/query.js`, `teamcoperation/src/wh-query.js`
- DB 스키마 참고: `teamcoperation/ref/create_tables_only.sql`

---

## 1) 시스템 개요

### 1.1 목적(사용 시나리오)
팀(1..N)이 **포인트를 벌고/사용**하며 아래 활동을 수행하는 이벤트/게임 운영 시스템입니다.

- **업로드 미션 수행**(사진/영상 업로드) → 포인트 지급/검수/다운로드
- **구역(퍼즐 보드) 점유**(박스 오픈) → 구역점유/구역연결(빙고) 점수 누적
- **문장해독(ENIAC)** → 정답 제출 시 순위에 따라 점수 지급
- **타이머 기반**으로 미션 제한 시간 운영 + 성공/실패에 따라 임시점수/임시업로드 처리

### 1.2 구성 요소(Backend/Frontend)
- Backend: Node.js + Express
  - CORS: `app.use(cors())` (전면 허용)
  - Session: `express-session` + `express-mysql-session` (테이블 `dc_sessions`)
  - Static: `app.use(express.static('public'))` 로 `teamcoperation/public` 서빙
  - Realtime: Socket.IO (퍼즐 박스 오픈 실시간 반영)
- Frontend: React 기반 “클라이언트 앱”이 역할별로 분리되어 있음
  - Entrance: `src/entrance/entrance-client`
  - Admin: `src/admin/admin-client`
  - User: `src/user/user-client`
  - Assist: `src/assist/assist-client`
  - Warehouse: `src/warehouse/warehouse-client`
  - Media files: `src/media-files/media-files-client`

### 1.3 역할(Role) 개념
로그인 후 세션에 `req.session.loginData = { role, success, team? }` 가 저장됩니다.

- `admin`: 관리자(운영 총괄)
- `assist`: 보조관리자(본부점수 제공/모니터링 성격)
- `user`: 팀 사용자(팀 번호(team) 보유)

---

## 2) 화면/페이지(클라이언트) 구성

### 2.1 Entrance (로그인)
- URL: `/`
- 기능
  - 회사 이미지(배경) 표시: `/entrance/companyImage`에서 가져온 `companyImage`
  - 비밀번호 로그인: `/entrance/login`
  - 성공 시 role에 따라 이동
    - admin → `/admin`
    - assist → `/assist/page/map`
    - user → `/user/page/map`

### 2.2 Admin (관리자)
- URL: `/admin`
- 주요 UI 구성
  - 좌측 메뉴 + 모달(설정/운영 기능 대부분이 모달로 동작)
  - 메인 보드(업로드 자료 불러오기/개별 파일 검수 포인트 지급/외부 페이지 링크)

#### Admin 메뉴(모달) 목록
`src/admin/admin-client/components/main-menu.js` 기준:

1. 팀설정
2. 타이머
3. 이미지설정
4. 구역설정
5. 구역점유현황
6. 본부 점수 제공
7. 최종결과
8. 점수배정표
9. 포스트 정보
10. 아이콘 설정
11. 관리자 비밀번호
12. 초기화

#### Admin 메인 보드 기능
`src/admin/admin-client/components/main-board.js` 기준:

- “업로드자료 불러오기” 버튼: 팀별 업로드 파일 목록(검수 큐) 로딩
- 파일별 검수/포인트 지급
  - 이미지/영상 미리보기 + 점수 입력 후 지급
  - 지급 후 해당 파일은 “검수 큐”에서 제거됨(DB에서 `uploads.files`에서 제거)
- “미션정보창고” 링크: `/warehouse` (새 탭)
- “업로드자료모음” 링크: `/media-files` (새 탭)

### 2.3 User (팀 사용자)
- URL: `/user/page/*` (미로그인 시 `/`로 리다이렉트)
- 하단 네비게이션(아이콘) + 페이지 라우팅
  - 지도(`/user/page/map`)
  - 포인트(`/user/page/point`) — 표시 여부는 설정에 따라 숨김 가능
  - 구역(`/user/page/puzzle`) — 표시 여부는 설정에 따라 숨김 가능
  - 업로드(`/user/page/upload`)
  - 포스트(`/user/page/post-info`)

#### User 페이지별 기능 요약
- 지도(Map)
  - 관리자 업로드 지도 이미지 표시(없으면 NotReady)
- 포인트(Point)
  - 팀별 “가용점수(useable)” 차트 표시
  - 우리 팀 강조 표시
- 구역(Puzzle)
  - 퍼즐 박스 UI (구역 점유)
  - 실시간 업데이트(다른 팀이 박스 오픈 시 애니메이션 반영)
  - “문장해독(ENIAC)” 모달(설정되어 있을 때만)
  - “최종구역(Last box)” 오픈(공개 상태일 때만)
- 업로드(Upload)
  - 사진/영상 업로드(형식/용량 제한, 업로드 간격 제한, 타이머 제한)
  - 업로드 미리보기(이미지/영상)
  - 업로드 진행률 표시
- 포스트(Post info)
  - 포스트별 미션/영상 URL 리스트(새 탭 이동)

### 2.4 Assist (보조관리자)
- URL: `/assist/page/*` (미로그인 시 `/`로 리다이렉트)
- 하단 네비게이션(5개 고정, 단 puzzle은 puzzleBoxCount>0일 때만 표시)
  - 지도(`/assist/page/map`)
  - 포인트(`/assist/page/point`) — “본부 점수 제공” 성격(팀별 입력)
  - 구역(`/assist/page/puzzle`) — 점유 현황 조회 성격
  - 진행상황(`/assist/page/result`) — 가용점수 차트
  - 포스트(`/assist/page/post-info`)

---

## 3) 핵심 기능 상세(업무 규칙/로직)

### 3.1 로그인/권한(세션)
#### 로그인 방식
- `/entrance/login`은 입력 비밀번호에 따라 role을 결정
  - 관리자/보조관리자 비밀번호: `dc_metas.adminPasswords`(JSON) 기반
  - 팀 비밀번호: `dc_teamPasswords.password` 기반(숫자)
- 로그인 성공 시 세션(`req.session.loginData`)에 저장

#### 세션 저장소
- MySQL session store 사용
  - 테이블명: `dc_sessions`
  - 설정: `express-mysql-session` (서버 코드에서 tableName 지정)

> 참고: 페이지(`/admin`, `/user/page/*`, `/assist/page/*`, `/warehouse`, `/media-files`)는 role 체크를 하지만, **API 라우트 자체는 role 체크가 없는 경우가 많습니다.** (리뉴얼 시 권한 검증을 API에도 넣는 것이 안전합니다.)

---

### 3.2 팀 설정(Team passwords → 팀 수 결정)
관리자는 팀별 비밀번호를 설정합니다.

- 팀 수(teamCount) 개념
  - `dc_teamPasswords`에서 `password IS NOT NULL and password != 0` 인 row 개수로 계산
  - 실제 UI에서도 placeholder 기반으로 “연속 설정/중복 금지” 검증을 수행

팀설정 모달의 주요 제약(`TeamSettingModal`):
- 비밀번호 중복 금지
- “띄엄띄엄 설정” 금지(예: 3팀 비번이 0인데 4팀이 설정되면 에러)
- 입력이 전부 비어있으면 에러

---

### 3.3 포인트 시스템(카테고리 + 매핑표)
#### 포인트 테이블 구조
`dc_points` 컬럼:
- `useable`: 가용점수(유저가 “구역 오픈”에 사용하는 점수, 유저 포인트 화면은 이 값만 표시)
- `temp`: 임시점수(타이머 성공 시 `useable`로 이동, 실패 시 0으로 리셋되는 성격)
- `timer`: 이동시간 점수(타이머 종료 시 남은/초과 시간에 따라 +/-)
- `puzzle`: 구역점유 점수(구역 오픈 성공 시 적립)
- `bingo`: 구역연결 점수(빙고 라인 성립 시 적립)
- `eniac`: 문장해독 점수(정답 제출 시 순위에 따라 적립)

#### 점수배정표(mappingPoints)
`dc_metas.mappingPoints`에 JSON으로 저장되며, 운영 중 수정 가능합니다.

기본 키:
- `timerPlus`: 남은 시간(+) 30초당 점수
- `timerMinus`: 초과 시간(-) 30초당 점수(초과면 음수로 반영될 수 있음)
- `upload`: 업로드 기본 점수(상황에 따라 0으로 변경될 수 있음)
- `boxOpenUse`: 구역 오픈에 필요한 “사용 점수”
- `boxOpenGetEmpty`: 글자 없는 구역 오픈 시 적립 점수(puzzle 카테고리)
- `boxOpenGetWord`: 글자 있는 구역 오픈 시 적립 점수(puzzle 카테고리)
- `bingo`: 3개 연결(빙고) 라인당 점수
- `eniac`: 문장해독 1등 기본 점수(이후 순위는 서버 로직에서 차감)

---

### 3.4 타이머(랩타임/팀 타이머/임시점수 처리)
#### 랩타임(laptime)
- `dc_metas.laptime`(초 단위)
- 관리자가 변경 가능

#### 팀 타이머(start/stop)
- `dc_timers`에 `state`, `startTime`, `restTime`을 저장
- 관리자 UI는 “전체 시작”만 허용(개별 시작 버튼은 막아둔 상태)

#### 타이머 종료 시 점수/업로드 처리(핵심 규칙)
관리자가 특정 팀의 타이머를 OFF로 바꿀 때:

1. 남은 시간(또는 초과 시간) 계산
   - `td = laptime - (currentTime - startTime)`
2. timer 점수 계산
   - `point = floor(td/30) * (td > 0 ? timerPlus : timerMinus)`
   - `dc_points.timer`에 누적 업데이트
3. 임시 자료/임시 점수 처리
   - `td >= 0` (시간 내 성공)
     - `uploads.temp` → `uploads.files`로 이동
     - `points.temp` → `points.useable`로 이동
   - `td < 0` (시간 초과 실패)
     - `uploads.temp` 제거
     - `points.temp` 제거

> 즉, 타이머는 “임시 보관함(temp)을 통과시키는 게이트” 역할을 하며, 성공하면 반영/실패하면 폐기됩니다.

---

### 3.5 업로드(파일 업로드 + 검수 + 다운로드 트래킹)
#### 지원 파일 형식
`src/utils/file-extensions.js` 기준:
- 이미지: `jpeg`, `jpg`, `png`, `gif`
- 영상: `3gp`, `avi`, `mov`, `mp4`, `mpeg`, `ogg`, `ogv`, `webm`, `wmv`

#### 업로드 제약
- 용량 제한: 약 150MB
  - 서버 multer: `limits.fileSize = 157286400`
  - 클라이언트에서도 150MB 체크(약간의 상이 있음)
- 업로드 간격 제한: 300초(= 5분)
  - `dc_uploads.uploadTime` 기반(초 단위 “시:분:초”를 seconds로 환산하여 저장)
- 타이머 체크 필수
  - 유저 업로드는 항상 `/user/timer-check`를 먼저 수행

#### 저장 경로/파일명 규칙
- 저장 루트: `teamcoperation/public`
- 유저 업로드 저장 위치:
  - `public/user/uploads/{DCV}/{team}/{YYYY_MM_DD_HH_MM_SS}.{ext}`
- 관리자 업로드(회사 이미지/지도):
  - `public/admin/uploads/{DCV}/companyImage-XX.{ext}`
  - `public/admin/uploads/{DCV}/map-XX.{ext}`

#### 업로드 데이터 구조(3종)
DB 테이블 `dc_uploads`에 다음 3가지 “목록”이 공존합니다.

1. `files`: “검수 큐” (관리자가 불러와서 파일별 점수 지급 후 제거되는 목록)
2. `temp`: 타이머 성공 전 임시 업로드 목록(성공 시 `files`로 이동, 실패 시 제거)
3. `stackFiles`: “전체 업로드 누적 목록 + 다운로드 여부”
   - 배열 원소 형태: `{ filename, downloaded: boolean }`
   - `/media-files` 페이지에서 내려받음 처리(downloaded=true)로 전환

#### 업로드 임시저장(tempBoxState)
- `dc_metas.tempBoxState`로 ON/OFF
- ON일 때의 효과(서버 구현 기준)
  - 업로드 파일명은 `dc_uploads.temp`에 쌓임
  - 업로드 점수는 `dc_points.temp`에 쌓이도록 설계되어 있으나,
  - 동시에 `mappingPoints.upload`를 0으로 세팅하는 로직이 있어(운영 의도에 따라) “업로드 즉시 점수”는 0이 될 수 있음

> 리뉴얼 시에는 “tempBoxState의 목적(점수 즉시 지급 vs 검수 후 지급)”을 다시 정의하고, 이에 맞게 점수/목록 이동 규칙을 단순화하는 것이 좋습니다.

#### 관리자 검수(업로드 자료 불러오기/포인트 지급)
- 관리자는 `/admin/load-upload-infos`로 팀별 `uploads.files`를 가져와서 UI에 표시
- 파일별 점수 입력 후 `/admin/points/upload` 호출
  - `dc_points.useable`에 점수 더함
  - 해당 파일명을 `uploads.files`에서 제거(검수 완료 처리)

#### “업로드자료모음”(다운로드 트래킹)
- `/media-files` 페이지는 `uploads.stackFiles`를 기반으로 모든 팀 업로드를 카드로 표시
- 다운로드/저장 완료를 수동 체크(회색 커튼 클릭)하여 `downloaded=true`로 변경

---

### 3.6 구역(퍼즐) 점유 시스템
#### 퍼즐 박스 개수(puzzleBoxCount)
관리자가 구역 개수를 선택(사용안함 포함):
- 0, 20, 24, 30, 35, 40, 48, 54, 60, 66

퍼즐 UI는 “마지막 1칸”을 **특수 이벤트 박스(last box)** 로 사용하므로,
실제 점유 가능한 박스는 `puzzleBoxCount - 1` 입니다.

#### 박스 점유 규칙(유저 오픈)
유저가 박스를 오픈하면(`/user/openBox`):
1. 다른 팀이 이미 점유한 박스인지 전수 검사(모든 팀의 boxNumbers를 스캔)
2. 가용점수(useable) ≥ boxOpenUse 인지 확인
3. `dc_puzzles.boxNumbers`에 박스 번호 추가
4. 빈 박스/글자 박스에 따라 카운터 증가
   - `emptyBoxOpenCount` 또는 `wordBoxOpenCount`
5. 점수 반영
   - `useable`에서 `boxOpenUse`만큼 차감
   - `puzzle`에 “획득점수” 누적
   - `bingo`에 “연결점수” 누적(해당 시)

#### 구역 연결(빙고) 로직
`src/utils/server.js`의 `checkBingo()` 기준:
- “3개 연속”이 성립하면 1라인 인정
- 4개 이상 연속이면(3라인 인정 후) 취소 처리하는 구조
- 체크 방향: 가로/세로/대각(2방향) 총 4방향
- 새로 오픈한 박스를 기준으로 라인 성립 여부를 계산

#### 실시간 반영(socket.io)
- 유저가 서버에서 박스 오픈 성공 후 소켓 이벤트 발행:
  - 클라이언트 emit: `open_puzzle_box`
  - 서버 broadcast: `puzzle_box_opened`
- 다른 클라이언트는 해당 박스에 “점유 애니메이션/색상”을 반영

---

### 3.7 문장해독(ENIAC)
#### 설정/표시 조건
- 관리자가 “구역 메세지(문장)”를 입력하면:
  - `dc_metas.originalEniacWords`: 원문 문자열
  - `dc_metas.randomEniacWords`: 글자 배열을 0과 섞어 셔플한 JSON
- 유저 퍼즐 페이지에서 `originalEniacWords`가 있으면 “문장해독” 버튼 노출

#### 정답 처리/순위별 점수
`/user/eniac` 동작:
- `dc_metas.eniacState`가 ON(1)이어야 가능
- 이미 맞춘 팀은 재시도 불가(`eniacSuccessTeams`에 기록)
- 등수(rank) = 기존 성공 팀 수 + 1
- 1등 기본점수 `mappingPoints.eniac`에서 등수별 감점
  - 2등: -4000
  - 3등: -7000
  - 4등: -9000
  - 5등: -10000
  - 6등~: -11000 (동일)
- 점수는 `dc_points.eniac`에 누적되고, 성공 팀 목록은 `dc_metas.eniacSuccessTeams`에 저장

---

### 3.8 최종구역(Last box)
- `lastBoxState`가 ON일 때만 오픈 가능(`/user/open-lastbox`)
- 실제 이동 URL은 `lastBoxUrl`(Google Drive 등)

---

### 3.9 포스트 동영상 정보(사용자 노출용)
유저/보조관리자는 “포스트” 페이지에서 미션 영상 링크를 확인합니다.

- 데이터: `dc_postInfos` (post, mission, url)
- 관리: 관리자 UI의 “포스트 정보” 모달에서 CRUD

---

### 3.10 미션정보창고(관리자 전용, 별도 DB 테이블)
`/warehouse` 페이지는 `dc_warehouse` 테이블을 관리합니다.

- UI 타이틀: “포스트 정보 창고”
- 컬럼: mission, url
- 데이터 용도: 운영자 내부 참고/정리 목적(유저 페이지 노출용 `dc_postInfos`와 별개)

---

### 3.11 아이콘 설정(유저 하단 네비게이션)
관리자는 “아이콘 설정”에서 **유저 하단 네비게이션을 3개/5개 모드로 전환**합니다.

- 실제 구현은 2개 메타키를 동시에 제어:
  - `dc_metas.showPointNav`
  - `dc_metas.showPuzzleNav`
- 3개 모드: 포인트/구역 아이콘 숨김 (지도/업로드/포스트만 남음)
- 5개 모드: 포인트/구역 아이콘 표시

---

### 3.12 초기화(Reset)
관리자 “초기화” 기능은 다음을 수행합니다.

- DB 초기화(`DCQuery.reset()`)
  - metas/points/puzzles/teamPasswords/timers/postInfos/uploads reset
- 파일 삭제(현재 DCV 기준)
  - `public/admin/uploads/{DCV}` 폴더 제거
  - `public/user/uploads/{DCV}` 폴더 제거

초기화 API는 `resetPassword = 'discovery_reset'`가 필요합니다.

---

## 4) API 목록(현재 구현 기준)

> 주의: 다수 API는 200이 아닌 **201**로 성공 응답합니다(클라이언트 유틸 `simpleAxios`가 201만 성공으로 봄).

### 4.1 Entrance
- `GET /`
  - Entrance HTML 반환(쿼리 `message` 지원)
- `GET /entrance/companyImage`
  - 응답: `{ companyImage }`
- `POST /entrance/login`
  - body: `{ password }`
  - 응답(성공): `{ role: 'admin'|'assist'|'user', success: true, team?: number }`
  - 응답(실패): `{ error: '비밀번호를 다시 확인해 주세요' }`

### 4.2 Admin
- `GET /admin` (role=admin일 때만 페이지 반환)
- `POST /admin/uploads` (multipart: `companyImage`, `map`)
  - 이미지 파일만 허용(jpeg/jpg/png/gif)
  - 저장: `public/admin/uploads/{DCV}/`
  - DB: `dc_metas.companyImage`, `dc_metas.map` 갱신
- `POST /admin/team-settings/passwords`
  - body: `{ teamPasswords: [{team, password}, ...] }`
  - 동작: `dc_teamPasswords` UPSERT
- `POST /admin/timers/laptime`
  - body: `{ laptime }`
- `POST /admin/timers/update-team-timers`
  - body: `{ team, newState, laptime?, mappingPoints?, isAll? }`
  - 동작: 팀 타이머 ON/OFF + (OFF 시) timer 점수/임시점수 이동 처리
- `POST /admin/timers/eniac-state`
  - body: `{ eniacState }`
- `POST /admin/timers/temp-box-state`
  - body: `{ tempBoxState }`
  - 추가 동작: `mappingPoints.upload`를 0 또는 기존값으로 조정, 응답 `{ point }`
- `POST /admin/timers/get-team-timers`
  - body: `{ teamCount }`
  - 응답: `dc_timers` rows
- `POST /admin/puzzle-settings/puzzlebox-count`
  - body: `{ puzzleBoxCount }`
  - 추가 동작: eniac words 초기화
- `POST /admin/puzzle-settings/eniac-words`
  - body: `{ originalEniacWords, randomEniacWords }`
- `POST /admin/puzzle-settings/lastBoxUrl`
  - body: `{ lastBoxUrl }`
- `POST /admin/puzzle-settings/lastbox-state`
  - body: `{ lastBoxState }`
- `POST /admin/points/reward`
  - body: `{ points: [{team, useable?|temp?|...}, ...] }`
  - 동작: `dc_points` 누적 업데이트(여러 건 가능)
- `POST /admin/points/upload`
  - body: `{ team, point, filename }`
  - 동작:
    - `dc_points.useable` += point
    - `dc_uploads.files`에서 filename 제거(검수 완료 처리)
- `POST /admin/admin-passwords/passwords`
  - body: `{ adminPasswords: { admin, assist } }`
  - 동작: `dc_metas.adminPasswords` 갱신(JSON)
- `POST /admin/mapping-points`
  - body: `{ mapping_point: { [key]: value } }`
  - 동작: 기존 mappingPoints JSON에 merge 후 저장
- `POST /admin/result`
  - body: `{ teamCount, puzzleBoxCount }`
  - 응답: 팀별 결과 rows(총점/순위 포함)
- `POST /admin/reset`
  - body: `{ resetPassword }`
- `POST /admin/post-infos/add|edit|remove`
  - `dc_postInfos` CRUD
- `POST /admin/navigation-visibility`
  - body: `{ isVisible: boolean }`
  - 동작: `showPointNav`, `showPuzzleNav` 동시 업데이트
- `POST /admin/load-upload-infos`
  - body: `{ teamCount }`
  - 응답: `{ uploadInfos }` 또는 `{ error }`
- `POST /admin/zip-path`
  - body: `{ team }`
  - 동작: `public/user/uploads/{DCV}/{team}` 폴더를 zip 생성
  - 응답: `{ zipPath }`

### 4.3 User
- `GET /user` → `/user/page/map`로 redirect
- `GET /user/page/*` (role=user일 때만 페이지 반환)
- `GET /user/get-updated-points`
  - 응답: `[{ team, useable }, ...]`
- `POST /user/get-puzzle-colon-infos`
  - body: `{ teamCount }`
  - 응답: `dc_puzzles` rows
- `POST /user/point-check`
  - body: `{ team, boxOpenUse }`
  - 동작: useable ≥ boxOpenUse 확인
- `POST /user/openBox`
  - body: `{ team, teamCount, maxLocation, boxNumber, boxOpenUse, type, puzzlePoint, bingoPointPerLine }`
  - 동작: 박스 점유 + 점수 반영 + 빙고 계산
- `POST /user/eniac`
  - body: `{ team, point }`
  - 동작: 정답 순위 기반 `eniac` 점수 반영
- `POST /user/upload` (multipart: `team`, `tempBoxState`, `userFile`, `point`)
  - 동작: 파일 저장 + uploads/files/temp/stackFiles 갱신 + 점수 반영(useable 또는 temp)
- `POST /user/timer-check`
  - body: `{ team, laptime }`
  - 동작: 타이머 ON 여부 + 남은 시간(td) 체크
- `POST /user/upload-interval-check`
  - body: `{ team }`
  - 동작: 마지막 업로드 후 300초 경과 여부 체크
- `GET /user/open-lastbox`
  - 동작: `lastBoxState` 체크(공개 여부)

### 4.4 Assist
- `GET /assist` → `/assist/page/map`로 redirect
- `GET /assist/page/*` (role=assist일 때만 페이지 반환)
  - 별도 API는 없지만, 클라이언트에서 `/admin/*`, `/user/*` 일부 API를 호출하여 기능 수행

### 4.5 Warehouse
- `GET /warehouse` (role=admin일 때만 페이지 반환)
- `POST /warehouse/post-infos/add|edit|remove`
  - `dc_warehouse` CRUD

### 4.6 Media files
- `GET /media-files` (role=admin일 때만 페이지 반환)
- `POST /media-files/make-stack-file-downloaded`
  - body: `{ team, filename }`
  - 동작: `uploads.stackFiles[].downloaded=true`

---

## 5) 데이터베이스 스키마(요약)

정확한 DDL은 `teamcoperation/ref/create_tables_only.sql` 참고.

### 5.1 테이블 목록
- `dc_metas(id, metaKey, metaValue)`
- `dc_points(team PK, useable, timer, eniac, puzzle, temp, bingo)`
- `dc_postInfos(post PK, mission, url)`
- `dc_puzzles(team PK, boxNumbers, emptyBoxOpenCount, wordBoxOpenCount)`
- `dc_sessions(session_id PK, expires, data)`
- `dc_teamPasswords(team PK, password)`
- `dc_timers(team PK, startTime, state, restTime)`
- `dc_uploads(team PK, files, temp, uploadTime, stackFiles)`
- `dc_warehouse(id PK, mission, url)`

### 5.2 주요 metaKey 목록
코드에서 사용하는 `dc_metas.metaKey`들:
- `mappingPoints`
- `companyImage`
- `map`
- `laptime`
- `puzzleBoxCount`
- `originalEniacWords`
- `randomEniacWords`
- `lastBoxUrl`
- `lastBoxState`
- `adminPasswords`
- `eniacSuccessTeams`
- `eniacState`
- `tempBoxState`
- `showPointNav`
- `showPuzzleNav`

---

## 6) 멀티 인스턴스/버전(DCV) 운영
서버는 환경변수 `DCV`를 통해 일부 경로를 분기합니다.

- 업로드 파일 경로 분리:
  - `public/admin/uploads/{DCV}/...`
  - `public/user/uploads/{DCV}/...`
- pm2 스크립트 예시(`teamcoperation/package.json`)
  - `start-v1` → `NODE_PORT=8081 DCV=v1`
  - `start-v2` → `NODE_PORT=8082 DCV=v2`
  - `start-v3` → `NODE_PORT=8083 DCV=v3`
  - `start-v4` → `NODE_PORT=8084 DCV=v4`

> 주의: 현재 코드 기준으로 DB 테이블은 DCV로 분리되지 않으므로, 여러 DCV를 동시에 띄우면 **DB 상태(점수/타이머/구역)가 공유**됩니다. 동시에 운영하려면 DB 스키마/쿼리 레벨에서 “버전 키(tenant)”를 추가하는 리뉴얼이 필요합니다.

---

## 7) 리뉴얼 시 체크포인트(기능/설계 관점)

### 7.1 기능적으로 반드시 재확인할 포인트
- “업로드 임시저장(tempBoxState)”의 의도
  - 업로드 점수를 즉시 지급할지, 검수 후 지급할지, 타이머 성공 후 지급할지
  - 현재는 `mappingPoints.upload`를 0으로 만들어 즉시점수 0이 될 수 있음
- “업로드 데이터 3종(files/temp/stackFiles)”의 책임 분리
  - 검수 큐 vs 기록/다운로드 큐를 명확히 나누고 UI도 재정의 필요
- 퍼즐(빙고) 규칙
  - “3개 연속만 인정, 4개 이상이면 취소”가 의도인지 확인 필요
- 결과표(최종 점수) 구성
  - 사용자 화면은 useable만 보여주는데, 최종결과는 여러 카테고리를 합산
  - 운영 방식에 맞게 사용자에게 보여줄 지표를 재정의할지 결정 필요

### 7.2 기술 부채/안전성(현행 구현에서 눈에 띄는 부분)
- API 권한 체크가 페이지 렌더링에만 있고, API 자체에는 없는 경우가 많음
- SQL이 문자열 조합으로 만들어져 있어(파라미터 바인딩 없음) 보안/안정성 개선 필요
- `server.listen(PORT, 'localhost')`로 바인딩(리버스 프록시 전제) — 컨테이너/외부접속 구조 재검토 필요
- 성공 응답 코드가 201 고정(클라이언트 유틸이 201만 성공으로 판단)
- 하드코딩된 시크릿/패스워드(세션 secret, resetPassword, (과거) admin master password 등)

---

## 8) 참고 자료(레포 내)
- DB 스키마/백업/마이그레이션 관련: `teamcoperation/ref/`
- 네비게이션(아이콘) 제어 기능 구현 계획 문서: `teamcoperation/plan.md`

