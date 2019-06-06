

You just need to put this in the connect-avro-distributed.properties to use multi schema registry：

key.converter.schema.registry.url=http://node1:8081,http://node2:8081
value.converter.schema.registry.url=http://node1:8081,http://node2:8081