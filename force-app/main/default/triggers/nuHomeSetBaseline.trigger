/*********************************************************************
  Description : For the new opportunities except cloned and close won opportunities, 
  the nuHomeBaseline record type will be set by default.

**********************************************************************/
trigger nuHomeSetBaseline on Opportunity (before insert) {
//Fetching recordtype id for nuHome Baseline record type.
Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('nuHome Baseline').getRecordTypeId();
    for(Opportunity opp:Trigger.new){
    
        if(!opp.Closed_Won__c){
        if(!test.isRunningtest()){
        //Assigning nuHome Baseline record type.
           opp.recordtypeid = devRecordTypeId;
           }
         }
    }
}