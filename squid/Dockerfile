FROM alpine:latest

RUN set -xe \
    && apk add --no-cache --update sudo bash tzdata rsyslog logrotate\
    iptables iptables-legacy openssl openresty squid

ENV SQUID_CACHE_DIR=/var/spool/squid \
    SQUID_LOG_DIR=/var/log/squid \
    SQUID_USER=proxy

RUN touch /etc/squid3/squid.conf && \
    chmod 644 /etc/squid3/squid.conf

RUN user=$(cat /dev/urandom | tr -dc 'a-zA-Z' | fold -w 8 | head -n 1) && \
    user_pw=$(openssl rand -base64 24)

RUN echo "$user:$user_pw" | htpasswd -nbB > /etc/squid3/squid_creds

RUN echo "0 0 * * * /usr/sbin/logrotate /etc/logrotate.conf" | crontab -

RUN mkdir -p /etc/rsyslog.d
RUN mkdir -p /etc/logrotate.d

COPY settings/10-squid /etc/logrotate.d/10-squid
COPY settings/20-syslog /etc/logrotate.d/20-syslog

RUN rm -f /etc/logrotate.d/rsyslog

COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

EXPOSE 3128/tcp

ENTRYPOINT [ "/entrypoint.sh" ]
