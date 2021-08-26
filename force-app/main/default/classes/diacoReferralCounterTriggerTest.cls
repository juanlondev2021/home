/**
* Diaco
* @author 			Jorge Martinez href=<jorgeality29@gmail.com>
* Project:			web sites 
* Description:		Class responsible for testing diacoReferralCounter tigger
*
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		11/01/2018		Jorge Martinez (JM)		Initial implementation of the class.
**/
@isTest
public class diacoReferralCounterTriggerTest {
    @isTest static void Test() {
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
        
        Account Acc = new Account();
        Acc.FirstName = 'Account';
        Acc.LastName = 'Test';
        Acc.PersonEmail = 'test@gmail.com';
        Acc.RecordTypeId ='012410000012NOKAA2';
        Acc.Validate_Email__c = 'Valid';
        insert Acc;
        
        Personnel__c per = new Personnel__c();
        per.Name = 'test';
        per.First_Name__c = 'test';
        per.Last_Name__c = 'test';
        per.Kunnect_ID__c = 'none';
        insert per;
        
        for(Integer i = 0; i < 4; i++){
            insert new referral__c(
                lastName__c = 'test', 
                firstName__c = 'test',
                account__c = Acc.Id
            );        
        }
        
        test.startTest();
        
        test.setMock(HttpCalloutMock.class, new diacoValidateEmailHttpCallOutMock());  
        insert new referral__c(
                lastName__c = 'test', 
                firstName__c = 'test',
                account__c = Acc.Id,
           		ApptSetter__c=per.Id
            );
        
        test.stopTest();
        
    }
}