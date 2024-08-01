#!/bin/bash

change_resolve() {
  if [[ -f /etc/resolv.conf && ! -f /etc/resolv.conf.bak ]]; then
    mkdir -p /etc/systemd/resolve.d 2>/dev/null
    rm -f /etc/systemd/resolve.d/* 2>/dev/null
    mv -v /etc/resolv.conf /etc/resolv.conf.bak 2>/dev/null
    cat > /etc/systemd/resolve.d/adguard.conf <<EOF
# fisher adguard
[Resolve]
DNS=127.0.0.1
DNSStubListener=none
EOF
    ln -s /etc/systemd/resolve.d/adguard.conf /etc/resolv.conf
    echo "Restart systemd-resolved"
    systemctl reload-or-restart systemd-resolved
  else
    :
  fi
}

change_resolve
