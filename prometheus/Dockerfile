FROM prom/prometheus

USER root

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN mkdir -p /data/nginx/stream conf ssl

COPY settings/prometheus/prometheus.yml /etc/prometheus/prometheus.yml
COPY settings/service-prometheus.conf /data/nginx/conf/service-prometheus.conf
COPY settings/stream/stream-prometheus.conf /data/nginx/stream/stream-prometheus.conf
RUN chown -R nobody:nobody /data/nginx

USER nobody

ENTRYPOINT ["/entrypoint.sh"]