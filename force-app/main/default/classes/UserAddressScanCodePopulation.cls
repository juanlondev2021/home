global class UserAddressScanCodePopulation implements Database.Batchable<sObject> {    
/*************************************************************************************************************************************************************************************************************************************************************************************
* Class Name : UserAddressScanCodePopulation
* Created By : Priyanka Shanmugam
* Created Date : 5/2/2016
* Description : This Batch class is used to update the scan code of user address from the recently created delivery 
if the scan code value is '0000 0000'.
***************************************************************************************************************************************************************************************************************************************************************************************/
    global string query;    
    public UserAddressScanCodePopulation(){
        query = 'SELECT Id FROM User_Address__c WHERE userAccount__r.isPersonAccount = true AND Scan_code__c != null AND scan_code__c = \'0000 0000\'';
    }
    
    // Get the list of accounts that has no delivery records associated to it.
    global Database.QueryLocator start(Database.BatchableContext BC) {               
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<User_Address__c> userAddressList) {
        Map<Id,User_Address__c> userAddressMap = new Map<Id,User_Address__c>();        
        Set<Id> userAddressIds = new Set<Id>();
       // Get the user Address Ids
        if(!userAddressList.isEmpty()){
            for(User_Address__c userAddress : userAddressList){
                userAddressIds.add(userAddress.Id);
            }
        }
        // Get the deliveries with the updated scan code
        if(!userAddressIds.isEmpty()){
            for(Delivery_object__c delivery : [SELECT Id,Scan_code__c,User_Address__c FROM Delivery_Object__c WHERE User_Address__C IN : userAddressIds AND Scan_Code__c != '0000 0000' Order By CreatedDate DESC]){
                if(!userAddressMap.containsKey(delivery.User_Address__c)){
                    userAddressMap.put(delivery.User_Address__c,new User_Address__c(Id = delivery.User_Address__c,Scan_code__c = delivery.Scan_code__c));
                }
            }
        }
            
        if(userAddressMap.size() > 0){
            try{
                update userAddressMap.values();
                
            }Catch(Exception ex){
                System.debug('Error occured While updating the user address' + ex.getMessage());
            }
        }    
    }
    global void finish(Database.BatchableContext BC){
       
    }
}