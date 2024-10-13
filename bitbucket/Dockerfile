FROM atlassian/bitbucket

USER root

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN mkdir -p /data/nginx/stream conf ssl

COPY settings/service-bitbucket.conf /data/nginx/conf/service-bitbucket.conf
COPY settings/stream/stream-bitbucket.conf /data/nginx/stream/stream-bitbucket.conf

CMD ["/entrypoint.sh"]

USER bitbucket

ENTRYPOINT ["/entrypoint.py", "/usr/bin/tini", "--"]
