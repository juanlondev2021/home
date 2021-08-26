/*

 Diaco
 @author 			Esnayder Morales Corpas href=<esnaydermorales25@gmail.com>
 Project:			diacoSendGridSincronize
 Description:		class reponsible to make unit test
     
 Changes (Version)
 _________________________________________

   No.		Date			Author					Description
   ____	__________      __________________      _____________________________________
@version	1.0		05/10/2019		Esnayder Morales (ES)	Initial implementation  of the class.
*/
@isTest
public class DiacoSendgridSincronizeTest {
    
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
        Account accBussines = new Account(
        	Name = 'ASP TEST'
        );
        insert accBussines;
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
        //List<Account> accounts = [Select PersonEmail from Account where PersonEmail != null limit 10];
        String  accBody = DiacoSendgridSincronize.accountsBody(accounts);
        DiacoSendgridSincronize.sincronizeAccounts(accBody);
        DiacoSendgridSincronizeBatchQueue ds = new DiacoSendgridSincronizeBatchQueue(accounts);
        ID jobID = System.enqueueJob(ds);
        System.debug('###JOb Id###');
        System.debug(jobID);
        /*List<Account> accounts = new List<Account>();
        accounts.add(acc);
        accounts.add(acc2);*/
        test.startTest();
        test.setMock(HttpCalloutMock.class, new diacoSendGridSincronizeHttpCallOutMock());
        DiacoSendgridSincronize.sincronizeAcount(accounts);
        test.stopTest();
        
    }
}