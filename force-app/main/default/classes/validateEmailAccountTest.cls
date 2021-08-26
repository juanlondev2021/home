@isTest
public class validateEmailAccountTest {
    @isTest static void testAll(){
        List<Account> accounts = new List<Account>();
        // insert 10 accounts
        for (Integer i=0;i<10;i++) {
            accounts.add(new Account(FirstName='Account '+i, LastName = 'last test',
                City__c='New York', PersonEmail = 'test'+i+'@test.com'));
        }
        insert accounts;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new diacoValidateEmailHttpCallOutMock());
        validateEmailAccount uca = new validateEmailAccount();
        Id batchId = Database.executeBatch(uca);
        Test.stopTest();
    }
    /*static testmethod void test() {        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new diacoValidateEmailHttpCallOutMock());
        validateEmailAccount uca = new validateEmailAccount();
        Id batchId = Database.executeBatch(uca);
        Test.stopTest();
        // after the testing stops, assert records were updated properly
        //System.assertEquals(10, [select count() from contact where City__c = 'New York']);
    }*/
    

}