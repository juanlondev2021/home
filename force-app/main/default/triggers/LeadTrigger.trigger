/*********************************************************************
  Description : Whenever lead created from Data.com lead type will be updated as prospecting.

**********************************************************************/

trigger LeadTrigger on Lead (before insert) {
    
    for(Lead currLead : trigger.new){
        if(currLead.Jigsaw!=null){
            currLead.Lead_Type__c = 'Prospecting';
        }
            
    }

}