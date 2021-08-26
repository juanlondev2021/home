/**********************************************************************************************************************
Author: MST Developer
Description : Used to populate value to ExternalId(County_State__c) field by 
              combination of State & CountyName value with ':' as separator.
**********************************************************************************************************************/

trigger CountyTrigger on County__c (before insert,before update) {    
    for(County__c county : Trigger.New){
        if(Trigger.isInsert){
            //If County_State__c field value is empty then we assgin the value for the first time during insertion.
            if(county.County_state__c == null){
                county.County_state__c = county.State__c + ':' + county.County_Name__c;
            }
        }
        if(Trigger.isUpdate){
            //if CountyName or State value gets changed, then we update changed value to the County_state__c.
            if(Trigger.oldMap.get(county.id).State__c != county.State__c || 
               Trigger.oldMap.get(county.id).County_Name__c != county.County_Name__c){
               county.County_state__c = county.State__c + ':' + county.County_Name__c;
            }
        }
    }
}