@isTest
public class DiacoOffersSendGridTest {
    
    @isTest static void testSendgrid(){
        neverBounce__c nb = new neverBounce__c(
            Job_id__c = '277461',
            number_of_pages__c = 10,
            next_page__c = 1, 
            ApiKey__c = 'Apikey******', 
            First_Job__c = 3, 
            Second_Job__c =1, 
            Emails_per_page__c = 10 
        );
        upsert nb;
        Send_Grid__c sendgrid = new Send_Grid__c(
            Api_Key__c = '277461'
        );
        upsert sendgrid;
        Account acc = new Account(
            FirstName = 'Test acc',
            LastName = 'last test',
            PersonEmail = 'test@test.com',
            Street__c= 'Test street',
            State__c= 'AZ',
            City__c = 'Arizona',
            Zip__c = '12345',
            Solar_Status__c= 'Test solar',
            Water_Status__c= 'Test water',
            Window_Status__c = 'Test Window',
            Pest_Control_Status__c= 'Test Pest',
            Home_Automation_Status__c= 'Test HA'
        );
        List<Account> accounts = new List<Account>();
        accounts.add(acc);
        insert accounts;
        List<String> ids = new List<String>();
        ids.add(accounts[0].Id);
		test.startTest();
        test.setMock(HttpCalloutMock.class, new diacoSendGridSincronizeHttpCallOutMock());
        DiacoOfferSendGrid.SendEmail(ids);
        test.stopTest();
    }
}