@isTest
public class diacoSmsHSTest {
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
        //Config sms function
        Sms_Url__c sms = new Sms_Url__c(
            Activate_sms_function__c =true,
            Sender_Id__c = '1244',
            Function__c = 'Sweepstake',
            Sms_Text__c = 'Sms sweepstake'
        );
        upsert sms;
        //Create account
        Account acc = new Account(
            FirstName = 'Test acc',
            LastName = 'last test'
            //PersonEmail = 'test@test.com'
        );        
        
        test.startTest();
        test.setMock(HttpCalloutMock.class, new diacoValidateEmailHttpCallOutMock());
        insert acc;
        acc.PersonEmail = 'test@test.com';
        acc.Phone = '4803061365';
        System.debug(acc);
        diacoSmsHS.Sweepstake(acc, 0);
        List<String> paramList = new List<String>();
        paramList.add(acc.Id);
        diacoSmsHS.Sweepstake(paramList);
        test.stopTest();
    }

}