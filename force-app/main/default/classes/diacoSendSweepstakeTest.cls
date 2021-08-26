@isTest
public class diacoSendSweepstakeTest {
	@isTest static void testAll(){
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
        Sms_Url__c sms = new Sms_Url__c(
            Activate_sms_function__c =true,
            Sender_Id__c = '1244',
            Function__c = 'Sweepstake',
            Sms_Text__c = 'Sms text'
        );
        upsert sms;
        diacoSendGrid send = new diacoSendGrid();
        Account accBussines = new Account(
        	Name = 'ASP TEST'
        );
        insert accBussines;
        Date day = Date.parse('05/17/2019');
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
            Home_Automation_Status__c= 'Test HA',
            Respond_Date__c = day
            
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
            Home_Automation_Status__c= 'Test HA',
            Validate_Email__c = 'valid'
        );
        Account acc3 = new Account(
            FirstName = 'Test acc',
            LastName = 'last test',
            PersonEmail = 'test@test.com',
            Phone = '312'
        );
        insert acc3;
        List<Account> accounts = new List<Account>();
        accounts.add(acc);
        accounts.add(acc2);
        insert accounts;
        diacoSendSweepstake sweepstake = new diacoSendSweepstake();
        test.startTest();
        test.setMock(HttpCalloutMock.class, new diacoSendSweepstakeHttpCallOutMock());
        List<String> accountsId = new List<String>();
        accountsId.add(acc.Id);
        sweepstake.accountsSms(accounts);
        diacoSendSweepstake.SweepstakeSms(accountsId);
		sweepstake.sendSweepstake(sweepstake.accounts(accounts));
         String sms2 = diacoSmsHS.Sweepstake(acc3,0);
         diacoSendSweepstake.sendSmsSweepstakeTrigger(sms2);
        acc.Validate_Email__c = 'valid';
        update acc;
        acc2.Send_Sweepstake__c = true;
        update acc2;  
        acc3.Phone = '312455';
        update acc3;
        test.stopTest();
    }
}