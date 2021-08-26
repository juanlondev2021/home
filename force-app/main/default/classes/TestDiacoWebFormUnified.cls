@isTest
public class TestDiacoWebFormUnified {
    
    @isTest static void TestUpdateWebForm_Services_pick() {
        Send_Grid__c config = new Send_Grid__c(Api_Key__c ='test');
        insert config;
        Account acct = new Account(Name='Test Account');
        insert acct;
        
        webForm__c wf=new webForm__c(Name='test Wb',Account__c=acct.Id);
        insert wf;
        
        wf.Services_Pick__c='test Service Pick';
        // Perform test
        System.debug('Before new test');
        Test.startTest();
        test.setMock(HttpCalloutMock.class, new diacoSendGridSincronizeHttpCallOutMock());
        update wf;
        Test.stopTest();
        System.debug('After new test');
        System.debug(wf);    
        System.assert([select Id,Sweepstake_Status__c,Sendgrid_Status__c  From Account Where Sweepstake_Status__c='Completed'].size()==1);  
        
    }

}