FROM redis:alpine

RUN mkdir -p /usr/local/etc/redis/conf.d

COPY settings/redis.conf /usr/local/etc/redis/redis.conf
COPY settings/custom.conf /usr/local/etc/redis/conf.d/custom.conf
CMD [ "redis-server", "/usr/local/etc/redis/redis.conf" ]
