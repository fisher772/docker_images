FROM alpine:latest

RUN set -xe \
    && apk add --no-cache sudo bash rsyslog iptables iptables-legacy openssl strongswan xl2tpd

ARG ENV_FILE=.env

COPY $ENV_FILE /tmp/.env

COPY settings/ipsec.docker.secrets /etc/ipsec.d/ipsec.docker/ipsec.docker.secrets

COPY scripts/init.sh /init.sh
RUN chmod 0755 /init.sh
RUN bash /init.sh

COPY scripts/trasher.sh /trasher.sh
RUN chmod 0755 /trasher.sh
RUN echo '0 0 * * * /trasher.sh' | crontab -

COPY settings/l2tp-ikev2.conf /etc/ipsec.d/ipsec.docker/l2tp-ikev2.conf

COPY settings/xl2tpd.conf /etc/xl2tpd/xl2tpd.conf

COPY settings/options.xl2tpd /etc/ppp/options.xl2tpd

COPY settings/10-charon-logging.conf /etc/strongswan.d/10-charon-logging.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod 0755 /entrypoint.sh

RUN echo '%ipsec ALL=NOPASSWD:SETENV:/usr/sbin/ipsec' > /etc/sudoers.d/ipsec
RUN chmod 0440 /etc/sudoers.d/ipsec

VOLUME /etc/ipsec.d /etc/strongswan.d /etc/xl2tpd /etc/ppp

EXPOSE 500/udp 4500/udp 1701/udp

ENTRYPOINT ["/entrypoint.sh"]
