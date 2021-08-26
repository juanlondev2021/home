/*********************************************************
 * Created By: MST
 * Description : This test class is for nuHome_ClearAccount trigger.
 * Modified By: Ganesh
 * Modified on:
 * Description: Updated the test class as per best practices. 
**********************************************************/
@isTest
private class nuHome_ClearAccount_test {
/*********************************************************
    //Insert accout and inserting chargent records.
    @testsetup static void createtestdata(){
        Id personAccRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        //Account creation
        Account accIns = new Account();
        accIns.Lastname = 'test';
        accIns.Phone = '9876433325';
        accIns.Docusign_Credit_Card_Number__c = '1234123412341234';
        accIns.RecordTypeId = personAccRTId;
        Insert accIns;
        system.assertnotEquals(null,accIns.id);
    }
    static testmethod void updateAccount(){
        test.startTest();
        Account acc = [select id from Account where Lastname='Test'];
        ChargentOrders__ChargentOrder__c charOrders = new ChargentOrders__ChargentOrder__c();
        charOrders.ChargentOrders__Account__c = acc.id;
        insert charOrders;
        system.assertnotEquals(null, charOrders.id);
        test.stopTest();
    }
 **********************************************************/
}