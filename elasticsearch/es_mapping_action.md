curl -XPOST localhost:9200/_aliases -d '
{
	"actions": [
	    {
	    	"remove": {
	    		"alias": "my_index",
	    		"index": "my_index_v0"
	    	}
	    },
		{
			"add" : {
			  "alias":"my_index",
			  "index": "my_index_v1"
			}
		}
	]
}
'

## 删除索引
curl -XDELETE locahost:9200/my_index_v0

## 修改mapping，添加属性。
curl -XPUT /my_index/_mapping/doc -H 'Content-Type: application/json' -d '
{
	"properties": {
		"tag" : {
			"type":"string"
			"index": "not_analyzed"
		}
	}
}
'	

