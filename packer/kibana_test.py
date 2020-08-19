def test_kibana_is_installed(host):
    kibana = host.package("elasticsearch")
    assert kibana.is_installed
    assert kibana.version.startswith("7.9")