/*************************************************************************************
Createdby: MST
Description : It will create case when Pending Cancelled is checked.
*************************************************************************************/

trigger CaseCreationOnCPLJoins on CPL_Joins__c (after insert, after update) {
   
   Map<Id,CPL_Joins__c> cplJoinMap = new Map<Id,CPL_Joins__c>();
   if(Trigger.isInsert)
   {
       CPLJoinCaseCreationHandler.createcase(Trigger.newMap);
   }
   if(Trigger.isUpdate)
   {
     for(CPL_Joins__c currRec : Trigger.new)
     {
        if(currRec.Pending_Cancelled__c == True && Trigger.oldMap.get(currRec.id).Pending_Cancelled__c == false)
        {
          cplJoinMap.put(currRec.id, currRec);
        }
     
     }
     
     if(cplJoinMap.values().size() > 0)
     {
          CPLJoinCaseCreationHandler.createcase(cplJoinMap);
     }
   }

}