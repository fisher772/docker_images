FROM adguard/adguardhome

RUN apk add --no-cache --update bash

RUN mkdir -p /data/nginx/stream

COPY entrypoint.sh /data/entrypoint.sh
RUN chmod +x /data/entrypoint.sh

COPY settings/service-adguard.conf /data/nginx/conf/service-adguard.conf
COPY settings/stream/stream-adguard.conf /data/nginx/stream/stream-adguard.conf

ENTRYPOINT ["/entrypoint.sh"]
