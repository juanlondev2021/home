@isTest
public class finishHomeServicesTest {

    @isTest static void testAll(){
        Personnel__c person = new Personnel__c (
            First_Name__c = 'Test Personnel'
        );
        insert person;
        Account acc = new Account(
        	FirstName = 'Test acc',
            LastName = 'last test',
            PersonEmail = 'esnaydermorales25@gmail.com'
        );
        insert acc;
        Home_Services__c hs = new Home_Services__c(
            Name = 'Test',
            Account__c = acc.Id,
            ApptSetter__c = person.Id
            
        );
        insert hs;
       	test.startTest();
        test.setMock(HttpCalloutMock.class, new finishHomeServicesHttpCallOutMock());
        finishHomeServices.saveContactSendgrid(acc.PersonEmail, acc.FirstName, acc.LastName, acc.Id, hs.Id);
        finishHomeServices.sendEmail(hs.Id);
        test.stopTest();
    }
}