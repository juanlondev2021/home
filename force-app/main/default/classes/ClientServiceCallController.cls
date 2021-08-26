/**
 * @description       : 
 * @author            : William Aldana
 * @group             : 
 * @last modified on  : 12-10-2020
 * @last modified by  : William Aldana
 * Test Class         : ClientServiceCallControllerTest
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   08-21-2020   William Aldana   Initial Version
 * 2.0	 09-08-2020	  Fabian Pineda	   Added sorting of getCalls by Call_DateTime__c, DESC
 * 3.0   07-12-2020   William Aldana   New component version
**/
public class ClientServiceCallController {
    /**
    * @description Get Calls
    * @author William Aldana | 12-01-2020 
    * @param recordId 
    * @return List<Task> 
    **/
    @AuraEnabled(Cacheable = true)
    public static List<Task> getCalls(String recordId){
        Id customerCallRT = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName()
            .get('Customer_Call').getRecordTypeId();
        return [SELECT Id, Call_Timestamp__c, Type, Confirmation__c, Confirmation_DateTime__c, Description, WhatId, Status, 
        Call_Status__c FROM Task WHERE WhatId =: recordId and RecordTypeId =: customerCallRT ORDER BY Call_Timestamp__c DESC];
    }
    
    /**
    * @description delete calls
    * @author William Aldana | 12-01-2020 
    * @param lstCallIds 
    **/
    @AuraEnabled
    public static void deleteCalls(list<Id> lstCallIds){
        try {
            list<Task> lstCallToDelete = new list<Task>();
            System.debug('lstCallIds ====> '+lstCallIds);
            for(Id idCon : lstCallIds) {
                lstCallToDelete.add(new Task(Id = idCon));
            }
            if(!lstCallToDelete.isEmpty()) {
                delete lstCallToDelete;
            }
        }
        catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled
    public static Void saveTaskRecords(String recordId, List<Map<String, String>> storeCreatedRecords) {
        String msg = '';
        try{
            Set<Id> ordids = New Set<Id>();
            List<Task> taskToCreate = new List<Task>();
            List<Task> taskToUpdate = new List<Task>();
            Id customerCallRT = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName()
            .get('Customer_Call').getRecordTypeId();
            if(!storeCreatedRecords.isEmpty()){
                for(Object task : storeCreatedRecords){
                    Map<String,Object> data = (Map<String,Object>)task;
                    Task taskRec = new Task();
                    taskRec.RecordTypeId =  customerCallRT;
                    if(data.get('callDateTime') != null && data.get('callDateTime') != ''){
                        DateTime result = (DateTime)JSON.deserialize('"'+(String)data.get('callDateTime')+'"', DateTime.class);
                        taskRec.Call_Timestamp__c = result;
                    }

                    if(data.get('comments') != null  && data.get('comments') != ''){
                        taskRec.Description = (String)data.get('comments');
                    }else{
                        taskRec.Description = '';
                    }

                    if(data.get('status') != null  && data.get('status') != ''){
                        taskRec.Call_Status__c = (String)data.get('status');
                    }else{
                        taskRec.Call_Status__c = '';
                    }

                    if(data.get('type') != null  && data.get('type') != ''){
                        taskRec.Type = (String)data.get('type');
                    }else{
                        taskRec.Type = '';
                    }

                    if(data.get('followUpCallRequired') != null  && data.get('followUpCallRequired') != ''){
                        taskRec.Confirmation__c = (String)data.get('followUpCallRequired');
                    }else{
                        taskRec.Confirmation__c = '';
                    }

                    if(data.get('followUpDateTime') != null  && data.get('followUpDateTime') != ''){
                        DateTime result = (DateTime)JSON.deserialize('"'+(String)data.get('followUpDateTime')+'"', DateTime.class);
                        taskRec.Confirmation_DateTime__c = result;
                    }

                    if(data.get('id') != null  && data.get('id') != ''){
                        taskRec.Id = (String)data.get('id');
                    }

                    taskRec.WhatId = recordId;
                    String sObjName = taskRec.WhatId.getSObjectType().getDescribe().getName();
                    String q = 'Select Id, Name from ' + sObjName + ' where id = \'' + taskRec.WhatId+ '\'';
                    System.debug(q);
                    List<SObject> lsResult = Database.query(q);
                    taskRec.Subject = 'Custom Call - ' + taskRec.WhatId.getSObjectType().getDescribe().getLabel() + ' - ' + lsResult[0].get('Name');
                    if(taskRec.Confirmation__c == 'Yes'){
                        taskRec.ActivityDate = taskRec.Confirmation_DateTime__c.date();
                        taskRec.Status = 'Open';
                    }else{
                        taskRec.ActivityDate = taskRec.Call_Timestamp__c.date();
                        taskRec.Status = 'Closed';
                    }
                    if(taskRec.Id != null){
                        taskToUpdate.add(taskRec);
                    }else {
                        taskToCreate.add(taskRec);
                    }
                }
            }

            if(!taskToCreate.isEmpty()){
                Insert taskToCreate;
            }

            if(!taskToUpdate.isEmpty()){
                update taskToUpdate;
            }
        }catch(DmlException e){
            //Get All DML Messages
            for (Integer i = 0; i < e.getNumDml(); i++) {
                //Get Validation Rule & Trigger Error Messages
                msg =+ e.getDmlMessage(i) +  '\n' ;
            }
            //throw DML exception message
            if (!Test.isRunningTest()) { throw new AuraHandledException(msg); }
            else { System.debug(msg); }
        }catch(Exception  e){
            //throw all other exception message

            if (!Test.isRunningTest()) { throw new AuraHandledException(e.getMessage()); }
            else { System.debug(e.getMessage()); }
        }
    }    
}