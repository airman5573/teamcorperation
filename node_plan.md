# Node.js 배포 계획서

## 개요
PHP 기반 웹사이트를 Node.js 애플리케이션으로 전환하는 상세 계획서입니다.
- 도메인: https://teamcorperation.kr/
- 현재: PHP + Nginx + SSL
- 목표: Node.js (PM2) + Nginx Reverse Proxy + SSL

## 1. 사전 준비 및 상태 확인

### 1.1 Node.js/PM2 상태 확인
```bash
# PM2 프로세스 상태 확인
pm2 list
# 상태가 'online'이고 restart 횟수가 적어야 함

# 애플리케이션 로그 확인
pm2 logs
pm2 logs --lines 50

# 특정 앱 상세 정보
pm2 show <app_name_or_id>
```

### 1.2 로컬 엔드포인트 테스트
```bash
# Node.js 앱이 3000 포트에서 응답하는지 확인
curl -I http://localhost:3000
# 예상 결과: HTTP/1.1 200 OK

# 포트 3000에서 리스닝 중인 프로세스 확인
sudo netstat -tuln | grep 3000
# 또는
sudo ss -tuln | grep 3000
# 예상 결과: 127.0.0.1:3000 LISTEN
```

### 1.3 보안 확인
```bash
# 방화벽 상태 확인 (포트 3000이 외부에 노출되면 안됨)
sudo ufw status
# 포트 3000이 열려있다면 차단
sudo ufw deny 3000
```

## 2. Nginx 설정 분석 및 수정

### 2.1 현재 설정 분석
현재 `/etc/nginx/sites-available/teamcorperation.kr` 설정의 문제점:
- PHP 기반 설정 (fastcgi_pass)
- `location /` 블록이 중복됨 (PHP용과 Node.js용이 둘 다 있음)
- `try_files` 디렉티브가 PHP 전용

### 2.2 수정된 Nginx 설정

**중요**: 다음 블록들은 자동 생성되므로 건드리지 말고 유지:
```nginx
# 이 부분은 자동 생성되므로 유지
server {
     listen 80;
     listen [::]:80;
     server_name .teamcorperation.kr;
     return 301 https://$host$request_uri;
}

server {
     listen 443 ssl;
     listen [::]:443 ssl;
     http2 on;
     ssl_certificate /etc/letsencrypt/live/teamcorperation.kr/fullchain.pem;
     ssl_certificate_key /etc/letsencrypt/live/teamcorperation.kr/privkey.pem;

     server_name www.teamcorperation.kr;
     return 301 https://teamcorperation.kr$request_uri;
}
```

**최종 완성된 설정** (거의 완벽하지만 3가지만 수정):

```nginx
# upstream 블록 추가 (파일 최상단에)
upstream nodejs_backend {
    server 127.0.0.1:3000;
    keepalive 64;
}

# Ploi Webserver Configuration, do not remove!
include /etc/nginx/ploi/teamcorperation.kr/before/*;

server {
    # listen 포트 추가 (중요!)
    listen 443 ssl http2;
    listen [::]:443 ssl http2;

    # root 디렉티브 제거 (Node.js에서는 불필요)
    server_name teamcorperation.kr;

    include /etc/nginx/ssl/teamcorperation.kr;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ecdh_curve X25519:prime256v1:secp384r1;
    ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:DHE-RSA-CHACHA20-POLY1305;
    ssl_prefer_server_ciphers off;
    ssl_dhparam /etc/nginx/dhparams.pem;

    # index 디렉티브 제거 (Node.js에서는 불필요)

    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-XSS-Protection "1; mode=block";
    add_header X-Content-Type-Options "nosniff";

    charset utf-8;

    # Ploi Configuration, do not remove!
    include /etc/nginx/ploi/teamcorperation.kr/server/*;

    access_log off;
    error_log  /var/log/nginx/teamcorperation.kr-error.log error;

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    # error_page 제거 (Node.js가 처리)

    # Node.js 프록시 설정 (메인 location 블록)
    location / {
        proxy_pass http://nodejs_backend;
        
        # 프록시 헤더 설정 (필수)
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Host $host;
        proxy_set_header X-Forwarded-Port $server_port;
        
        # WebSocket 지원 (필요시)
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        
        # 타임아웃 설정
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
        
        # 버퍼링 설정
        proxy_buffering on;
        proxy_buffer_size 128k;
        proxy_buffers 4 256k;
        proxy_busy_buffers_size 256k;
        
        # 프록시 리다이렉트 처리
        proxy_redirect off;
    }

    location ~ /\.(?!well-known).* {
        deny all;
    }
}

# Ploi Webserver Configuration, do not remove!
include /etc/nginx/ploi/teamcorperation.kr/after/*;
```

### 수정된 3가지:
1. **listen 포트 추가**: `#listen 80;` 주석을 제거하고 443 포트 명시
2. **root 디렉티브 제거**: Node.js 프록시에서는 불필요
3. **index, error_page 제거**: Node.js가 모든 라우팅 처리

### 2.3 주요 변경사항
1. **upstream 블록 추가**: 로드밸런싱과 keepalive 연결 관리
2. **HTTP to HTTPS 리다이렉트**: 보안 강화
3. **PHP 관련 설정 완전 제거**: `location ~ \.php$`, `try_files` 등
4. **프록시 헤더 강화**: 클라이언트 정보 정확한 전달
5. **WebSocket 지원**: 실시간 통신이 필요한 경우
6. **보안 헤더 추가**: HSTS, Referrer-Policy 등

## 3. 배포 절차

### 3.1 백업 생성
```bash
# 현재 Nginx 설정 백업
sudo cp /etc/nginx/sites-available/teamcorperation.kr /etc/nginx/sites-available/teamcorperation.kr.backup-$(date +%Y%m%d-%H%M%S)

# 추가 백업 (선택사항)
sudo tar -czf /home/ploi/nginx-backup-$(date +%Y%m%d-%H%M%S).tar.gz /etc/nginx/sites-available/
```

### 3.2 설정 파일 수정
```bash
# 설정 파일 편집
sudo nano /etc/nginx/sites-available/teamcorperation.kr

# 주의: 자동 생성된 리다이렉트 블록들은 건드리지 말고
# 오직 PHP 서버 블록만 Node.js 프록시로 변경
```

**수정 방법**:
1. 자동 생성된 HTTP→HTTPS 리다이렉트 블록 유지
2. 자동 생성된 www→non-www 리다이렉트 블록 유지  
3. **오직 PHP 서버 블록만** Node.js 프록시로 교체

### 3.3 설정 검증 및 적용
```bash
# Nginx 설정 문법 검사 (필수!)
sudo nginx -t
# 결과: syntax is ok, test is successful

# 설정 적용 (graceful reload)
sudo systemctl reload nginx

# 또는 restart (필요시)
# sudo systemctl restart nginx
```

### 3.4 실시간 모니터링
```bash
# 별도 터미널에서 로그 모니터링
tail -f /var/log/nginx/teamcorperation.kr-error.log

# 다른 터미널에서 PM2 로그 모니터링
pm2 logs --lines 0
```

## 4. 테스트 및 검증

### 4.1 기본 연결 테스트
```bash
# 로컬에서 테스트
curl -I https://teamcorperation.kr
# 예상: HTTP/2 200, Server: nginx

# 응답 시간 측정
curl -w "@-" -o /dev/null -s https://teamcorperation.kr <<< "
     time_namelookup:  %{time_namelookup}\n
        time_connect:  %{time_connect}\n
     time_appconnect:  %{time_appconnect}\n
    time_pretransfer:  %{time_pretransfer}\n
       time_redirect:  %{time_redirect}\n
  time_starttransfer:  %{time_starttransfer}\n
                     ----------\n
          time_total:  %{time_total}\n
"
```

### 4.2 헤더 검증
```bash
# 프록시 헤더가 제대로 전달되는지 확인
curl -H "X-Test-Header: test" -v https://teamcorperation.kr
```

### 4.3 부하 테스트 (선택사항)
```bash
# Apache Bench를 이용한 간단한 부하 테스트
ab -n 100 -c 10 https://teamcorperation.kr/

# 또는 wrk 사용
wrk -t4 -c100 -d30s https://teamcorperation.kr/
```

## 5. PM2 영구 설정

### 5.1 시스템 시작시 자동 실행 설정
```bash
# 현재 사용자로 PM2 startup 설정
pm2 startup
# 출력된 명령어를 sudo로 실행

# 현재 실행 중인 앱들을 저장
pm2 save

# 설정 확인
systemctl status pm2-<username>
```

### 5.2 PM2 추가 설정
```bash
# 로그 로테이션 설치
pm2 install pm2-logrotate

# 모니터링 설정 (선택사항)
pm2 install pm2-server-monit
```

## 6. 롤백 계획

### 6.1 긴급 롤백 절차
```bash
# 1. 백업 설정으로 복원
sudo cp /etc/nginx/sites-available/teamcorperation.kr.backup-<timestamp> /etc/nginx/sites-available/teamcorperation.kr

# 2. Nginx 재시작
sudo nginx -t && sudo systemctl reload nginx

# 3. 상태 확인
curl -I https://teamcorperation.kr
```

### 6.2 부분 롤백 (트래픽 분산)
```nginx
# upstream에 PHP 백엔드 추가 (점진적 전환용)
upstream mixed_backend {
    server 127.0.0.1:3000 weight=90;
    server unix:/var/run/php/php8.4-fpm.sock weight=10;
}
```

## 7. 모니터링 및 유지보수

### 7.1 일상 모니터링 명령어
```bash
# PM2 상태 확인
pm2 status

# 메모리 사용량 확인
pm2 monit

# 로그 확인
pm2 logs --lines 20

# Nginx 상태 확인
sudo systemctl status nginx

# 연결 상태 확인
sudo netstat -an | grep :443 | wc -l
```

### 7.2 성능 최적화 포인트
1. **PM2 클러스터 모드**: CPU 코어 수만큼 인스턴스 실행
2. **Nginx 캐싱**: 정적 파일 및 API 응답 캐싱
3. **Keep-Alive 연결**: 연결 재사용으로 성능 향상
4. **로그 레벨 조정**: 운영 환경에서는 error 레벨만 로깅

## 8. 보안 체크리스트

- [ ] 포트 3000 외부 접근 차단
- [ ] PM2 프로세스 non-root 사용자로 실행
- [ ] SSL 인증서 자동 갱신 설정
- [ ] 보안 헤더 모든 응답에 포함
- [ ] 로그 파일 권한 적절히 설정
- [ ] 정기적인 보안 업데이트 적용

## 9. 문제 해결 가이드

### 9.1 502 Bad Gateway 에러
```bash
# Node.js 앱 상태 확인
pm2 list
pm2 logs

# 포트 확인
sudo netstat -tuln | grep 3000

# Nginx 에러 로그 확인
sudo tail -f /var/log/nginx/teamcorperation.kr-error.log
```

### 9.2 성능 이슈
```bash
# PM2 메모리 사용량 확인
pm2 monit

# Nginx 연결 수 확인
nginx -s reload

# 시스템 리소스 확인
htop
iostat -x 1
```

### 9.3 SSL 인증서 문제
```bash
# 인증서 만료일 확인
openssl x509 -in /etc/letsencrypt/live/teamcorperation.kr/cert.pem -text -noout | grep "Not After"

# 인증서 갱신 (Let's Encrypt)
sudo certbot renew --dry-run
```

## 10. 참고 자료

- [PM2 공식 문서](https://pm2.keymetrics.io/docs/)
- [Nginx 리버스 프록시 가이드](https://nginx.org/en/docs/http/ngx_http_proxy_module.html)
- [Node.js 프로덕션 모범 사례](https://nodejs.org/en/docs/guides/nodejs-docker-webapp/)
- [보안 헤더 가이드](https://securityheaders.com/)

---

**주의사항**: 이 계획은 운영 서버에 적용하기 전에 반드시 개발/스테이징 환경에서 충분히 테스트해야 합니다.