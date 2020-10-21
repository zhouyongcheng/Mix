### 多条件range查询

```json
post http://localhost:9200/sell_out_trace_idx-2020.09.18/_count
{
  "query": {
    "bool": {
      "must": [
        {
          "range": {
            "requestTime": {
              "gte": "2020-09-18 00:00:00",
              "lte": "2020-09-18 18:00:00"
            }
          }
        },
        {
          "term": {
            "channel": "0"
          }
        }
      ]
    }
  }
}
```

### 多条件and， or查询

```json
{
    "query": {
        "bool": {
            "must": {
                "bool" : { 
                    "should": [
                        { "match": { "about": "music" }},
                        { "match": { "about": "climb" }} ] 
                }
            },
            "must": {
                "match": { "first_nale": "John" }
            },
            "must_not": {
                "match": {"last_name": "Smith" }
            }
        }
    }
}
```

