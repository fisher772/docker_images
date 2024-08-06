#!/bin/bash
set -e

if [[ ! -z "${TZ}" ]]; then
  cp /usr/share/zoneinfo/${TZ} /etc/localtime
  echo ${TZ} >/etc/timezone
fi

rewrite_creds() {
    echo "Rewriting credentials..."

    local user=$(cat /dev/urandom | tr -dc 'a-z 0-9' | fold -w 8 | head -n 1)
    local user_pw=$(openssl rand -base64 24)

    rm -f /etc/squid/squid_creds 2>/dev/null
    rm -f /etc/squid/user_creds/* 2>/dev/null

    htpasswd -cbB /etc/squid/squid_creds $user $user_pw

cat > "/etc/squid/user_creds/${user}.txt" <<EOF
      user: $user
      password: $user_pw
EOF
    chmod 0600 "/etc/squid/user_creds/${user}.txt"

exit 0
}

create_user() {
    echo "Rewriting credentials..."

    local user=$(cat /dev/urandom | tr -dc 'a-z 0-9' | fold -w 8 | head -n 1)
    local user_pw=$(openssl rand -base64 24)

    htpasswd -bB /etc/squid/squid_creds $user $user_pw

cat > "/etc/squid/user_creds/${user}.txt" <<EOF
      user: $user
      password: $user_pw
EOF
    chmod 0600 "/etc/squid/user_creds/${user}.txt"

exit 0
}

case "$1" in
  --rewrite_creds)
    rewrite_creds
    ;;
  --adduser)
    create_user
    ;;
  *)
    :
esac

create_creds_dir() {
  mkdir -p /etc/squid/user_creds
  chmod 0600 /etc/squid/user_creds
}

create_creds() {
    local user=$(cat /dev/urandom | tr -dc 'a-z 0-9' | fold -w 8 | head -n 1)
    local user_pw=$(openssl rand -base64 24)

    htpasswd -cbB /etc/squid/squid_creds $user $user_pw

cat > "/etc/squid/user_creds/${user}.txt" <<EOF
      user: $user
      password: $user_pw
EOF
    chmod 0600 "/etc/squid/user_creds/${user}.txt"

exit 0
}

create_trusted_users () {
  if [[ -f /etc/squid/KnowUsers.acl && -n "${TRUSTED_IP}" ]]; then
    TR_IP=$(echo "$TRUSTED_IP" | tr ',' '\n')
    sed -i "s|#TRUSTED_IP|${TR_IP}|g" /etc/squid/KnowUsers.acl 2>/dev/null
    sed -i "s|#http_access allow KnownUsers|http_access allow KnownUsers|g" /etc/squid/squid.conf 2>/dev/null
  else
    :
  fi
}

gen_dh() {
  if [ ! -f /etc/squid/ssl/dhparams.pem ]; then
    echo "make dhparams"
    cd /etc/squid/ssl
    openssl dhparam -out dhparams.pem 2048
    chmod 600 dhparams.pem
    chown -R proxy:proxy /etc/squid/ssl
  fi
}

add_le_ssl() {
  if [[ "$HTTPS_STATUS" == "true" ]]; then
    sed -i "s|#https_port|https_port|g" /etc/squid/squid.conf 2>/dev/null
    sed -i "s|SSL_CERT|${SSL_CERT}|g" /etc/squid/squid.conf 2>/dev/null
    sed -i "s|SSL_KEY|${SSL_KEY}|g" /etc/squid/squid.conf 2>/dev/null
    if [[ -n "${HTTPS_PORT}" ]]; then
      sed -i "s|https_squid_port|${HTTPS_PORT}|g" /etc/squid/squid.conf 2>/dev/null
    else
      :
    fi
  else
    :
  fi
}

add_dns() {
  if [[ -n "${DNS_VALUE}" ]]; then
    sed -i "s|dns_default_value|${DNS_VALUE}|g" /etc/squid/squid.conf 2>/dev/null
  else
    sed -i "s|dns_default_value|8.8.8.8 8.8.4.4|g" /etc/squid/squid.conf 2>/dev/null
  fi
}

add_port() {
  if [[ -n "${HTTP_PORT}" ]]; then
    sed -i "s|http_squid_port|${HTTP_PORT}|g" /etc/squid/squid.conf 2>/dev/null
  else
    sed -i "s|http_squid_port|3128|g" /etc/squid/squid.conf 2>/dev/null
  fi
}

create_log_dir() {
  mkdir -p ${SQUID_LOG_DIR}
}

create_cache_dir() {
  mkdir -p ${SQUID_CACHE_DIR}
}

create_creds_dir
create_trusted_users
gen_dh
add_le_ssl
add_dns
add_port

if [[ ! -f /etc/squid/squid_creds ]]; then
  create_creds
else
  :
fi

create_log_dir
create_cache_dir

exec $(which crond)

# allow arguments to be passed to squid
if [[ ${1:0:1} = '-' ]]; then
  EXTRA_ARGS="$@"
  set --
elif [[ ${1} == squid || ${1} == $(which squid) ]]; then
  EXTRA_ARGS="${@:2}"
  set --
fi

# default behaviour is to launch squid
if [[ -z ${1} ]]; then
  if [[ ! -d ${SQUID_CACHE_DIR}/00 ]]; then
    echo "Initializing cache..."
    $(which squid) -N -f /etc/squid/squid.conf -z
  fi
  echo "Starting squid..."
  exec $(which squid) -f /etc/squid/squid.conf -NYCd 1 ${EXTRA_ARGS}
else
  exec "$@"
fi
