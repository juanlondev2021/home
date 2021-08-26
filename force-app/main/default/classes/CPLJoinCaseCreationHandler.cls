/***********************************************************************
CreatedBy : MST
Description : It will create case when Pending_Cancelled is checked. And 
The process of case creation should be triggered when there is only one record 
for which ‘Active CPL Join’ checked.
************************************************************************/

public class CPLJoinCaseCreationHandler
{
   Static Map<String,CPL_Case_Settings__c> caseSettingsMap = CPL_Case_Settings__c.getAll();
   Static List<Case> caseList = new List<Case>();
   static Set<Id> leadDistributionIds = new Set<Id>();
   static Map<Id, List<CPL_Joins__c>> activeCPLMap = new Map<Id, List<CPL_Joins__c>>();
   static String  caseRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Inside & Outside Sales').getRecordTypeId();
  
  
   public static void createcase(Map<Id, CPL_Joins__c> newRecMap)
   {
     // Processing all new/updating records.
     for(CPL_Joins__c currRec : newRecMap.values())
     {
        // checking Pending_Cancelled is true
        if(currRec.Pending_Cancelled__c == True && currRec.Active_CPL_Join__c == True)
          {
             // fetching LeadDisctribution id of this CPL join record and assign it to this Set.
              leadDistributionIds.add(currRec.Lead_Distribution__c);
          
          }
     
     }
   
     if(leadDistributionIds.size() > 0)
     {
        // Its identifing how many CPL join records are active cpl join for Lead Distribution records.
        for(CPL_Joins__c currCPl : [SELECT Id, Lead_Distribution__c, Active_CPL_Join__c FROM CPL_Joins__c 
                                    WHERE  Lead_Distribution__c IN :leadDistributionIds AND Active_CPL_Join__c = true ])
        {
           if(activeCPLMap.containskey(currCPl.Lead_Distribution__c))
             activeCPLMap.get(currCPl.Lead_Distribution__c).add(currCPl);
           else
             activeCPLMap.put(currCPl.Lead_Distribution__c,new List<CPL_Joins__c>{currCPl});
        }
     
     }
           
      for(CPL_Joins__c currRec : [SELECT Id,Name,Producing_Opportunity__r.AccountId, Billing_Opportunity__r.Name,
                                  Producing_Opportunity__r.Name, Lead_Distribution__c, Pending_Cancelled__c, Active_CPL_Join__c
                                  FROM CPL_Joins__c WHERE Id IN :newRecMap.keySet()])
      {
          if(currRec.Pending_Cancelled__c == True && 
              currRec.Active_CPL_Join__c == True  &&
              activeCPLMap.containskey(currRec.Lead_Distribution__c) )
          {
               // It is checking, this cpl join is only one active cpl join for this lead distribution or not.
               // if it is yes, it would create case for the CPL join or else it won't create case.
                if(activeCPLMap.get(currRec.Lead_Distribution__c).size() == 1)
                {
                    Case newCase = new Case();
                   
                    newCase.AccountId = currRec.Producing_Opportunity__r.AccountID;
                    newCase.User__c = caseSettingsMap.get('User').id_value__c;
                    newCase.OwnerId= caseSettingsMap.get('Queue').id_value__c;
                    newCase.Origin = 'Auto';
                    newCase.Priority = 'High';
                    newCase.Description = currRec.Name + '_' + currRec.Billing_Opportunity__r.Name + '_' + currRec.Producing_Opportunity__r.Name ;
                    newCase.Type = 'Opportunity';
                    newCase.Sub_Type__c = 'Spec CPL';
                    newCase.Reason = 'Cancelled Customer';
                    newCase.Subject = 'Cancelled Customer; Need New';
                    newCase.CPL_Joins__c = currRec.id;
                    newCase.RecordtypeId = caseRecTypeId;
                    newCase.isCPLJoin__c = true;
                    caseList.add(newCase);
                 }  
                
          }
      
      }
      
      if(caseList.size() > 0)
        insert caseList;
   }

}