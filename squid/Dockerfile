FROM ubuntu:jammy

RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y openssl apache2-utils \
    tzdata iptables squid && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ENV SQUID_CACHE_DIR=/var/spool/squid \
    SQUID_LOG_DIR=/var/log/squid \
    SQUID_USER=proxy

RUN touch /etc/squid/squid.conf && \
    chmod 644 /etc/squid/squid.conf

RUN echo "0 0 * * * /usr/sbin/logrotate /etc/logrotate.conf" | crontab -

RUN mkdir -p /etc/rsyslog.d
RUN mkdir -p /etc/logrotate.d

COPY settings/10-squid /etc/logrotate.d/10-squid
COPY settings/20-syslog /etc/logrotate.d/20-syslog

RUN rm -f /etc/logrotate.d/rsyslog

COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

EXPOSE 3128/tcp
