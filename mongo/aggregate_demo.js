db.T_D_PRODUCT_SELL_OUT_TASK_MAPPING.aggregate([
	{$group: {_id: {comboId:"$comboId",productId: "$productId", productLevel: "$productLevel"}}},
	{"$project": {_id: 0, comboId: "$_id.comboId", productId: "$_id.productId", productLevel: "$_id.productLevel"}},
	{$out: "T_D_PRODUCT_SELL_OUT_TASK_MAPPING_RESULT"}
])

