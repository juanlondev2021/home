/**
* Diaco
* @author 			Esnayder Morales href=<esnaydermorales25@gmail.com>
* Project:			Validator email
* Description:		Test to class diacoValidateEmail.  
*
* Changes (Version)
* -------------------------------------
*			No.		Date			Author						Description
*			-----	----------		--------------------		---------------
* @version	1.0		26/04/2019		Esnayder Morales (ES)		Initial implementation of the class.
**/
@isTest
public class diacoValidateEmailTest {
    
    
    @testSetup static void setup() {
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
        // Create common test accounts
        List<Account> testAccts = new List<Account>();
        for(Integer i=0;i<100;i++) {
            testAccts.add(new Account(FirstName = 'Test acc'+i,
            LastName = 'last test'+i, PersonEmail = 'test@test.com'));
        }
        insert testAccts;        
    }
    
    static testmethod void test() {
        
        
        Account acc = new Account(
            FirstName = 'Test acc',
            LastName = 'last test'
            //PersonEmail = 'test@test.com'
           // Phone = '31000000000'
        );
       insert acc;
        Account acc2 = new Account(
            FirstName = 'Test acc',
            LastName = 'last test'
            //Phone = '31000000000'
        );
        insert acc2;
        Account acc3 = new Account(
            FirstName = 'Test acc',
            LastName = 'last test',
            PersonEmail = 'test@test.com',
            Phone = '31000000000'
        );
        
        insert acc3;
        
        
        Account acc5 = new Account(
            FirstName = 'Test acc',
            LastName = 'last test'
        );
        insert acc5;
        
        //Config sms function
        Sms_Url__c sms = new Sms_Url__c(
            Activate_sms_function__c =true,
            Sender_Id__c = '1244',
            Function__c = 'Sweepstake',
            Sms_Text__c = 'Sms text'
        );
        upsert sms;
        Account acc4 = new Account(
            FirstName = 'Test acc',
            LastName = 'last test',
            PersonEmail = 'test@test.com',
            Phone = '31000000000'
        );
        insert acc4;
        test.startTest();
        test.setMock(HttpCalloutMock.class, new diacoValidateEmailHttpCallOutMock());        
        String emailToValidate = ''; 
        //upsert acc4;
        List<Account> accountsUp = new List<Account>();	
        List<String> accountsId = new List<String>();
        List<Account> accounts = [SELECT Id, Validate_Email__c, PersonEmail, FirstName, Id_SendGrid__c,
                       LastName, Utility__r.Name, Street__c, State__c, Phone, Sms_sweepstake__c,
                       City__c, Zip__c, Solar_Status__c, Water_Status__c, Window_Status__c,
                       Pest_Control_Status__c, Home_Automation_Status__c FROM Account Where PersonEmail != '' AND Validate_Email__c = '' LIMIT 12];
        for(Account acct : accounts){
            emailToValidate += '{"id":"'+acct.Id+'","Email":"'+acct.PersonEmail+'"},';
            accountsId.add(acct.Id);
            accountsUp.add(new Account(
            	Id = acct.Id,
                Validate_email_status__c = null   
            ));
        }
		
		        
        emailToValidate = emailToValidate.removeEnd(',');
		
        diacoValidateEmail dve = new diacoValidateEmail();
        
        responseNeverBounce resNB =  dve.responseNB(dve.validateEmail('Apikey******', emailToValidate));
        system.debug(resNB.job_id);
        reponseNBResult result = dve.reponseNBRes(dve.getInfoAboutJob('Apikey******', ''+resNB.job_id));
        system.debug(result.total_pages);
        
        for(resultIn idc : result.results){
            system.debug(idc.data.email);
            system.debug(idc.data.id);
            system.debug(idc.verification.result);
        }
        diacoNeverBounceStatus rest = dve.reponseNBReStatus(dve.getInfoAboutJobStatus('Apikey******', ''+resNB.job_id));
        system.debug(rest.status);
        //diacoValidateEmail.verificateEmail('test@test.com',accounts[0].Id );
        diacoValidateEmail.validateOneEmail('Apikey******', emailToValidate);
        diacoValidateEmail.sincronizeOne(diacoValidateEmail.oneAccount(accounts[0]));
        diacoValidateEmail.Sweepstake(accounts);
        diacoSmsHS.Sweepstake(acc, 0);
        acc.Phone = '31000000';
        upsert acc;
        acc5.Phone = '31000000';
        upsert acc5;
        acc2.PersonEmail = 'test@test.com';
        acc2.Validate_Email__c = 'valid';
        acc2.Send_Sweepstake__c = false;
        upsert acc2;
        //acc.PersonEmail = 'test@test.com';
        Date day = Date.parse('05/13/2019');
        acc4.Validate_Email__c = 'valid';
        upsert acc4;
        
        acc3.Sweepstake__c = NULL;
        acc3.Send_Sweepstake__c = true;
        acc3.Respond_Date__c = day;
        acc3.Validate_Email__c = 'valid';
        upsert acc3;
        test.stopTest();
    }
    
    /*@isTest static void testCmpController(){
        Account acc = new Account(
            FirstName = 'Test acc',
            LastName = 'last test',
            PersonEmail = 'test@test.com'
        );
        insert acc;
        neverBounce__c nb = new neverBounce__c(
            Job_id__c = '277461',
            number_of_pages__c = 3,
            next_page__c = 1, 
            ApiKey__c = 'Apikey******', 
            First_Job__c = 1, 
            Second_Job__c =1, 
            Emails_per_page__c = 10 
        );
        upsert nb;
        test.startTest();
        test.setMock(HttpCalloutMock.class, new diacoValidateEmailHttpCallOutMock());
        validateEmailNeverBounce venb = new validateEmailNeverBounce();
        validateEmailNeverBounce.sendingJobToNeverBounce();
        validateEmailNeverBounce.verificateEmailFromNeverBounce('string title');
        
        test.stopTest();
        
        
    }
    @isTest static void diacoNeverBounceCmpControllerTest(){
        Account acc = new Account(
            FirstName = 'Test acc',
            LastName = 'last test',
            PersonEmail = 'test@test.com'
        );
        insert acc;
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
        test.setMock(HttpCalloutMock.class, new diacoValidateEmailHttpCallOutMock());
        diacoNeverBounceCmpController.getCustomSetting();
        //diacoNeverBounceCmpController.ReinitJob('String title');
        diacoNeverBounceCmpController.createNewJob();
        diacoNeverBounceCmpController.deleteJobSf();
        diacoNeverBounceCmpController.saveSettings(nb);
        test.stopTest();
    }*/
}