import pytest

@pytest.mark.parametrize("name,version", [
    ("elasticsearch", "7.9"),
    ("openjdk-11-jre", "11"),
])
def test_packages(host, name, version):
    pkg = host.package(name)
    assert pkg.is_installed
    assert pkg.version.startswith(version)