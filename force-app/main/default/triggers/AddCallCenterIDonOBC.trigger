trigger AddCallCenterIDonOBC on OB_Campaign__c (before insert, before update) {

    //get the oppotyunity Id's and store it in a set.
    set<Id> opptyIdSet = new set<Id>();
    for(OB_Campaign__c obc : trigger.new){
        if(obc.opportunity__c != null){
            opptyIdSet.add(obc.opportunity__c);
        }
    }
    
    //query the opportunity records and get the associated accounts.
    map<id, Opportunity> opptyMap = new map<id, opportunity>([SELECT id, OB_Campaign_Call_Center__c from Opportunity where Id IN: opptyIdSet]);

    //update the call center value based on the opportunity in the record.
    for(OB_Campaign__c obc: trigger.new){
        if(opptyMap.containsKey(obc.opportunity__c)){
            obc.OB_Campaign_Call_Center__c = opptyMap.get(obc.opportunity__c).OB_Campaign_Call_Center__c;
        }       
    }
}