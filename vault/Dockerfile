FROM hashicorp/vault

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN mkdir -p /data/nginx/stream conf ssl

COPY settings/service-vault.conf /data/nginx/conf/service-vault.conf
COPY settings/stream/stream-vault.conf /data/nginx/stream/stream-vault.conf

CMD ["/entrypoint.sh"]

ENTRYPOINT ["docker-entrypoint.sh", "server", "-dev"]
