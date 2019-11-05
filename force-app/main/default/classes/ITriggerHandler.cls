public interface ITriggerHandler {
    Boolean isDisabled();

    void beforeInsert(List<SObject> newItemList);
    void beforeUpdate(Map<Id, SObject> newItemMap, Map<Id, SObject> oldItemMap);
    void beforeDelete(Map<Id, SObject> oldItemMap);
    
    void afterInsert(List<SObject> newItemList);
    void afterUpdate(Map<Id, SObject> newItemMap, Map<Id, SObject> oldItemMap);
    void afterDelete(Map<Id, SObject> oldItemMap);
    void afterUndelete(Map<Id, SObject> newItemMap);

    /*
        Replace [SObjectName] with the API name of the triggered SObject

        // Object trigger
        trigger [SObjectName] on [SObjectName] (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
            TriggerDispatcher.run(new [SObjectName]TriggerHandler());
        }

        // TriggerHandler class
        public class [SObjectName]TriggerHandler implements ITriggerHandler {
            public Boolean isDisabled() {return false;}

            public void beforeInsert(List<SObject> newItemList) {}
            public void beforeUpdate(Map<Id, SObject> newItemMap, Map<Id, SObject> oldItemMap) {}
            public void beforeDelete(Map<Id, SObject> oldItemMap) {}
            
            public void afterInsert(List<SObject> newItemList) {}
            public void afterUpdate(Map<Id, SObject> newItemMap, Map<Id, SObject> oldItemMap) {}
            public void afterDelete(Map<Id, SObject> oldItemMap) {}
            public void afterUndelete(Map<Id, SObject> newItemMap) {}
        }
    */

}
