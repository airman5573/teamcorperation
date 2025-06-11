# 조건부 네비게이션 렌더링 구현 계획

## 개요
사용자 페이지의 하단 네비게이션에서 "포인트"와 "구역" 메뉴를 서버 설정에 따라 조건부로 표시/숨김 처리하는 기능을 구현합니다. 중요한 점은 **하나의 ON/OFF 토글로 두 메뉴를 동시에 제어**한다는 것입니다.

## 현재 상황 분석
- 하단 네비게이션은 항상 모든 메뉴를 표시 (지도, 포인트, 구역, 업로드, 포스트)
- 설정은 `dc_metas` 테이블에 키-값 쌍으로 저장됨
- 관리자 페이지에서 설정을 변경하면 DB에 저장되고 Redux를 통해 상태 관리
- 이미 다른 기능들(ENIAC 상태, 임시 저장소 등)에서 조건부 렌더링 패턴 사용 중

## 구현 단계

### 1. 데이터베이스 스키마 변경
**파일**: `src/database.js` (필요시)

`dc_metas` 테이블에 새로운 설정 추가 (개별 관리):
- **키1**: `showPointNav` - 포인트 메뉴 표시 여부
- **키2**: `showPuzzleNav` - 구역 메뉴 표시 여부  
- **값**: `'1'` 또는 `'0'` (문자열, 기존 방식에 따라)
- **기본값**: `'1'` (두 메뉴 모두 표시)

### 2. 백엔드 쿼리 업데이트
**파일**: `src/query.js`

#### 2.1 초기 상태 조회 수정
`getInitialState()` 함수에서 새로운 설정값 포함:

**admin 역할 키 목록에 추가:**
```javascript
// 기존: ['laptime', 'companyImage', 'map', ..., 'mappingPoints']
var metas = await this.metas.get([..., 'mappingPoints', 'showPointNav', 'showPuzzleNav']);
```

**user 역할 키 목록에 추가:**
```javascript  
// 기존: ['laptime', 'companyImage', 'map', ..., 'mappingPoints']
var metas = await this.metas.get([..., 'mappingPoints', 'showPointNav', 'showPuzzleNav']);
```

**기본값 처리 (undefined일 경우 true 반환):**
```javascript
// 기존 설정들과 함께 추가
showPointNav: metaData.showPointNav !== '0', // '1' 또는 undefined일 경우 true
showPuzzleNav: metaData.showPuzzleNav !== '0' // '1' 또는 undefined일 경우 true
```

#### 2.2 설정 업데이트 함수 추가
```javascript
static async updatePointPuzzleNavVisibility(isVisible) {
  const value = isVisible ? '1' : '0';
  await this.metas.update('showPointNav', value);
  await this.metas.update('showPuzzleNav', value);
}
```

### 3. 관리자 페이지 UI 추가
**파일들**: 
- `src/admin/admin-client/components/main-menu.js`
- 새 모달 컴포넌트 생성

#### 3.1 메뉴 아이템 추가
메인 메뉴에 "네비게이션 설정" 항목 추가

#### 3.2 네비게이션 설정 모달 생성
**새 파일**: `src/admin/admin-client/components/modals/navigation-setting-modal.js`
- **하나의 통합 토글 스위치**: "포인트/구역 메뉴 표시" 
- 라디오 버튼 방식 (ON/OFF) - 기존 timer-modal 패턴과 일치
- axios POST 요청 + 에러 처리
- 성공시 Redux 상태 업데이트 + alert

#### 3.3 Redux 액션/리듀서 추가
**파일들**:
- `src/admin/admin-client/actions/navigation-setting-actions.js`
- `src/admin/admin-client/reducers/navigation-setting-reducer.js`

### 4. 관리자 라우트 업데이트
**파일**: `src/admin/adminRoute.js`

새로운 POST 엔드포인트 추가 (기존 패턴과 일치):
```javascript
router.post('/admin/settings/navigation-visibility', async (req, res) => {
  try {
    const value = req.body.isVisible ? '1' : '0';
    await DCQuery.metas.update('showPointNav', value);
    await DCQuery.metas.update('showPuzzleNav', value);
    return res.sendStatus(201);
  } catch (e) {
    console.log('error : ', e);
    return res.sendStatus(404);
  }
});
```

### 5. 사용자 프론트엔드 업데이트
**파일들**:
- `src/user/user-client/components/bottom-navigation.js`
- `src/user/user-client/components/app.js`

#### 5.1 Redux 상태에서 설정값 가져오기
App 컴포넌트에서 두 개의 설정값을 props로 전달

#### 5.2 간단한 조건부 렌더링 구현
```javascript
render() {
  const { showPointNav, showPuzzleNav } = this.props;
  
  return (
    <div className="bottom-navigation">
      <NavLink to="/user/page/map">
        <div className="icon"><MapIcon /></div>
        <div className="text">지도</div>
        <div className={rippleCN}></div>
      </NavLink>
      
      {showPointNav && (
        <NavLink to="/user/page/point">
          <div className="icon"><ChartIcon /></div>
          <div className="text">포인트</div>
          <div className={rippleCN}></div>
        </NavLink>
      )}
      
      {showPuzzleNav && (
        <NavLink to="/user/page/puzzle">
          <div className="icon"><PuzzleIcon /></div>
          <div className="text">구역</div>
          <div className={rippleCN}></div>
        </NavLink>
      )}
      
      <NavLink to="/user/page/upload">
        <div className="icon"><UploadIcon /></div>
        <div className="text">업로드</div>
        <div className={rippleCN}></div>
      </NavLink>
      
      <NavLink to="/user/page/post-info">
        <div className="icon"><PostInfoIcon /></div>
        <div className="text">포스트</div>
        <div className={rippleCN}></div>
      </NavLink>
    </div>
  );
}
```

### 6. 스타일 조정 (필요시)
**파일**: `src/user/user-client/scss/components/bottom-navigation.scss`

네비게이션 아이템 수가 변경될 때 레이아웃이 자연스럽게 조정되도록 CSS 확인 및 수정

## 구현 장점 (개별 DB + 통합 UI 방식)
1. **유연성**: DB에서는 각 메뉴를 개별 관리하여 향후 세밀한 제어 가능
2. **단순한 UI**: 관리자 페이지에서는 하나의 버튼으로 두 설정을 동시에 조작
3. **코드 가독성**: 복잡한 루프 없이 간단한 조건부 렌더링 (`&&` 연산자)
4. **확장성**: 나중에 개별 제어가 필요하면 관리자 UI만 수정하면 됨

## 테스트 시나리오
1. 관리자 페이지에서 포인트/구역 메뉴 통합 토글 ON/OFF 설정
2. 사용자 페이지 새로고침 후 변경사항 확인 (둘 다 동시에 표시/숨김)
3. 메뉴가 숨겨진 상태에서 직접 URL 접근 시 처리 확인
4. 기본값 테스트 (DB에 키가 없을 때 true로 처리되는지 확인)

## 추가 개선사항 (Gemini 검토 결과)

### 1. 초기값 처리 강화
- DB에 키가 없을 경우 `undefined !== 'false'` 로직으로 기본값 true 보장
- 역할별 키 목록에 모두 추가 (admin, user)

### 2. 에러 처리 개선
- 클라이언트 측 axios catch 블록에서 에러 알림
- 서버 측 try-catch로 일관된 에러 응답

### 3. API 네이밍 개선
- `/admin/settings/navigation-visibility` 로 구조화된 네임스페이스 사용

### 4. 기존 패턴 완전 준수
- boolean 값을 '1'/'0' 문자열로 저장 (기존 eniacState, tempBoxState와 동일)
- 라디오 버튼 UI로 일관성 유지
- Redux 액션 패턴 동일하게 적용

## 주의사항
- 기본값은 표시(true)로 설정하여 기존 동작 유지
- 메뉴가 숨겨져도 직접 URL 접근은 가능하므로, 필요시 라우트 레벨에서도 접근 제어 고려
- Redux 상태 업데이트 시 실시간 반영되도록 구현
- DB에 키가 존재하지 않을 경우를 대비한 기본값 처리 로직 추가