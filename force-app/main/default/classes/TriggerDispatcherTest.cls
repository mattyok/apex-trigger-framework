@isTest
public class TriggerDispatcherTest {
    
    @isTest
    static void testInsert() {
        TriggerDispatcher.handlerExecutionMap = new Map<String, List<String>>();
        TriggerDispatcher.handlerExecutionMap.put('Account', new List<String>{ 'TriggerDispatcherTest.TestAccountHandler' });
        Test.startTest();
        TriggerDispatcher.triggerObjectOverride = 'Account';
        TriggerDispatcher.triggerContextOverride = System.TriggerOperation.BEFORE_INSERT;
        TriggerDispatcher.run();
        TriggerDispatcher.triggerContextOverride = System.TriggerOperation.AFTER_INSERT;
        TriggerDispatcher.run();
        Test.stopTest();

        System.assertEquals(2, TriggerDispatcher.executedTriggerContexts.size());
        System.assert(TriggerDispatcher.executedTriggerContexts.contains('TriggerDispatcherTest.TestAccountHandlerBEFORE_INSERT'));
        System.assert(TriggerDispatcher.executedTriggerContexts.contains('TriggerDispatcherTest.TestAccountHandlerAFTER_INSERT'));
    }
    
    @isTest
    static void testUpdate() {
        TriggerDispatcher.handlerExecutionMap = new Map<String, List<String>>();
        TriggerDispatcher.handlerExecutionMap.put('Account', new List<String>{ 'TriggerDispatcherTest.TestAccountHandler' });
        Test.startTest();
        TriggerDispatcher.triggerObjectOverride = 'Account';
        TriggerDispatcher.triggerContextOverride = System.TriggerOperation.BEFORE_UPDATE;
        TriggerDispatcher.run();
        TriggerDispatcher.triggerContextOverride = System.TriggerOperation.AFTER_UPDATE;
        TriggerDispatcher.run();
        Test.stopTest();

        System.assertEquals(2, TriggerDispatcher.executedTriggerContexts.size());
        System.assert(TriggerDispatcher.executedTriggerContexts.contains('TriggerDispatcherTest.TestAccountHandlerBEFORE_UPDATE'));
        System.assert(TriggerDispatcher.executedTriggerContexts.contains('TriggerDispatcherTest.TestAccountHandlerAFTER_UPDATE'));
    }
    
    @isTest
    static void testDeleteUndelete() {
        TriggerDispatcher.handlerExecutionMap = new Map<String, List<String>>();
        TriggerDispatcher.handlerExecutionMap.put('Account', new List<String>{ 'TriggerDispatcherTest.TestAccountHandler' });
        Test.startTest();
        TriggerDispatcher.triggerObjectOverride = 'Account';
        TriggerDispatcher.triggerContextOverride = System.TriggerOperation.BEFORE_DELETE;
        TriggerDispatcher.run();
        TriggerDispatcher.triggerContextOverride = System.TriggerOperation.AFTER_DELETE;
        TriggerDispatcher.run();
        TriggerDispatcher.triggerContextOverride = System.TriggerOperation.AFTER_UNDELETE;
        TriggerDispatcher.run();
        Test.stopTest();

        System.assertEquals(3, TriggerDispatcher.executedTriggerContexts.size());
        System.assert(TriggerDispatcher.executedTriggerContexts.contains('TriggerDispatcherTest.TestAccountHandlerBEFORE_DELETE'));
        System.assert(TriggerDispatcher.executedTriggerContexts.contains('TriggerDispatcherTest.TestAccountHandlerAFTER_DELETE'));
        System.assert(TriggerDispatcher.executedTriggerContexts.contains('TriggerDispatcherTest.TestAccountHandlerAFTER_UNDELETE'));
    }
    
    @isTest
    static void testRecursion() {
        TriggerDispatcher.handlerExecutionMap = new Map<String, List<String>>();
        TriggerDispatcher.handlerExecutionMap.put('Account', new List<String>{ 'TriggerDispatcherTest.TestAccountHandler' });
        Test.startTest();
        TriggerDispatcher.triggerObjectOverride = 'Account';
        TriggerDispatcher.triggerContextOverride = System.TriggerOperation.BEFORE_UPDATE;
        TriggerDispatcher.run();
        TriggerDispatcher.run();
        Test.stopTest();

        System.assertEquals(1, TriggerDispatcher.executedTriggerContexts.size());
        System.assert(TriggerDispatcher.executedTriggerContexts.contains('TriggerDispatcherTest.TestAccountHandlerBEFORE_UPDATE'));
    }
    
    @isTest
    static void testGetTriggerHandlerExecutionMdt() {
        Test.startTest();
        TriggerDispatcher.triggerObjectOverride = 'Account';
        TriggerDispatcher.triggerContextOverride = System.TriggerOperation.BEFORE_UPDATE;
        TriggerDispatcher.run();
        Test.stopTest();
        
        System.assertEquals(0, TriggerDispatcher.executedTriggerContexts.size());
    }

    public class TestAccountHandler implements ITriggerHandler {
        
        public void beforeInsert(List<SObject> newItemList) {}
        public void beforeUpdate(Map<Id, SObject> newItemMap, Map<Id, SObject> oldItemMap) {}
        public void beforeDelete(Map<Id, SObject> oldItemMap) {}
        
        public void afterInsert(List<SObject> newItemList) {}
        public void afterUpdate(Map<Id, SObject> newItemMap, Map<Id, SObject> oldItemMap) {}
        public void afterDelete(Map<Id, SObject> oldItemMap) {}
        public void afterUndelete(Map<Id, SObject> newItemMap) {}
    }

}