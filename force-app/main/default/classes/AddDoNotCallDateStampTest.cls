/*
--------------------------
 * Modified By: Ganesh
 * Modified on:
 * Description: This test class covers AddDoNotCallDateStamp trigger. 
				Updated the test class as per best practices. 
-----------------------------
*/
@isTest(seeAlldata=false)
private class AddDoNotCallDateStampTest {
    
    static testmethod void insertAccount(){
        test.startTest();
        Account newAcc = new Account();
        newAcc.LastName = 'Test';
        newAcc.Phone = '1234567892';
        insert newAcc;
        newAcc.PersonDoNotCall = true;
        newAcc.Do_Not_Call_Date_Stamp__c = null;
        update newAcc;
        system.assertnotEquals(null, newAcc.id);
        test.stopTest();
    }
}