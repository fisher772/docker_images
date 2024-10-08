FROM vaultwarden/server:latest

COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

RUN mkdir -p /etc/rsyslog.d
RUN mkdir -p /etc/logrotate.d
RUN mkdir -p /data/nginx/stream conf ssl
RUN mkdir -p /var/log/vaultwarden

COPY settings/service-vaultwarden.conf /data/nginx/conf/service-vaultwarden.conf
COPY settings/stream/stream-vaultwarden.conf /data/nginx/stream/stream-vaultwarden.conf
COPY settings/10-vaultwarden /etc/logrotate.d/10-vaultwarden

ENTRYPOINT ["/entrypoint.sh"]
