/*
--------------------------
 * Modified By: Ganesh
 * Modified on:
 * Description: Updated the test class as per best practices. 
-----------------------------
*/
@isTest(seealldata = false)
private class AddCallCenterIDonOBCTest {   
    @testsetup static void createtestdata(){
        Account newAcc = new Account(LastName = 'Test',Phone = '1234567897');
        insert newAcc;
        system.assertNotEquals(null, newAcc.id);
        
        Insert new Opportunity(Name = 'Test Opp',AccountId = newAcc.Id,Type = 'Trade',stageName = 'Needs Analysis',closeDate = system.Today());
        system.assertnotEquals(null,[select id from Opportunity where Type = 'Trade' limit 1]);
    }
    static testmethod void insertLeadDistribution(){
	    Test.startTest();
        Opportunity opp = [select id,OB_Campaign_Call_Center__c from Opportunity where Type='Trade' limit 1];
        
		Insert new OB_Campaign__c(Opportunity__c = Opp.id,OB_Campaign_Call_Center__c = Opp.OB_Campaign_Call_Center__c);
		System.assertEquals(1,[select count() from OB_Campaign__c]);
		Test.stopTest();
    }
}