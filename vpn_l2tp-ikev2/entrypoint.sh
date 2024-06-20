#!/bin/sh -e
#
# entrypoint for strongswan
#

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

INTERFACE=${IPTABLES_INTERFACE:+-i ${IPTABLES_INTERFACE}} # will be empty if not set
ENDPOINTS=${IPTABLES_ENDPOINTS:+-s ${IPTABLES_ENDPOINTS}} # will be empty if not set
D_ENDPOINTS=${IPTABLES_ENDPOINTS:+-d ${IPTABLES_ENDPOINTS}} # will be empty if not set
RIGHTSUBNETS=$(grep rightsubnet /etc/ipsec.docker/ipsec.*.conf | cut -d"=" -f2 | sort | uniq)

PATH_KEYS=/etc/ipsec.d
PATH_IPSEC_SECRETS=/etc/ipsec.secrets
PATH_CHAP_SECRETS=/etc/ppp/chap-secrets

# add iptables rules if IPTABLES=true
if [[ x${IPTABLES} == 'xtrue' ]]; then
  iptables -A INPUT ${ENDPOINTS} ${INTERFACE} -p udp -m udp --sport 500 --dport 500 -j ACCEPT
  iptables -A INPUT ${ENDPOINTS} ${INTERFACE} -p udp -m udp --sport 4500 --dport 4500 -j ACCEPT
  iptables -A INPUT ${ENDPOINTS} ${INTERFACE} -p udp -m udp --sport 1701 --dport 1701 -m policy --dir in --pol ipsec -j ACCEPT
  iptables -I INPUT ${ENDPOINTS} ${INTERFACE} -p udp --dport 500 --sport 500 -m policy --dir in --pol none -j DROP
  iptables -I INPUT ${ENDPOINTS} ${INTERFACE} -p udp --dport 4500 --sport 4500 -m policy --dir in --pol none -j DROP
  iptables -I INPUT ${ENDPOINTS} ${INTERFACE} -p udp --dport 1701 --sport 1701 -m policy --dir in --pol none -j DROP
  iptables -A INPUT -m conntrack --ctstate INVALID -j DROP
  iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
  iptables -t nat -I POSTROUTING -m policy --dir out --pol ipsec -j ACCEPT
  iptables -A FORWARD -i ppp+ ${INTERFACE} -j ACCEPT
  iptables -A FORWARD -i ppp+ -i ppp+ -j ACCEPT
  iptables -A FORWARD -j DROP
  iptables -A FORWARD -m conntrack --ctstate INVALID -j DROP
  iptables -A FORWARD ${INTERFACE} -o ppp+ -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
  iptables -t filter -A FORWARD --match policy --pol ipsec --dir in --proto esp ${ENDPOINTS} -j ACCEPT
  iptables -t filter -A FORWARD --match policy --pol ipsec --dir out --proto esp ${D_ENDPOINTS} -j ACCEPT
  for RIGHTSUBNET in ${RIGHTSUBNETS}; do
      iptables -t nat -A POSTROUTING -s ${RIGHTSUBNET} -j MASQUERADE
  done
fi

revipt() {
if [[ x${IPTABLES} == 'xtrue' ]]; then
  echo "Removing iptables rules..."
  iptables -A INPUT ${ENDPOINTS} ${INTERFACE} -p udp -m udp --sport 500 --dport 500 -j ACCEPT
  iptables -A INPUT ${ENDPOINTS} ${INTERFACE} -p udp -m udp --sport 4500 --dport 4500 -j ACCEPT
  iptables -A INPUT ${ENDPOINTS} ${INTERFACE} -p udp -m udp --sport 1701 --dport 1701 -m policy --dir in --pol ipsec -j ACCEPT
  iptables -I INPUT ${ENDPOINTS} ${INTERFACE} -p udp --dport 500 --sport 500 -m policy --dir in --pol none -j DROP
  iptables -I INPUT ${ENDPOINTS} ${INTERFACE} -p udp --dport 4500 --sport 4500 -m policy --dir in --pol none -j DROP
  iptables -I INPUT ${ENDPOINTS} ${INTERFACE} -p udp --dport 1701 --sport 1701 -m policy --dir in --pol none -j DROP
  iptables -A INPUT -m conntrack --ctstate INVALID -j DROP
  iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
  iptables -t nat -I POSTROUTING -m policy --dir out --pol ipsec -j ACCEPT
  iptables -A FORWARD -i ppp+ ${INTERFACE} -j ACCEPT
  iptables -A FORWARD -i ppp+ -i ppp+ -j ACCEPT
  iptables -A FORWARD -j DROP
  iptables -A FORWARD -m conntrack --ctstate INVALID -j DROP
  iptables -A FORWARD ${INTERFACE} -o ppp+ -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
  iptables -t filter -A FORWARD --match policy --pol ipsec --dir in --proto esp ${ENDPOINTS} -j ACCEPT
  iptables -t filter -A FORWARD --match policy --pol ipsec --dir out --proto esp ${D_ENDPOINTS} -j ACCEPT
  for RIGHTSUBNET in ${RIGHTSUBNETS}; do
      iptables -t nat -A POSTROUTING -s ${RIGHTSUBNET} -j MASQUERADE
  done
fi
}

# enable ip forward
sysctl -w net.ipv4.ip_forward=1

# create eap-user creds. to automatically add a new vpn user, use the script with the --adduser argument
create_user() {
    local eap_user_name=$(cat /dev/urandom | tr -dc 'a-zA-Z' | fold -w 8 | head -n 1)
    local eap_user_pw=$(openssl rand -base64 24)
    local psk_user_name=$(cat /dev/urandom | tr -dc 'a-zA-Z' | fold -w 8 | head -n 1)
    local psk_user_pw=$(openssl rand -base64 24)  
    local psk_user_key=$(openssl rand -base64 48)

    cat >> "$PATH_IPSEC_SECRETS" <<EOF
$eap_user_name : EAP "$eap_user_pw"
EOF

    cat >> "$PATH_CHAP_SECRETS" <<EOF
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

# function to use when this script recieves a SIGTERM.
term() {
  echo "Caught SIGTERM signal! Stopping ipsec..."
  ipsec stop
  # remove iptable rules
  revipt
}

# catch the SIGTERM
trap term SIGTERM

echo "Starting strongSwan/ipsec..."
ipsec start --nofork "$@" &

# wait for child process to exit
wait $!

# remove iptable rules
revipt

adduser() {
  create_user
}

if [ "$1" == "--adduser" ]; then
  adduser
  exit 0
fi

setup "$@"

exit 0
