public class TriggerDispatcher {

    @testVisible
    static System.TriggerOperation triggerContextOverride;

    public static Set<String> executedTriggerContexts = new Set<String>();
    public static void run(ITriggerHandler handler, String triggerObject) {

        if(handler.isDisabled()) {
            return;
        }
        
        System.TriggerOperation triggerContext = getTriggerContext();
        String triggerExecutionName = triggerObject + triggerContext;

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

}
