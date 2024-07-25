#!/bin/bash
set -e

rewrite_creds() {
    echo "Rewriting credentials..."

    local user=$(cat /dev/urandom | tr -dc 'a-zA-Z' | fold -w 8 | head -n 1)
    local user_pw=$(openssl rand -base64 24)

    rm -f /etc/squid3/squid_creds 2>/dev/null

    echo "$user:$user_pw" | htpasswd -nbB > /etc/squid3/squid_creds

exit 0
}

create_user() {
    echo "Rewriting credentials..."

    local user=$(cat /dev/urandom | tr -dc 'a-zA-Z' | fold -w 8 | head -n 1)
    local user_pw=$(openssl rand -base64 24)

    echo "$user:$user_pw" | htpasswd -b /etc/squid3/squid_creds new_user "$user_pw"

exit 0
}

case "$1" in
  --clean_creds)
    rewrite_creds
    ;;
  --adduser)
    create_user
    ;;
  *)
    :
esac

create_log_dir() {
  mkdir -p ${SQUID_LOG_DIR}
  chmod -R 755 ${SQUID_LOG_DIR}
  chown -R ${SQUID_USER}:${SQUID_USER} ${SQUID_LOG_DIR}
}

create_cache_dir() {
  mkdir -p ${SQUID_CACHE_DIR}
  chown -R ${SQUID_USER}:${SQUID_USER} ${SQUID_CACHE_DIR}
}

create_log_dir
create_cache_dir

exec $(which crond)
exec $(which rsyslogd)

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
