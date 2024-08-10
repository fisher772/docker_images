#!/bin/sh

# Set address for Nginx
sed -i "s|LE_FQDN|${LE_FQDN}|g" /data/nginx/*.conf 2>/dev/null
sed -i "s|LE_FQDN|${LE_FQDN}|g" /data/nginx/stream/*.conf 2>/dev/null

# Start fail2ban
fail2ban-client -x start

# Run x-ui
exec /app/x-ui
