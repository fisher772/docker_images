FROM nginx:stable-alpine-slim

RUN \
 rm /etc/nginx/conf.d/default.conf && \
 chmod +x /entrypoint.sh && \
 chmod +x /le.sh && \
 apk add --no-cache --update bash certbot tzdata openssl rsyslog

ARG ENV_FILE=.env

COPY $ENV_FILE /tmp/.env

RUN mkdir -p /etc/rsyslog.d
COPY settings/20-nginx.conf /etc/rsyslog.d/20-nginx.conf

COPY settings/nginx.conf /etc/nginx/nginx.conf

COPY entrypoint.sh /entrypoint.sh

COPY scripts/le.sh /le.sh

ENTRYPOINT ["/entrypoint.sh"]
