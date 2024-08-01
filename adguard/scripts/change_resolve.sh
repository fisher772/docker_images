#!/bin/bash

change_resolve() {
  if [[ -f /etc/resolv.conf && ! -f /etc/resolv.conf.bak ]]; then
    mv -v /etc/resolv.conf /etc/resolv.conf.bak 2>/dev/null
    cat > /etc/resolv.conf <<EOF
# fisher adguard
[Resolve]
DNS=127.0.0.1
DNSStubListener=none
EOF
    echo "Restart systemd-resolved"
    systemctl restart systemd-resolved
  else
    :
  fi
}

change_resolve
