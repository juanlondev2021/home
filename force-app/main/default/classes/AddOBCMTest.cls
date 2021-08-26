/*
--------------------------
 * Modified By: Ganesh
 * Modified on:
 * Description: Updated the test class as per best practices. 
-----------------------------
*/
@isTest(seealldata = false)
private class AddOBCMTest {   
    @Testsetup static void createtestdata(){
        Account newAcc = new Account(LastName = 'Test',Phone = '1234567897',Branch__c = 'AZ-Phoenix_North',respond_date__c=system.today());
        insert newAcc;
        system.assertNotEquals(null, newAcc.id);
        
        Insert new Opportunity(Name = 'Test Opp',AccountId = newAcc.Id,Type = 'Trade',stageName = 'Needs Analysis',closeDate = system.Today(),OB_Campaign_Active__c = true);
        system.assertnotEquals(null,[select id from Opportunity where Type = 'Trade' limit 1]);
        
        Opportunity opp = [select id,OB_Campaign_Call_Center__c, OB_Campaign_Active__c from Opportunity where Type='Trade' limit 1];
		Insert new OB_Campaign__c(Opportunity__c = Opp.id,OB_Campaign_Call_Center__c = Opp.OB_Campaign_Call_Center__c,OB_Campaign_Branch__c='AZ-Phoenix_North');
		System.assertEquals(1,[select count() from OB_Campaign__c]);
    }
    static testmethod void insertOBC(){
	    Test.startTest();
		Account Acc = [select id,phone from Account where lastname='Test' limit 1];
        acc.phone = '9876543210';
        update acc;
		Test.stopTest();
    }
}