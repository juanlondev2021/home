/****************************************************************
 * Modified By: Ganesh
 * Modified on:
 * Description: This test class created for nuHomeSetBaseline Trigger.
 				Updated the test class as per best practices. 
******************************************************************/

@isTest(seealldata=false)
private class TestnuHomeSetBaseline{
    static testMethod void insertOpportunity() {
       
        // creating account record.
        Account acc = new Account();
        Id devRecordTypeId2 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Accounts').getRecordTypeId();
        acc.recordtypeid = devRecordTypeId2;
        acc.FirstName = 'TestBusiness';
        acc.LastName = 'TestBusiness';
        acc.Branch__c = 'AL-Birmingham';
        acc.Industry = 'Attorney';
        acc.Type = 'Customer';
        acc.Phone = '5675675734';
        insert acc;
        
        // creating opportunity record.
        
        Opportunity opp = new Opportunity();
        Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('CPL Spec Card Prod').getRecordTypeId();
        opp.recordtypeid = devRecordTypeId;
        opp.Name = 'Test MST';
        opp.Accountid = acc.id;
        opp.Type = 'Existing Business';
        opp.StageName = 'Needs Analysis';
        opp.CloseDate = Date.Today() ;
        opp.NuCard_Industry__c = 'Appliance Store';
        opp.Branch__c = 'AZ-Phoenix_North';
        opp.LeadSource = 'City search';
        opp.Forward_to_number__c = 'test';
        opp.Closed_Won__c = false;
        insert opp;
        
        System.assertEquals(opp.recordTypeId,devRecordTypeId);
    }
}