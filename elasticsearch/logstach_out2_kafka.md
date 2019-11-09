elasticsearch {
	hosts => ["localhost:9200"]
	action => "index"
	index => "dbname"
	document_type => "%{@type}"
	document_id => "ignore"
	template => "/opt/logstash-conf/es-template.json"
	template_name => "es-template.json"
	template_overwrite => true
	protocol => "http"
}


## logstash按时间进行索引的方式
```
output {
  elasticsearch {
    action => "index"
    hosts  => ["localhost:9200"]
    index  => "logstash-%{team}-%{+YYYY.MM.dd}"
    manage_template => false
    template_name => "logstash"
    template_overwrite => true
    document_type => "%{[@metadata][type]}"
  }
}

{
    "logstash": {
        "order": 1,
        "version": 50002,
        "template": "logstash-*",
        "settings": {
            "index": {
                "refresh_interval": "5s"
            }
        },
        "mappings": {
            "_default_": {
                "dynamic_templates": [
                {
                    "message_field": {
                        "path_match": "message",
                        "mapping": {
                            "norms": false,
                            "type": "text"
                        },
                        "match_mapping_type": "string"
                    }
                }
                ,
                {
                    "string_fields": {
                        "mapping": {
                        "norms": false,
                        "type": "text",
                            "fields": {
                                "keyword": {
                                    "type": "keyword"
                                }
                            }
                        },
                        "match_mapping_type": "string",
                        "match": "*"
                    }
                }
                ],
                "_all": {
                    "enabled": false
                },
                "properties": {
                    "@timestamp": {
                        "include_in_all": false,
                        "type": "date"
                    },
                    "geoip": {
                        "dynamic": true,
                        "properties": {
                            "ip": {
                                "type": "ip"
                            },
                            "latitude": {
                                "type": "half_float"
                            },
                            "location": {
                                "type": "geo_point"
                            },
                            "longitude": {
                                "type": "half_float"
                            }
                        }
                    },
                    "@version": {
                        "include_in_all": false,
                        "type": "keyword"
                    }
                }
            }
        },
        "aliases": { }
    }
}
```
