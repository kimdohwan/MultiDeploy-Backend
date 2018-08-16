FROM        multi-deploy:base

COPY        .   /srv/backend
WORKDIR     /srv/backend
RUN         mv      /srv/backend/front/* \
                    /srv/front/

# supervisor.conf 파일 복사
RUN         cp -f   /srv/backend/.config/supervisord.conf \
                    /etc/supervisor/conf.d/

# Nginx 관련 설정파일 복사 및 링크
RUN         cp -f   /srv/backend/.config/nginx.conf \
                    /etc/nginx/nginx.conf
RUN         rm -rf  /etc/nginx/sites-enabled/*
RUN         cp -f   /srv/backend/.config/nginx_app.conf \
                    /etc/nginx/sites-available/
RUN         ln -sf  /etc/nginx/sites-available/nginx_app.conf \
                    /etc/nginx/sites-enabled/nginx_app.conf

# Front-end
WORKDIR     /srv/front
RUN         npm run build

# Nginx 설치와 동시에 실행되던 nginx daemon 종료 후
# supervisor 를 사용해 Nginx, Django, Front 를 실행
CMD         pkill nginx; supervisord -n