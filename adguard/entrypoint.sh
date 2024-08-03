#!/bin/sh

replace_aliases () {
  TR_SERVER_ALIAS=$(echo "$SERVER_ALIAS" | tr ',' ' ')
  sed -i "s|LE_FQDN|${LE_FQDN}|g" /data/nginx/*.conf 2>/dev/null
  sed -i "s|LE_FQDN|${LE_FQDN}|g" /data/nginx/stream/*.conf 2>/dev/null
  sed -i "s|value-default|${COUNTAINER_ALIAS}|g" /data/nginx/*.conf 2>/dev/null
  sed -i "s|value-default|${COUNTAINER_ALIAS}|g" /data/nginx/stream/*.conf 2>/dev/null
  sed -i "s|SERVER_ALIAS|${TR_SERVER_ALIAS}|g" /data/nginx/stream/*.conf 2>/dev/null
}

replace_aliases

exec /opt/adguardhome/AdGuardHome

exit 0
