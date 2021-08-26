@isTest
public class diacoSendGridTest {
    @isTest static void testSendgrid(){
        diacoSendGrid send = new diacoSendGrid();
        Account accBussines = new Account(
        	Name = 'ASP TEST'
        );
        insert accBussines;
        Account acc = new Account(
            FirstName = 'Test acc',
            LastName = 'last test',
            PersonEmail = 'test@test.com',
            Utility__c =accBussines.Id,
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
        Account acc2 = new Account(
            FirstName = 'Test acc',
            LastName = 'last test',
            PersonEmail = 'test@test.com',
            Utility__c =accBussines.Id,
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
        accounts.add(acc2);
        insert accounts;
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
        test.startTest();
        test.setMock(HttpCalloutMock.class, new diacoSendGridHttpCallOutMock());
        System.debug(send.getAccounts(1,2));
        System.debug(send.dataSendGrid(2,1000, accounts));
        System.debug(send.getDateAccounts(1,2,1557205199,0,0));
        System.debug(send.getDateAccounts(1,2,1557205199,1,1));
        System.debug(send.getDateAccounts(1,2,1557205199,2,4222));
        test.stopTest();
    }
    
}