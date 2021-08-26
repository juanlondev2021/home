@isTest(seealldata=false)
private class AddVerbalConsentDateStampTest {
    //Testsetup not required as this test class is used to test the trigger
    static testmethod void insertAccount(){
        insert new Account(LastName = 'Test',Phone = '1234567892');
       	system.assertnotEquals(null,[select id from account where lastname = 'Test' limit 1].Id);
    }
}