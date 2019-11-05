// EXAMPLE
public class AccountTriggerHandler implements ITriggerHandler {
    public Boolean isDisabled;
    public Boolean isDisabled() {
        if(this.isDisabled != null) {
            return this.isDisabled;
        }
        return Trigger_Settings__c.getOrgDefaults().AccountTrigger_IsDisabled__c;
    }

    public void beforeInsert(List<SObject> newItemList) {}
    public void beforeUpdate(Map<Id, SObject> newItemMap, Map<Id, SObject> oldItemMap) {}
    public void beforeDelete(Map<Id, SObject> oldItemMap) {}
    
    public void afterInsert(List<SObject> newItemList) {}
    public void afterUpdate(Map<Id, SObject> newItemMap, Map<Id, SObject> oldItemMap) {}
    public void afterDelete(Map<Id, SObject> oldItemMap) {}
    public void afterUndelete(Map<Id, SObject> newItemMap) {}
}
