/*
--------------------------
 * Modified By: Ganesh
 * Modified on:
 * Description: This test class covers the trigger AddAccountIDonLD & UpdateCPLJoinInfoHandler class.
				Updated the test class as per best practices. 
-----------------------------
*/
@isTest(seealldata = false)
private class AddAccountIDonLDTest {   
    @testsetup static void createtestdata(){
        Account newAcc = new Account(LastName = 'Test',Phone = '1234567897');
        insert newAcc;
        system.assertNotEquals(null, newAcc.id);
        
        Insert new Opportunity(Name = 'Test Opp',AccountId = newAcc.Id,Type = 'Trade',stageName = 'Needs Analysis',closeDate = system.Today(),Forward_to_number__c='8220708920');
        system.assertnotEquals(null,[select id from Opportunity where Type = 'Trade' limit 1]);
    }
    static testmethod void insertLead(){
        Test.startTest();
        Opportunity opp = [select id from Opportunity where Type='Trade' limit 1];
        Account acc = [select id from Account where LastName='Test' limit 1];
        
        Insert new Lead_Distribution__c(Opportunity__c = opp.id,Account__c = acc.id,LastDialedNumber__c = false);
        system.assertEquals(1,[select count() from Lead_Distribution__c]);
        
        Lead_Distribution__c testLeadDist = [select id,LastDialedNumber__c from Lead_Distribution__c limit 1];
        Insert new CPL_Joins__c(Billing_Opportunity__c = opp.Id,Lead_Distribution__c = testLeadDist.id,Active_CPL_Join__c  = true,Sort_Order__c = 0);
        system.assertEquals(1,[select count() from CPL_Joins__c]);
        
        testLeadDist.LastDialedNumber__c = true;
        update testLeadDist;
        Test.stopTest();
    }
}