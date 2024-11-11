FROM kibana:8.15.3

USER root

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN mkdir -p /data/nginx/stream conf ssl

COPY settings/service-nexus.conf /data/nginx/conf/service-kibana.conf
COPY settings/stream/stream-nexus.conf /data/nginx/stream/stream-kibana.conf

CMD ["/entrypoint.sh"]

USER kibana

ENTRYPOINT ["/usr/local/bin/kibana-docker"]
