/*******************************************************************
Description :  When the ‘Last Dialed Number flag is checked, Active CPL Join is Active and Destination Number is not Blank.
               then Lead Distribution record should be updated 
               with the next Opp in the queue and ‘Last Dialed Number’ flag should be unchecked.
********************************************************************/
trigger UpdateCPLJoinInfo on Lead_Distribution__c (after update) {

  if(Trigger.isAfter && Trigger.isUpdate)
  {
    UpdateCPLJoinInfoHandler.UpdateBillingOpp(Trigger.newMap,Trigger.oldMap);
  }

}