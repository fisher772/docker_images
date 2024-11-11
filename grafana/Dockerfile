FROM kibana:8.15.3

USER root

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN mkdir -p /data/nginx/stream conf ssl

COPY settings/service-grafana.conf /data/nginx/conf/service-grafana.conf
COPY settings/stream/stream-grafana.conf /data/nginx/stream/stream-grafana.conf

CMD ["/entrypoint.sh"]

USER kibana

ENTRYPOINT ["/usr/local/bin/kibana-docker"]
