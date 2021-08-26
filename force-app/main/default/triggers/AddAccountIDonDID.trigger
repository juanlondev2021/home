trigger AddAccountIDonDID on DID__c (before insert, before update) {

    //get the oppotyunity Id's and store it in a set.
    set<Id> opptyIdSet = new set<Id>();
    for(DID__c DIDList : trigger.new){
        if(DIDList.opportunity__c != null){
            opptyIdSet.add(DIDList.opportunity__c);
        }
    }
    
    //query the opportunity records and get the associated accounts.
    map<id, Opportunity> opptyMap = new map<id, opportunity>([SELECT id, accountid from Opportunity where Id IN: opptyIdSet]);

    //update the account value based on the opportunity in the record.
    for(DID__c DIDList: trigger.new){
        if(opptyMap.containsKey(DIDList.opportunity__c)){
            DIDList.Account__c = opptyMap.get(DIDList.opportunity__c).accountId;
        }       
    }
}