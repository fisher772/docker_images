FROM alpine:latest 

RUN apk update && set -x \
      && apk add --no-cache \
          bash sudo openssl uuid-runtime libcurl coreutils iproute2 \
          uuidgen wget xl2tpd iptables iptables-legacy bind-tools \
          strongswan-pki libcharon-extra-plugins libcharon-extauth-plugins \
          libstrongswan-extra-plugins libtss2-tcti-tabrmd0

RUN mkdir -p /etc/ipsec.d/users_cdreds
RUN chmod 0640 /etc/ipsec.d/users_cdreds


COPY settings/l2tp-ikev2.conf /etc/ipsec.d/l2tp-ikev2.conf

COPY settings/xl2tpd.conf /etc/xl2tpd/xl2tpd.conf

COPY settings/options.xl2tpd /etc/ppp/options.xl2tpd

RUN chmod 0600 /etc/ppp/chap-secrets
RUN chmod 0600 /etc/ipsec.secrets

RUN echo 'include /etc/ipsec.d/*.conf' >> /etc/ipsec.conf

COPY scripts/init.sh /usr/local/bin/init.sh
RUN chmod 0755 /usr/local/bin/init.sh
RUN bash -c /usr/local/bin/init.sh

COPY entypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod 0755 /usr/local/bin/entrypoint.sh

RUN echo '%ipsec ALL=NOPASSWD:SETENV:/usr/sbin/ipsec' > /etc/sudoers.d/ipsec
RUN chmod 0440 /etc/sudoers.d/ipsec

VOLUME /etc /etc/ipsec.d /etc/xl2tpd /etc/ppp

EXPOSE 500/udp 4500/udp 1701/udp

ENTRYPOINT ["/entrypoint.sh"]
