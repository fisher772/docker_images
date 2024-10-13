FROM atlassian/confluence

USER root

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN mkdir -p /data/nginx/stream conf ssl

COPY settings/service-confluence.conf /data/nginx/conf/service-confluence.conf
COPY settings/stream/stream-confluence.conf /data/nginx/stream/stream-confluence.conf

CMD ["/entrypoint.sh"]

USER confluence

ENTRYPOINT ["/entrypoint.py", "/usr/bin/tini", "--"]
