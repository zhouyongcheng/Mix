http://localhost:9200/sell_out_trace_idx-2018.12.22/_search
{
    "_source": [
        "requestTime",
        "channel",
        "url",
        "sellOutBasicVo.storeCode",
        "sellOutBasicVo.productDisableList.linkId"
    ],
    "query" : {
        "bool": {
            "must" : [
                {
                    "term" : {
                        "notifyType": "1"
                    }
                }
            ]
        }
    }
}