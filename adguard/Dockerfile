FROM adguard/adguardhome

COPY entrypoint.sh /entrypoint.sh

RUN \
 chmod +x /entrypoint.sh && \
 apk add --no-cache --update bash

RUN mkdir -p /data/nginx/stream

COPY settings/service-adguard.conf /data/nginx/service-adguard.conf
COPY settings/stream/stream-adguard.conf /data/nginx/stream/stream-adguard.conf

ENTRYPOINT ["/entrypoint.sh"]
