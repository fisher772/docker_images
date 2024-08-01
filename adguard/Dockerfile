FROM adguard/adguardhome

COPY entrypoint.sh /entrypoint.sh

RUN \
 chmod +x /entrypoint.sh && \
 apk add --no-cache --update bash tzdata rsyslog logrotate

RUN mkdir -p /data/nginx/stream
RUN mkdir -p /etc/rsyslog.d
RUN mkdir -p /etc/logrotate.d
COPY settings/10-nginx /etc/logrotate.d/10-adgguard
COPY settings/20-syslog /etc/logrotate.d/20-syslog

RUN rm -f /etc/logrotate.d/rsyslog

RUN echo "0 0 * * * /usr/sbin/logrotate /etc/logrotate.conf" | crontab -

COPY settings/service-adguard.conf /data/nginx/service-adguard.conf
COPY settings/stream/stream-adguard.conf /data/nginx/stream/stream-adguard.conf

ENTRYPOINT ["/entrypoint.sh"]
