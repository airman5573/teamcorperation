너는 리눅스와 NodeJS전문가야.

```
If you'd like to change these variables head over to the settings tab and adjust these to your likings.

Service	pm2
Host	localhost
Port	3000
Restart after deployment	Yes
```

```
Start Creating.
This is the default template when you installed your site teamcorperation.kr.

You may modify this template if you want, it is located at /home/ploi/teamcorperation.kr/public/index.html

Do you want to use your own custom template when creating new sites? Then follow this easy guide to get your started.
```

이런 상태야. pm2로 노드 서버를 하나 돌릴려고 하는데,
주소는 https://teamcorperation.kr/ 이거야.

1. 현재 node가 잘 작동하고 있는지 어떻게 체크해?
2. 그리고 nginx 세팅 어떻게 해야되?

`/etc/nginx/sites-available/teamcorperation.kr`

```
# Ploi Webserver Configuration, do not remove!
include /etc/nginx/ploi/teamcorperation.kr/before/*;

server {
    #listen 80;
    #listen [::]:80;

    root /home/ploi/teamcorperation.kr/public;
    server_name teamcorperation.kr;

    include /etc/nginx/ssl/teamcorperation.kr;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ecdh_curve X25519:prime256v1:secp384r1;
    ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:DHE-RSA-CHACHA20-POLY1305;
    ssl_prefer_server_ciphers off;
    ssl_dhparam /etc/nginx/dhparams.pem;

    index index.php index.html;

    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-XSS-Protection "1; mode=block";
    add_header X-Content-Type-Options "nosniff";

    charset utf-8;

    # Ploi Configuration, do not remove!
    include /etc/nginx/ploi/teamcorperation.kr/server/*;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    access_log off;
    error_log  /var/log/nginx/teamcorperation.kr-error.log error;

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    error_page 404 /index.php;

    location ~ \.php$ {
        try_files $uri /index.php =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:/run/php/php8.4-fpm.sock;
        fastcgi_buffers 32 32k;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
        fastcgi_param DOCUMENT_ROOT $realpath_root;
        include fastcgi_params;
    }

    location ~ /\.(?!well-known).* {
        deny all;
    }
}

# Ploi Webserver Configuration, do not remove!
include /etc/nginx/ploi/teamcorperation.kr/after/*;
```