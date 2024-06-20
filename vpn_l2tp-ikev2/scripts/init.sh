#!/bin/sh -e
#
# entrypoint for strongswan
#

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

PATH_KEYS=/etc/ipsec.d
PATH_CONF=/etc/ipsec.conf
PATH_IPSEC_SECRETS=/etc/ipsec.secrets
PATH_CHAP_SECRETS=/etc/ppp/chap-secrets

ROUTE_RANGE=${VPN_ROUTE_RANGE}
DOMAIN=${VPN_DOMAIN}
CERT_C=${VPN_CERT_C}
CERT_O=${VPN_CERT_O}
CERT_CN=${VPN_CERT_CN}

# create creds dir
create_dir() {
  mkdir -p "$PATH_KEYS"/{cacerts,certs,private,users_creds}
}

# create server creds
create_keys() {
  pki --gen --type rsa --size 4096 --outform pem > "$PATH_KEYS"/private/ca-key.pem && \

  pki --self --ca --lifetime 3650 --in "$PATH_KEYS"/private/ca-key.pem \
  --type rsa --dn "C=$CERT_C, O=$CERT_O, CN=$CERT_CN" --outform pem > "$PATH_KEYS"/cacerts/ca-cert.pem && \

  pki --gen --type rsa --size 4096 --outform pem > "$PATH_KEYS"/private/server-key.pem && \

  pki --pub --in "$PATH_KEYS"/private/server-key.pem --type rsa | \
  pki --issue --lifetime 1825 --cacert "$PATH_KEYS"/cacerts/ca-cert.pem \
  --cakey "$PATH_KEYS"/private/ca-key.pem --dn "C=$CERT_C, O=$CERT_O, CN=$DOMAIN" \
  --san "$DOMAIN" --flag serverAuth --flag ikeIntermediate \
  --outform pem > "$PATH_KEYS"/certs/server-cert.pem
}

# create eap-user creds. to automatically add a new vpn user, use the script with the --adduser argument
create_user() {
    local eap_user_name=$(cat /dev/urandom | tr -dc 'a-zA-Z' | fold -w 8 | head -n 1)
    local eap_user_pw=$(openssl rand -base64 24)
    local psk_user_name=$(cat /dev/urandom | tr -dc 'a-zA-Z' | fold -w 8 | head -n 1)
    local psk_user_pw=$(openssl rand -base64 24)  
    local psk_user_key=$(openssl rand -base64 48)

    cat > "$PATH_CONF" <<EOF
# ipsec.conf - strongSwan IPsec configuration file

include /etc/ipsec.d/*.conf
EOF

    cat >> "$PATH_IPSEC_SECRETS" <<EOF
# /etc/ipsec.secrets - strongSwan IPsec secrets file

%any %any : PSK "$psk_user_key"

: RSA "server-key.pem"

$eap_user_name : EAP "$eap_user_pw"
EOF

    cat >> "$PATH_CHAP_SECRETS" <<EOF
# Secrets for authentication using CHAP

$psk_user_name    l2tpd-psk     "$psk_user_pw"         *
EOF

    cat > "$PATH_KEYS/users_creds/psk_${psk_user_name}.txt" <<EOF
user: $psk_user_name
password: $psk_user_pw
EOF
    chmod 0600 "$PATH_KEYS/users_creds/psk_${psk_user_name}.txt"

    cat > "$PATH_KEYS/users_creds/ikev_${eap_user_name}.txt" <<EOF
user: $eap_user_name
password: $eap_user_pw
EOF
    chmod 0600 "$PATH_KEYS/users_creds/ikev_${eap_user_name}.txt"
}

setup() {
  create_dir
  create_keys
  create_user
}

setup "$@"

exit 0
