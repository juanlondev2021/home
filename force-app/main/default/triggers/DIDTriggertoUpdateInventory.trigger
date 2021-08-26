Trigger DIDTriggertoUpdateInventory on DID__c(after insert,after update)
{
    map<string,id> didMap = new map<string,id>();
    list<Inventory__c> inventoryList =  new list<Inventory__c>();
    for(DID__C currDID : trigger.new){
        If(Trigger.IsInsert || (Trigger.isUpdate && currDID.POC__c != Trigger.oldMap.get(currDID.Id).POC__c)){
           if(currDID.POC__c != NULL){
                String fphone = currDID.POC__c;
                if (fphone.length() == 10){
                    fphone = '(' + fphone.substring(0, 3) + ') ' + fphone.substring(3, 6) + '-' + fphone.substring(6);
                }
                didMap.put(fphone,currDID.id);
           }     
        }    
    }     
     
   if(!didMap.isEmpty())
   {
      InventoryQuery.queryFac(didMap);
   }
    
}