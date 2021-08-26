global class UpdateDevliveryobject implements Database.Batchable<sObject> {    
/*************************************************************************************************************************************************************************************************************************************************************************************
* Class Name : UpdateDevliveryobject
* Created By : Priyanka Shanmugam
* Created Date : 3/25/2016
* Description : This Batch class will get executed daily and create a Delivery Object record, if the account don't have delivery already and meet specified values in the delivery parameter.
***************************************************************************************************************************************************************************************************************************************************************************************/
    global string query;    
    public UpdateDevliveryobject(){
        query = 'SELECT Id FROM Account WHERE isPersonAccount = true AND Branch__c != null AND (Sale_Date__c != null OR Recording_Date__c != null) AND Respond_Date__c = null AND createddate >= 2016-02-01T00:00:00.000Z';
    }
    
    // Get the list of accounts that has no delivery records associated to it.
    global Database.QueryLocator start(Database.BatchableContext BC) {               
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> accountList) {
        Map<Id,List<Delivery_Object__c>> accountDeliveryObjectCount = new Map<Id,List<Delivery_Object__c>>();
        List<Delivery_Object__c> deliveriesObjects = new List<Delivery_Object__c>();
        deliveriesObjects = [SELECT ID, Person_Account__c,name FROM Delivery_Object__c WHERE isRecent__c = false AND  hung_status__c != 'Send to Cheetah' AND hung_status__c != 'Canceled' AND Person_Account__c IN : accountList];
        for(Delivery_Object__c deliverObject : deliveriesObjects){
            if(accountDeliveryObjectCount.containsKey(deliverObject.Person_Account__c)){
                List<Delivery_Object__c> tempDeliverObject = accountDeliveryObjectCount.get(deliverObject.Person_Account__c);
                tempDeliverObject.add(deliverObject);
                accountDeliveryObjectCount.put(deliverObject.Person_Account__c,tempDeliverObject);
            }
            else{
                accountDeliveryObjectCount.put(deliverObject.Person_Account__c, new List<Delivery_Object__c>{deliverObject} );
            }  
        }
        for(Delivery_Object__c deliverObject : deliveriesObjects){
            
            if(deliverObject.name == '1' && accountDeliveryObjectCount.containskey(deliverObject.Person_Account__c) && accountDeliveryObjectCount.get(deliverObject.Person_Account__c).size() == 1){
            	deliverObject.IsRecent__c = true;    
            }
            if(deliverObject.name == '2' && accountDeliveryObjectCount.containskey(deliverObject.Person_Account__c) && accountDeliveryObjectCount.get(deliverObject.Person_Account__c).size() == 2){
            	deliverObject.IsRecent__c = true;    
            }
        
        }
        if(deliveriesObjects.size() > 0){
            try{
                update deliveriesObjects;
                
            }Catch(Exception ex){
                
            }
        }    
    }
    global void finish(Database.BatchableContext BC){
       
    }
}