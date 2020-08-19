def test_elasticsearch_is_installed(host):
    elasticsearch = host.package("elasticsearch")
    assert elasticsearch.is_installed
    assert elasticsearch.version.startswith("7.9")