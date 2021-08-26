@isTest
public class diacoValidateEmailTriggerTest {
    @isTest static void testAll(){
        Account acc = new Account(
            FirstName = 'Test acc',
            LastName = 'last test',
            PersonEmail = 'test@test.com'
        );
        
        test.startTest();
        test.setMock(HttpCalloutMock.class, new diacoValidateEmailHttpCallOutMock());
        insert acc;
        acc.FirstName = 'Test';
        acc.PersonEmail = 'test2@test.com';
        update acc;
        test.stopTest();
    }
    
}