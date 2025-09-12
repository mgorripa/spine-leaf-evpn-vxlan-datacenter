# Spine–Leaf EVPN‑VXLAN (Containerlab + FRR)
A fully open‑source, laptop‑friendly data center fabric: **BGP EVPN** control plane + **VXLAN** data plane, **symmetric IRB**, **Anycast GW**, and **ECMP** across spines. Built with **containerlab** + **FRRouting (FRR)**, automated by **Ansible**, verified by **Batfish**, visible in **Grafana**.

## Features
- 2x Spines (RRs), 2x Leaves (VTEPs) — MVP
- Underlay IP fabric with /31 P2P + loopbacks
- BGP EVPN overlay (Types 2/3/5)
- VXLAN VNI per VLAN; symmetric IRB per VRF
- Anycast Gateway per VLAN
- ECMP leaf↔spine
- v1.1: EVPN ESI multihoming (experimental), dual‑homed host, leaf3, VRFs BLUE/GREEN, richer metrics

## Prerequisites
- Docker or Podman
- containerlab
- Python 3.10+
- make

## Quickstart (MVP)
```bash
pip install -r requirements.txt
pre-commit install
make up
make deploy
make test
docker exec leaf1 vtysh -c "show bgp l2vpn evpn"
```

## v1.1 (ESI + scale)
```bash
make up-esilab
make deploy
make post-esilab
make test
```

## Notes
- If FRR errors on EVPN-MH (ESI) commands, comment the ESI block in the Jinja template and redeploy. LACP bonding still gives fast failover.
- CI on GitHub renders configs and runs linters (no privileged containers in CI).
