trigger AddAccountIDonLD on Lead_Distribution__c (before insert, before update,after update) {

   if( (Trigger.isInsert || Trigger.isUpdate) && Trigger.isBefore)
   {
    //get the oppotyunity Id's and store it in a set.
    set<Id> opptyIdSet = new set<Id>();
    for(Lead_Distribution__c leaddist : trigger.new){
        if(leaddist.opportunity__c != null){
            opptyIdSet.add(leaddist.opportunity__c);
        }
    }
    
    //query the opportunity records and get the associated accounts.
    map<id, Opportunity> opptyMap = new map<id, opportunity>([SELECT id, accountid from Opportunity where Id IN: opptyIdSet]);

    //update the account value based on the opportunity in the record.
    for(Lead_Distribution__c leaddist: trigger.new){
        if(opptyMap.containsKey(leaddist.opportunity__c)){
            leaddist.Account__c = opptyMap.get(leaddist.opportunity__c).accountId;
        }       
    }
   }
    
 /*******************************************************************
Description :  When the ‘Last Dialed Number flag is checked, Active CPL Join is Active and Destination Number is not Blank.
               then Lead Distribution record should be updated 
               with the next Opp in the queue and ‘Last Dialed Number’ flag should be unchecked.
********************************************************************/ 
  if(Trigger.isAfter && Trigger.isUpdate)
  {
    UpdateCPLJoinInfoHandler.UpdateBillingOpp(Trigger.newMap,Trigger.oldMap);
  }
    
}