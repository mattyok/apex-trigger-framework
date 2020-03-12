// EXAMPLE
public class mkt_AccountTriggerHandler extends TriggerHandler {

    public override void beforeUpdate(Map<Id, SObject> newItemMap, Map<Id, SObject> oldItemMap) {
        for(SObject obj : newItemMap.values()) {
            Account a = (Account)obj;
            a.Name = a.Name + ':456';
        }
    }

}