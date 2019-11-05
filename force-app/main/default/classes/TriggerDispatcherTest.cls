@isTest
public class TriggerDispatcherTest {
    
    @isTest
    static void testInsert() {
        Test.startTest();
        TriggerDispatcher.triggerContextOverride = System.TriggerOperation.BEFORE_INSERT;
        TriggerDispatcher.run(new TestTriggerHandler(), 'Account');
        TriggerDispatcher.triggerContextOverride = System.TriggerOperation.AFTER_INSERT;
        TriggerDispatcher.run(new TestTriggerHandler(), 'Account');
        Test.stopTest();

        System.assertEquals(2, TriggerDispatcher.executedTriggerContexts.size());
        System.assert(TriggerDispatcher.executedTriggerContexts.contains('AccountBEFORE_INSERT'));
        System.assert(TriggerDispatcher.executedTriggerContexts.contains('AccountAFTER_INSERT'));
    }
    
    @isTest
    static void testUpdate() {
        Test.startTest();
        TriggerDispatcher.triggerContextOverride = System.TriggerOperation.BEFORE_UPDATE;
        TriggerDispatcher.run(new TestTriggerHandler(), 'Account');
        TriggerDispatcher.triggerContextOverride = System.TriggerOperation.AFTER_UPDATE;
        TriggerDispatcher.run(new TestTriggerHandler(), 'Account');
        Test.stopTest();

        System.assertEquals(2, TriggerDispatcher.executedTriggerContexts.size());
        System.assert(TriggerDispatcher.executedTriggerContexts.contains('AccountBEFORE_UPDATE'));
        System.assert(TriggerDispatcher.executedTriggerContexts.contains('AccountAFTER_UPDATE'));
    }
    
    @isTest
    static void testDeleteUndelete() {
        Test.startTest();
        TriggerDispatcher.triggerContextOverride = System.TriggerOperation.BEFORE_DELETE;
        TriggerDispatcher.run(new TestTriggerHandler(), 'Account');
        TriggerDispatcher.triggerContextOverride = System.TriggerOperation.AFTER_DELETE;
        TriggerDispatcher.run(new TestTriggerHandler(), 'Account');
        TriggerDispatcher.triggerContextOverride = System.TriggerOperation.AFTER_UNDELETE;
        TriggerDispatcher.run(new TestTriggerHandler(), 'Account');
        Test.stopTest();

        System.assertEquals(3, TriggerDispatcher.executedTriggerContexts.size());
        System.assert(TriggerDispatcher.executedTriggerContexts.contains('AccountBEFORE_DELETE'));
        System.assert(TriggerDispatcher.executedTriggerContexts.contains('AccountAFTER_DELETE'));
        System.assert(TriggerDispatcher.executedTriggerContexts.contains('AccountAFTER_UNDELETE'));
    }
    
    @isTest
    static void testRecursion() {
        Test.startTest();
        TriggerDispatcher.triggerContextOverride = System.TriggerOperation.BEFORE_UPDATE;
        TriggerDispatcher.run(new TestTriggerHandler(), 'Account');
        TriggerDispatcher.run(new TestTriggerHandler(), 'Account');
        Test.stopTest();

        System.assertEquals(1, TriggerDispatcher.executedTriggerContexts.size());
        System.assert(TriggerDispatcher.executedTriggerContexts.contains('AccountBEFORE_UPDATE'));
    }
    
    @isTest
    static void testIsDisabled() {
        Test.startTest();
        TriggerDispatcher.triggerContextOverride = System.TriggerOperation.BEFORE_UPDATE;
        TestTriggerHandler testHandler = new TestTriggerHandler();
        testHandler.isDisabled = true;
        TriggerDispatcher.run(testHandler, 'Account');
        Test.stopTest();
        
        System.assertEquals(0, TriggerDispatcher.executedTriggerContexts.size());
    }

    class TestTriggerHandler implements ITriggerHandler {
        
        @testVisible
        Boolean isDisabled = false;
        public Boolean isDisabled() { 
            return this.isDisabled; 
        }

        public void beforeInsert(List<SObject> newItemList) {}
        public void beforeUpdate(Map<Id, SObject> newItemMap, Map<Id, SObject> oldItemMap) {}
        public void beforeDelete(Map<Id, SObject> oldItemMap) {}
        
        public void afterInsert(List<SObject> newItemList) {}
        public void afterUpdate(Map<Id, SObject> newItemMap, Map<Id, SObject> oldItemMap) {}
        public void afterDelete(Map<Id, SObject> oldItemMap) {}
        public void afterUndelete(Map<Id, SObject> newItemMap) {}
    }

}
