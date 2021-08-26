/***********************************************************************************
* Trigger Name : PropertyTrigger
* Created By   : Priyanka Shanmugam  
* Created Date : 3/30/2016
* Author       : MST Developer
* Description  : This trigger will populate the steet,city and state of the address to 
the property name

****************************************************************************************/
trigger PropertyTrigger on Property__c (before insert,before update) {

    Set<Id> addressIds;
    Map<Id,String> addressMap;
    
    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
        addressIds = new Set<Id>();
        for(Property__c property : Trigger.New){
            addressIds.add(property.Address__c);
        }
    }
   // Append the street,city and state field values to the property name
    if(addressIds.size()>0){
    addressMap = new Map<Id,String>();
   for(Address__c address : [SELECT Id,Name,Street__c,City__c,State__c FROM Address__c WHERE Id IN: addressIds AND Street__c != null 
                                       AND City__c != null AND State__c != null]){
       addressMap.put(address.Id,address.Street__c + ':' + address.City__c + ':' + address.State__c);                                    
   }
    }
   if(addressMap.size() > 0){
       for(Property__c property : Trigger.New){
            if(addressMap.containsKey(property.address__c)){
                if(Trigger.isInsert? property.address__c != null : property.Name != addressMap.get(property.address__c)){
                    property.Name = addressMap.get(property.address__c);
                }
            }
        }
   }                                         
}