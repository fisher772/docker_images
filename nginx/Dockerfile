FROM nginx:stable-alpine-slim

COPY settings/nginx.conf /etc/nginx/nginx.conf

COPY entrypoint.sh /entrypoint.sh
COPY scripts/le.sh /le.sh

RUN \
 rm /etc/nginx/conf.d/default.conf && \
 chmod +x /entrypoint.sh && \
 chmod +x /le.sh && \
 apk add --no-cache --update bash certbot tzdata openssl rsyslog logrotate

RUN mkdir -p /etc/rsyslog.d
RUN mkdir -p /etc/logrotate.d
COPY settings/10-nginx /etc/logrotate.d/10-nginx
COPY settings/20-syslog /etc/logrotate.d/20-syslog
COPY settings/30-le /etc/logrotate.d/30-le

RUN rm -f /etc/logrotate.d/rsyslog

RUN echo "0 0 * * * /usr/sbin/logrotate /etc/logrotate.conf" | crontab -

ENTRYPOINT ["/entrypoint.sh"]
