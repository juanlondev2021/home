/*
--------------------------
 * Modified By: Ganesh
 * Modified on:
 * Description: Updated the test class as per best practices. 
-----------------------------
*/
@isTest(seealldata=false)
private class AddAccountIDonDIDTest {
    
    @testsetup static void createtestdata(){
        Account newAcc = new Account(LastName = 'Test',Phone = '1234567897');
        Insert newAcc;
        System.assertNotEquals(null, newAcc.id);
        
        Insert new Opportunity(Name = 'Test Opp',AccountId = newAcc.Id,Type = 'Trade',stageName = 'Needs Analysis',closeDate = system.Today());
        System.assertnotEquals(null,[select id from Opportunity where Type = 'Trade' limit 1]);
    }
    static testmethod void insertDID(){
        Test.StartTest();
        Opportunity opp = [select id from Opportunity where Type='Trade' limit 1];
        Insert new DID__c(Destination_Number__c = '8001231234',Opportunity__c = opp.id,POC__c = '8881231234',DID_Type__c = 'Business Card',Responsible_Organization__c = 'Twilio');
        System.assertnotEquals(null, [select id from DID__c where POC__c = '8881231234' limit 1]);
        Test.StopTest();
    }
}