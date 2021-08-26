@isTest
public class diacoDocusignApiRestIntegrationJsonTest {
    @isTest
    static void TestAll() {
        Account Acc = new Account();
        Acc.FirstName = 'Account ';
        Acc.LastName = 'Test';
        Acc.Street__c='test';
        Acc.City__c='test';
        Acc.State__c='AZ';
        Acc.Zip__c='test';
        insert Acc;

        Home_Services__c hs = new  Home_Services__c();
        hs.Account__c = Acc.Id;
        hs.Card_Number__c = '123456789';
        hs.CSV__c = '123';
        hs.Method_Of_Payment__c = 'Credit Card';		 
        hs.Exp_Date__c = '7/24';
        hs.Name='test1';
        hs.Home_Services_Status__c='Schedule';
        hs.Sales_Event_Current_Status__c='Schedule';
        hs.Event_Count__c=1;
        //hs.Sales_Rep__c = u.Id;
        insert hs;
        
        Event event = new Event(
            Home_Service__c = hs.Id,
            RecordTypeId = '012410000013G9CAAU',
            DurationInMinutes=1,
            WhatId = hs.Id,
            ActivityDateTime= Date.Today()
        );
      //  insert event;
        
        PaymentMethod__c PayM = new PaymentMethod__c(HomeService__c=hs.Id,PaymentMethodType__c='ACH',Bank_Account_Name__c='Test OK 1');
        insert PayM;
        
        Finance_Package__c pack = new Finance_Package__c(Name=hs.Id,Payment_Number__c=96,type__c='purchase',APR__c=12.99,
                                                        Purchase__c=123,Payment_Factor__c=0.016802,Monthly_Renewal_PURCHASE__c=12,
                                                        Monthly_Renewal_LEASE__c=1,Monthly_Term_PURCHASE__c=123,Monthly_Term_LEASE__c=1235,
                                                        Monthly_Payment_PURCHASE__c=1352,Monthly_Payment_LEASE__c=58,Monitoring__c=53,
                                                        Equipment_Min_Payment__c=63,X12_Months_Same_As_Cash__c=true,Total_Min_Payments__c=123,
                                                        Activation_Emergency_Video_PURCHASE__c=12,Activation_Emergency_Video_LEASE__c=12);
        insert pack;
        Test.startTest();
        diacoDocusignApiRestIntegrationJson.Completion_Certificate_Template(hs.Id, 'test');
        Test.stopTest();
    }
}