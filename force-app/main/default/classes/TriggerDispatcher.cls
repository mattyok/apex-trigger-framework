public class TriggerDispatcher {

    @testVisible
    static String triggerObjectOverride;
    @testVisible
    static System.TriggerOperation triggerContextOverride;

    @testVisible
    static Map<String, List<String>> handlerExecutionMap;
    public static Set<String> executedTriggerContexts = new Set<String>();

    public static void run() {

        String triggerObject = getTriggerObject();
        System.TriggerOperation triggerContext = getTriggerContext();

        List<String> handlerClassNames = getHandlers(triggerObject);
        if(handlerClassNames == null) {
            return;
        }

        for(String handlerClassName : handlerClassNames) {
            String triggerExecutionName = handlerClassName + triggerContext;
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

    static String getTriggerObject() {
        return triggerObjectOverride == null ? (Trigger.new == null ? Trigger.old[0].getSObjectType().getDescribe().getName() : Trigger.new[0].getSObjectType().getDescribe().getName()) : triggerObjectOverride;
    }

    static System.TriggerOperation getTriggerContext() {
        return triggerContextOverride == null ? Trigger.operationType : triggerContextOverride;
    }

    static Boolean isFirstExecution(String triggerExecutionName) {
        if(executedTriggerContexts.contains(triggerExecutionName)) {
            return false;
        }
        executedTriggerContexts.add(triggerExecutionName);
        return true;
    }

    /**
    * getHandlers
    * @param String of SObject API Name 
    * @return List<String> of Apex Classes of Type ITriggerHandler to run
    */
    static List<String> getHandlers(String triggerObject) {
        if(handlerExecutionMap == null) {
            getTriggerHandlerExecutionMdt();
        }
        return handlerExecutionMap.get(triggerObject);
    }

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