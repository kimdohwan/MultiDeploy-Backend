FROM        multi-deploy:base

COPY        .   /srv/backend
WORKDIR     /srv/backend

RUN         cp -f /srv/backend/.config/supervisord.conf \
                          /etc/supervisor/conf.d/

# Front-end
RUN         mv -f /srv/node_modules/    /srv/backend/front/
WORKDIR     /srv/backend/front
RUN         npm run build

CMD         supervisord -n