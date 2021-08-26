/****************************************************************
Description : This test class created for UpdateCPLJoinInfoHandler class.
*****************************************************************/

@isTest
public class UpdateCPLJoinInfoHandlerTest{

    // create test records.
    static testMethod void Test_afterUpdate(){ 
        
        Account acc = new Account();
        acc.Name = 'TestAccount';
        insert acc;
        
        
        Opportunity opp = new Opportunity();
        opp.Name = 'TestOpportunity';
        opp.AccountId = acc.Id ;
        opp.Type = 'New Business';
        opp.StageName = 'Value Proposition';
        opp.CloseDate = system.today()+2;
        opp.NuCard_Industry__c = 'Chiropractor';
        opp.Branch__c = 'AZ-Phoenix_East';
        opp.LeadSource = 'CoreLogic';
        opp.Forward_to_number__c = '8220708920';
        insert opp;
        
        Lead_Distribution__c leadDistribute = new Lead_Distribution__c();
         leadDistribute.Account__c = acc.Id;
        leadDistribute.LastDialedNumber__c = false;
        insert leadDistribute;

        CPL_Joins__c cpl = new CPL_Joins__c();
        cpl.Billing_Opportunity__c = opp.Id;
        cpl.Lead_Distribution__c = leadDistribute.id;
        cpl.Active_CPL_Join__c  = true;
        cpl.Sort_Order__c = 0;
        insert cpl;
       
        leadDistribute.LastDialedNumber__c = true;
       
        update leadDistribute; 
   }
    
    

}