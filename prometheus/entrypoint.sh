#!/bin/sh

replace_aliases () {
  sed -i "s|LE_FQDN|${LE_FQDN}|g" /data/nginx/conf/*.conf 2>/dev/null
  sed -i "s|LE_FQDN|${LE_FQDN}|g" /data/nginx/stream/*.conf 2>/dev/null
  sed -i "s|value-default|${CONTAINER_ALIAS}|g" /data/nginx/conf/*.conf 2>/dev/null
  sed -i "s|value-default|${CONTAINER_ALIAS}|g" /data/nginx/stream/*.conf 2>/dev/null
  sed -i "s|SERVER_ALIAS|${SERVER_ALIAS}|g" /data/nginx/stream/*.conf 2>/dev/null
}

replace_aliases

/bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/prometheus \
  --web.console.libraries=/usr/share/prometheus/console_libraries \
  --web.console.templates=/usr/share/prometheus/consoles

exit 0
