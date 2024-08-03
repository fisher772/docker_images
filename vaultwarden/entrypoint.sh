#!/bin/sh

replace_aliases () {
  sed -i "s|LE_FQDN|${LE_FQDN}|g" /data/nginx/*.conf 2>/dev/null
  sed -i "s|LE_FQDN|${LE_FQDN}|g" /data/nginx/stream/*.conf 2>/dev/null
  sed -i "s|value-default|${COUNTAINER_ALIAS}|g" /data/nginx/*.conf 2>/dev/null
  sed -i "s|value-default|${COUNTAINER_ALIAS}|g" /data/nginx/stream/*.conf 2>/dev/null
  sed -i "s|SERVER_ALIAS|${SERVER_ALIAS}|g" /data/nginx/stream/*.conf 2>/dev/null
}

replace_aliases

exec /vaultwarden

exit 0
