#!/usr/bin/env bash
set -euo pipefail

# Configure Linux bonding on leaves and server to emulate a dual-homed LAG.
echo "[*] Configuring leaf bonds (bond10) and srv1 bond (bond0)..."

docker exec leaf1 bash -lc '
  modprobe bonding || true
  ip link add bond10 type bond mode 802.3ad miimon 100 lacp_rate fast || true
  ip link set eth10 down || true
  ip link set eth10 master bond10 || true
  ip link set bond10 up
  brctl addbr br-vlan10 || true
  brctl addif br-vlan10 bond10 || true
  ip link set br-vlan10 up
'

docker exec leaf2 bash -lc '
  modprobe bonding || true
  ip link add bond10 type bond mode 802.3ad miimon 100 lacp_rate fast || true
  ip link set eth10 down || true
  ip link set eth10 master bond10 || true
  ip link set bond10 up
  brctl addbr br-vlan10 || true
  brctl addif br-vlan10 bond10 || true
  ip link set br-vlan10 up
'

# Configure srv1 LACP bond and VLAN 10 IP
docker exec srv1 sh -lc '
  apk add --no-cache iproute2 ethtool bridge || true
  modprobe bonding || true
  ip link add bond0 type bond mode 802.3ad miimon 100 lacp_rate fast || true
  ip link set eth1 down || true
  ip link set eth2 down || true
  ip link set eth1 master bond0 || true
  ip link set eth2 master bond0 || true
  ip link set bond0 up || true
  ip link add link bond0 name bond0.10 type vlan id 10 || true
  ip addr add 10.10.10.11/24 dev bond0.10 || true
  ip link set bond0.10 up || true
  ip route add default via 10.10.10.1 || true
'

echo "[*] Done. Try: docker exec leaf1 ping -c 2 10.10.10.11
docker exec leaf1 vtysh -c "show bgp l2vpn evpn""
