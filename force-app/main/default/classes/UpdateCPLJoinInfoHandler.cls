/*******************************************************************
Description :  When the ‘Last Dialed Number flag is checked, Active CPL Join is Active and Destination Number is not Blank.
               then Lead Distribution record should be updated 
               with the next Opp in the queue and ‘Last Dialed Number’ flag should be unchecked.
********************************************************************/

public class UpdateCPLJoinInfoHandler
{
   
   // Updating the CPL Join field on Lead Distribution record based on round robin fashion. Round robin will do based on the Sort order field.
   
   public static void UpdateBillingOpp(Map<Id,Lead_Distribution__c> newDistributionMap,Map<Id,Lead_Distribution__c> oldDistributionMap)
   {
   
      Set<Id> leadDistributionID = new Set<Id>();
      Set<Id> CPLId = new Set<Id>();
      for(Lead_Distribution__c newLD : newDistributionMap.values())
      {
         if(newLD.LastDialedNumber__c == TRUE && oldDistributionMap.get(newLD.id).LastDialedNumber__c == FALSE)
         {
           leadDistributionID.add(newLD.id);
           CPLId.add(newLD.CPL_Join__c);
         }
      
      }
      
      Map<Id,List<CPL_Joins__c>> cplJoinMap = new Map<Id,List<CPL_Joins__c>>();
      
      if(leadDistributionID.size() > 0)
      {
         for(CPL_Joins__c currRec : [SELECT ID, Lead_Distribution__c, Billing_Opportunity__c, Sort_Order__c FROM CPL_Joins__c WHERE Lead_Distribution__c IN :leadDistributionID 
                                     AND Destination_Number__c != NULL AND 
                                     Active_CPL_Join__c = true AND ID NOT IN:CPLId
                                     Order by Sort_Order__c, Last_Update_Time__c ASC])
         {
           
           if(cplJoinMap.containsKey(currRec.Lead_Distribution__c))
               cplJoinMap.get(currRec.Lead_Distribution__c).add(currRec);
           else
               cplJoinMap.put(currRec.Lead_Distribution__c, new List<CPL_Joins__c>{currRec}); 
         }
      }
      
      List<Lead_Distribution__c> updateLDList = new List<Lead_Distribution__c>();
      List<CPL_Joins__c> updateCPLList = new List<CPL_Joins__c>();
      
       for(Lead_Distribution__c newLD : newDistributionMap.values())
      {
         if(newLD.LastDialedNumber__c == TRUE && oldDistributionMap.get(newLD.id).LastDialedNumber__c == FALSE)
         {
             if(cplJoinMap.containsKey(newLD.id))
             {
                  Lead_Distribution__c  updateLD = new Lead_Distribution__c();
                  if(newLD.CPL_Join__c != (cplJoinMap.get(newLD.id))[0].Id)
                  {
                      updateLD.id = newLD.id;
                     // updateLD.Opportunity__c = (cplJoinMap.get(newLD.id))[0].Billing_Opportunity__c;
                      updateLD.CPL_Join__c = (cplJoinMap.get(newLD.id))[0].Id;
                      
                      updateLD.LastDialedNumber__c = false;
                      updateLDList.add(updateLD);
                      
                      CPL_Joins__c updateCPL = new CPL_Joins__c();
                      updateCPL.id = (cplJoinMap.get(newLD.id))[0].Id;
                      updateCPL.sort_Order__c = (cplJoinMap.get(newLD.id))[0].sort_Order__c + 1;
                      updateCPL.Last_Update_Time__c = System.now();
                      updateCPLList.add(updateCPL);
                  
                  }
                  
             
             }
         }
      
      }
      
      if(updateLDList.size() > 0)
      {
      
        update updateLDList;
        update updateCPLList;
      }
   
   }

}