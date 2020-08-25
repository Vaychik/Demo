import pytest

@pytest.mark.parametrize("name,version", [
    ("kibana", "7.9"),
    ("grafana", "7"),
])
def test_packages(host, name, version):
    pkg = host.package(name)
    assert pkg.is_installed
    assert pkg.version.startswith(version)

@pytest.mark.parametrize("name", [
    ("kibana"),
])
def test_service_is_enabled_and_running(host, name):
    srv = host.service(name)
    assert srv.is_enabled
    assert srv.is_running