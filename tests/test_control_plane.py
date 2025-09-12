from utils import sh

def test_bgp_sessions_up():
    out1 = sh('docker exec leaf1 vtysh -c "show bgp l2vpn evpn summary"')
    out2 = sh('docker exec leaf2 vtysh -c "show bgp l2vpn evpn summary"')
    assert ('Established' in out1) or ('Establ' in out1)
    assert ('Established' in out2) or ('Establ' in out2)

def test_srv1_l2_l3():
    out = sh('docker exec leaf1 ping -c 2 10.10.10.11')
    assert ('0% packet loss' in out) or ('bytes from' in out)
