# apex-trigger-framework
Lightweight trigger framework with disabling and recursion checks

### Disabling
When the trigger is run, the dispatcher will check if the Handler is disabled by calling it's `isDisabled()` method. This can be defaulted to false or can implement a hierarchy custom setting with different checkbox fields to disable each individual trigger.

### Recursion
```
TriggerDispatcher.run(ITriggerHandler handler, String triggerObject) {...
eg. TriggerDispatcher.run(new AccountTriggerHandler(), 'Account');
```
The run method takes a String of the SObjectType name to use in the recursion check when combined with the TriggerOperation type. The decision to pass a String instead of a Type is based on minimizing heap and additional execution to pull the SObject name from an object.
