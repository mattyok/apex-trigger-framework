# apex-trigger-framework
Lightweight trigger framework with recursion check, multiple handlers and configurable disabling.

[![Deploy](https://deploy-to-sfdx.com/dist/assets/images/DeployToSFDX.svg)](https://deploy-to-sfdx.com/)

### Packaging
Supports packaging development model. Uses custom metadata to configure which trigger handlers to run. By configuring it through the interface, you can create multiple handlers for a single object/trigger which can be used in the packaging development model. This lets you set the order in which each package should fire their trigger. 

### Recursion
Each handler is run once for each trigger context. If you need to override this and run a trigger handler more than once you can remove it from the executed contexts by calling
```
TriggerDispatcher.executedTriggerContexts.remove(YOUR_CONTEXT);
eg. TriggerDispatcher.executedTriggerContexts.remove('AccountTriggerHandlerBEFORE_UPDATE');
```

### Example on Account
Deploy framework classes: `ITriggerHandler.cls`, `TriggerDispatcher.cls`, `TriggerDispatcherTest.cls`

#### Create a trigger

![Account Trigger](https://github.com/mattyok/apex-trigger-framework/blob/master/images/trg.PNG)

#### Create a few handlers (these would be in separate packages)

Sales Handler

![Sales Handler](https://github.com/mattyok/apex-trigger-framework/blob/master/images/saleshandler.PNG)

Marketing Handler

![Marketing Handler](https://github.com/mattyok/apex-trigger-framework/blob/master/images/mkthandler.PNG)

#### Add metadata to define handler execution

![Metadata](https://github.com/mattyok/apex-trigger-framework/blob/master/images/mdt.PNG)

#### Update an account and see the results

![Account before](https://github.com/mattyok/apex-trigger-framework/blob/master/images/acc.PNG)

![Account after](https://github.com/mattyok/apex-trigger-framework/blob/master/images/acc2.PNG)

