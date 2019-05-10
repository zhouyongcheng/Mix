

import java.util.List;

@Repository
public class MongoSoldOutRepository {


    @Autowired
    private MongoTemplate mongoTemplate;

    public List<TDProductSellOut> listAllSellOut() {
        return null;
    }

    public void saveSoldOut(TDProductSellOut soldout) {
        mongoTemplate.save(soldout, "T_D_PRODUCT_SELL_OUT");
    }

    public void batchSaveSoldOutTasks(List<TDProductSellOutTask> tasks) {
        mongoTemplate.insert(tasks, T_D_PRODUCT_SELL_OUT_TASK);
    }

    public void batchSaveSoldOutTaskMappings(List<TDProductSellOutTaskMapping> mappings) {
        mongoTemplate.insert(mappings, T_D_PRODUCT_SELL_OUT_TASK_MAPPING);
    }

}
