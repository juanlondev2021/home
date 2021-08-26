/*
 * Reparent reassign = new Reparent();
reassign.query = 'SELECT Person_Account__c,User_Address__c FROM Delivery_Object__c WHERE isDeleted=false';
reassign.email='sankarm@mstsolutions.com';
reassign.field1 = 'Person_Account__c';
reassign.field2 = 'User_Address__c';
ID batchprocessid = Database.executeBatch(reassign);
System.debug('batchprocessid: '+batchprocessid);
*/

global class Reparent implements Database.Batchable<sObject>{
    global String query;
    global String email;
    global String field1;
    global String field2;
    
    global Database.querylocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);}
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        Set<Id> accIds = new Set<Id>();
        Map<Id,Id> accIdsWithUserAddressIds = new Map<Id,Id>();
        
        for(sObject s : scope){
            accIds.add((ID)s.get(field1));
        }
        for(User_Address__c  userAddress : [SELECT Id,UserAccount__c FROM User_Address__c WHERE UserAccount__c IN: accIds ]){
            accIdsWithUserAddressIds.put(userAddress.UserAccount__c,userAddress.Id);
        }
        for(sObject s : scope){
            if(accIdsWithUserAddressIds.containsKey((ID)s.get(field1))){
                s.put(field2,accIdsWithUserAddressIds.get((ID)s.get(field1)));
            }
        }        
        update scope;
    }
    global void finish(Database.BatchableContext BC){
		
    }
}