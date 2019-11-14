public class TriggerDispatcher {

    // Private, only able to be set via test class
    @testVisible
    private static String triggerObjectOverride;
    @testVisible
    private static System.TriggerOperation triggerContextOverride;

    // This is test visible because without metadata, you cannot execute as normal so in a unit test without any real triggers you must mock it
    // This allows deployment of this framework without any actual handlers
    @testVisible
    private static Map<String, List<String>> handlerExecutionMap;
    public static Set<String> executedTriggerContexts = new Set<String>();

    /**
    * run
    * Retrieves all metadata, once-bulkified, and stores in a static map
    * Dynamically determines which object is the trigger context
    * Switch on trigger context
    * Prevents recursion using a key of "handler class name" + "trigger context"
    */
    public static void run() {

        String triggerObject = getTriggerObject();
        System.TriggerOperation triggerContext = getTriggerContext();

        // String list of all handler names from the custom metadata
        List<String> handlerClassNames = getHandlers(triggerObject);
        if(handlerClassNames == null) {
            return;
        }

        for(String handlerClassName : handlerClassNames) {
            // Unique name combining the handler class name and trigger context
            // eg. AccountHandlerBEFORE_UPDATE
            String triggerExecutionName = handlerClassName + triggerContext;
            // Dynamically get the handler class from the configured metadata
            ITriggerHandler handler = (ITriggerHandler)Type.forName(handlerClassName).newInstance();
        
            switch on triggerContext {
                when BEFORE_INSERT {
                    if(isFirstExecution(triggerExecutionName)) {
                        handler.beforeInsert(Trigger.new);
                    }
                }
                when BEFORE_UPDATE {
                    if(isFirstExecution(triggerExecutionName)) {
                        handler.beforeUpdate(Trigger.newMap, Trigger.oldMap);
                    }
                }
                when BEFORE_DELETE {
                    if(isFirstExecution(triggerExecutionName)) {
                        handler.beforeDelete(Trigger.oldMap);
                    }
                }
                when AFTER_INSERT {
                    if(isFirstExecution(triggerExecutionName)) {
                        handler.afterInsert(Trigger.new);
                    }
                }
                when AFTER_UPDATE {
                    if(isFirstExecution(triggerExecutionName)) {
                        handler.afterUpdate(Trigger.newMap, Trigger.oldMap);
                    }
                }
                when AFTER_DELETE {
                    if(isFirstExecution(triggerExecutionName)) {
                        handler.afterDelete(Trigger.oldMap);
                    }
                }
                when AFTER_UNDELETE {
                    if(isFirstExecution(triggerExecutionName)) {
                        handler.afterUndelete(Trigger.newMap);
                    }
                }
            }
        }
    }

    /**
    * getTriggerObject
    * Gets the override trigger object enum or the real Trigger object
    */
    static String getTriggerObject() {
        return triggerObjectOverride == null ? (Trigger.new == null ? Trigger.old[0].getSObjectType().getDescribe().getName() : Trigger.new[0].getSObjectType().getDescribe().getName()) : triggerObjectOverride;
    }

    /**
    * getTriggerContext
    * Gets the override trigger context enum or the real Trigger.operationType enum
    */
    static System.TriggerOperation getTriggerContext() {
        return triggerContextOverride == null ? Trigger.operationType : triggerContextOverride;
    }

    /**
    * isFirstExecution
    * Check if handler has executed this context already
    * If it has run return false
    * If it has not run, add it to the set to prevent future executions and return true
    * @param String triggerExecutionName unique concat string key of the handler class name and trigger context
    * @return Boolean if the handler and context has executed already
    */
    static Boolean isFirstExecution(String triggerExecutionName) {
        if(executedTriggerContexts.contains(triggerExecutionName)) {
            return false;
        }
        executedTriggerContexts.add(triggerExecutionName);
        return true;
    }

    /**
    * getHandlers
    * @param String triggerObject an SObject API Name 
    * @return a List<String> of Apex Class names to create Types for and run the handlers
    */
    static List<String> getHandlers(String triggerObject) {
        if(handlerExecutionMap == null) {
            getTriggerHandlerExecutionMdt();
        }
        return handlerExecutionMap.get(triggerObject);
    }

    /**
    * getTriggerHandlerExecutionMdt
    * Initialize the static map
    * Retrieve all metadata at once and create the map to be used in all trigger execution for a single transaction
    */
    static void getTriggerHandlerExecutionMdt() {
        handlerExecutionMap = new Map<String, List<String>>();

        List<Trigger_Handler_Execution__mdt> handlerExecutions = [SELECT SObject_Name__c, Handler_Class_Name__c FROM Trigger_Handler_Execution__mdt WHERE Is_Disabled__c = false ORDER BY Execution_Order__c];
        for(Trigger_Handler_Execution__mdt handlerExecution : handlerExecutions) {
            if(handlerExecutionMap.get(handlerExecution.SObject_Name__c) == null) {
                handlerExecutionMap.put(handlerExecution.SObject_Name__c, new List<String>());
            }
            handlerExecutionMap.get(handlerExecution.SObject_Name__c).add(handlerExecution.Handler_Class_Name__c);
        }
    }
}