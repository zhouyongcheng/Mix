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