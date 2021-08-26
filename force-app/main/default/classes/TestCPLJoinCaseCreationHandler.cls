/*******************************************************
* Description : Its created for CPLJoinCaseCreationHandler controller
* Modified By: Ganesh
* Modified on:
* Description: Updated the test class as per best practices.
********************************************************/
@isTest(seealldata=false)
Private class TestCPLJoinCaseCreationHandler
{
    // Create Test Records.
    @testsetup static void createtestrecords()
    {
        Account acc = new Account();
        acc.name = 'testAccount';  
        acc.Primary_Billing_City__c='Sunnyvale';    
        acc.Primary_Billing_Country__c='US';
        acc.Primary_Billing_State__c='CA';
        acc.Primary_Billing_Street__c='260 N Mathilda Ave';
        acc.Primary_Billing_Zip_Code__c='94086'; 
        acc.branch__c = 'CA-San_Jose'; 
        acc.Phone = '1234567892';
        acc.verbal_consent__c = 'Yes';  
        insert acc;
        system.assertnotEquals(null, acc.id);
        
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
        system.assertNotEquals(null, opp.id);
        
        Lead_Distribution__c leadDistribute = new Lead_Distribution__c();
        leadDistribute.Account__c = acc.Id;
        leadDistribute.LastDialedNumber__c = false;
        insert leadDistribute;
        system.assertNotEquals(null, leadDistribute.id);
        
        CPL_Case_Settings__c newSettings = new CPL_Case_Settings__c();
        newSettings.Name = 'User';
        newSettings.id_value__c = userinfo.getUserId();
        newSettings.Name__c = 'Test';
        insert newSettings;
        
        CPL_Case_Settings__c newSettings1 = new CPL_Case_Settings__c();
        newSettings1.Name = 'Queue';
        newSettings1.Name__c = 'Test1';
        newSettings1.id_value__c = userinfo.getUserId();
        insert newSettings1; 
        
    }
    
    static testmethod void testCPLcase(){
        Opportunity opp = [select id from Opportunity limit 1];
        Lead_Distribution__c leadDistribute = [select id from Lead_Distribution__c limit 1];
        CPL_Joins__c cpl = new CPL_Joins__c();
        cpl.Billing_Opportunity__c = opp.Id;
        cpl.Lead_Distribution__c = leadDistribute.id;
        cpl.Active_CPL_Join__c  = true;
        cpl.Pending_Cancelled__c  = true;
        cpl.Sort_Order__c = 0;
        insert cpl; 
		system.assertNotEquals(null, cpl.id);
        
    }
    
    static testmethod void testCPLcaseUpdate(){
        Opportunity opp = [select id from Opportunity limit 1];
        Lead_Distribution__c leadDistribute = [select id from Lead_Distribution__c limit 1];
        CPL_Joins__c cpl = new CPL_Joins__c();
        cpl.Billing_Opportunity__c = opp.Id;
        cpl.Lead_Distribution__c = leadDistribute.id;
        cpl.Active_CPL_Join__c  = true;
        cpl.Pending_Cancelled__c  = false;
        cpl.Sort_Order__c = 0;
        insert cpl; 
		system.assertNotEquals(null, cpl.id);
        
        Update new CPL_Joins__c(id=cpl.id,Pending_Cancelled__c  = true);
    }
}