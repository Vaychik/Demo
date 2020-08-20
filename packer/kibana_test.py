def test_kibana_is_installed(host):
    kibana = host.package("kibana")
    assert kibana.is_installed
    assert kibana.version.startswith("7.9")

def test_kibana_is_enabled_and_running(host):
    kibana = host.service("kibana")
    assert kibana.is_enabled
    assert kibana.is_running