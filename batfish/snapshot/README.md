Place rendered configs (from `configs/`) here to analyze with pybatfish:

```python
from pybatfish.client.commands import bf_init_snapshot, bf_session, bf_set_network
bf_set_network("evpn-fabric")
bf_init_snapshot("./batfish/snapshot", name="mvp", overwrite=True)
```
