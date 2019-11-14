// EXAMPLE
public class mkt_AccountTriggerHandler implements ITriggerHandler {

    public void beforeInsert(List<SObject> newItemList) {}
    public void beforeUpdate(Map<Id, SObject> newItemMap, Map<Id, SObject> oldItemMap) {
        for(SObject obj : newItemMap.values()) {
            Account a = (Account)obj;
            a.Name = a.Name + ':456';
        }
    }
    public void beforeDelete(Map<Id, SObject> oldItemMap) {}
    
    public void afterInsert(List<SObject> newItemList) {}
    public void afterUpdate(Map<Id, SObject> newItemMap, Map<Id, SObject> oldItemMap) {}
    public void afterDelete(Map<Id, SObject> oldItemMap) {}
    public void afterUndelete(Map<Id, SObject> newItemMap) {}
}




