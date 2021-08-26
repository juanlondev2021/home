global class UpdateDelivery implements Database.Batchable<sObject>{
    
    String query = 'SELECT ID,User_Address_Type__c FROM User_Address__c';
    global UpdateDelivery(){
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<User_Address__c> scope){
        for(User_Address__c currVar : scope){
            currVar.User_Address_Type__c = currVar.User_Address_Type__c;
        }
        try{
            update scope;    
        }catch(exception ex){
            system.debug('error'+ex.getMessage());
        }
        
    }
    global void finish(Database.BatchableContext BC){
    }
}