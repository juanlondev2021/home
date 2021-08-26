trigger updateDIDName on Inventory__c (before insert,before update) {

        map<string,id> didMap = new map<string,id>();
        set<string> didvalueSet = new set<string>();        
        for(Inventory__c currInventory : trigger.new){
            if(Trigger.IsInsert || Trigger.isUpdate && currInventory.DID__c != Trigger.oldMap.get(currInventory.id).DID__c){
                if(currInventory.DID__c != null ){
                    string didValue = string.valueOf(currInventory.DID__c).remove('(').remove(')').remove('-').replaceAll('\\s+','');
                    didvalueSet.add(didValue);
                }
                else 
                    currInventory.DID_Name__c = NULL;
            }
    }
        
    for(did__c didRecord : [select id, poc__c from did__c where POC__c in: didvalueSet])
       didMap.put(didRecord.poc__c , didRecord.id);
    
    for(inventory__c currInventory :trigger.new){
      if(Trigger.IsInsert || (Trigger.isUpdate && currInventory.DID__c != Trigger.oldMap.get(currInventory.id).DID__c)){
        if(currInventory.DID__c != null ){
            string didValue = string.valueOf(currInventory.DID__c).remove('(').remove(')').remove('-').replaceAll('\\s+','');
            if(didMap.containsKey(didValue))
                currInventory.DID_Name__c = didMap.get(didValue);
            else
                currInventory.DID_Name__c = NULL;
        }
      }
    }

}