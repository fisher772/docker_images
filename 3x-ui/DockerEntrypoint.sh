#!/bin/sh

# Set address for Nginx
replace_aliases () {
  sed -i "s|LE_FQDN|${LE_FQDN}|g" /data/nginx/conf/*.conf 2>/dev/null
  sed -i "s|LE_FQDN|${LE_FQDN}|g" /data/nginx/stream/*.conf 2>/dev/null
  sed -i "s|value-default|${CONTAINER_ALIAS}|g" /data/nginx/conf/*.conf 2>/dev/null
  sed -i "s|value-default|${CONTAINER_ALIAS}|g" /data/nginx/stream/*.conf 2>/dev/null
  sed -i "s|SERVER_ALIAS|${SERVER_ALIAS}|g" /data/nginx/stream/*.conf 2>/dev/null
}

replace_aliases

# Start fail2ban
fail2ban-client -x start

# Run x-ui
exec /app/x-ui
