FROM vaultwarden/server:latest

RUN mkdir -p /etc/rsyslog.d
RUN mkdir -p /etc/logrotate.d
RUN mkdir -p /data/nginx/stream
RUN mkdir -p /var/log/vaultwarden

COPY settings/service-vaultwarden.conf /data/nginx/service-vaultwarden.conf
COPY settings/stream/service-vaultwarden-stream.conf /data/nginx/stream/service-vaultwarden-stream.conf
COPY settings/10-vaultwarden /etc/logrotate.d/10-vaultwarden
