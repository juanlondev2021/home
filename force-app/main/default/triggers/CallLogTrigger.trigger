trigger CallLogTrigger on Call_Log__c (before insert,before update,before delete,after insert,after update,after delete,after undelete) {    
    if(trigger.isafter && trigger.isinsert  ){
        CallLogTriggerHelper.afterInsertHandler(trigger.newMap);
    }
    if(trigger.isafter && trigger.isupdate ){
        CallLogTriggerHelper.afterUpdateHandler(trigger.newMap);
    }   
}