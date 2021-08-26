@isTest
public class DiacoTriggerUserRepCountEventTest {
    @isTest static void testAll(){
        
        Account Acc = new Account();
        Acc.FirstName = 'Account ';
        Acc.LastName = 'Test';
        Acc.RecordTypeId ='012410000012NOKAA2';
        Acc.Street__c='test';
        Acc.City__c='test';
        Acc.State__c='AZ';
        Acc.Zip__c='test';
        insert Acc;
        
        Personnel__c per = new Personnel__c();
        per.Name = 'test';
        per.First_Name__c = 'test';
        per.Last_Name__c = 'test';
        per.Kunnect_ID__c = 'none';
        insert per;
        
        User u = new user();
        u.LastName = 'Test Event';
        u.Email = 'test@test.com';
        u.Alias = 'Tcode';
        u.Username = 'TestEvent@test.com';
        u.CommunityNickname = 'test12';
        u.LocaleSidKey = 'en_US';
        u.TimeZoneSidKey = 'GMT';
        u.ProfileID = '00e41000001hNuFAAU';
        u.LanguageLocaleKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.Personnel__c=per.Id;
        insert u;
        
        Home_Services__c hs = new  Home_Services__c();
        hs.Account__c = Acc.Id;
        hs.RecordTypeId = '012410000013G9OAAU';
        hs.Card_Number__c = '123456789';
        hs.CSV__c = '123';
        hs.Method_Of_Payment__c = 'Credit Card';		 
        hs.ApptSetter__c = per.Id;
        hs.Exp_Date__c = '7/24';
        hs.Name='test test test test';
        hs.Home_Services_Status__c='Schedule';
        hs.Sales_Event_Current_Status__c='Schedule';
        hs.Event_Count__c=1;
        //hs.Sales_Rep__c = u.Id;
        insert hs;
        
        Event events =  new Event();
        DateTime StartHour = DateTime.newInstance(2018, 7, 22, 13, 30, 0);
        DateTime EndHour = StartHour.addHours(1);
        events.Subject='Test';
        events.StartDateTime = StartHour;
        events.EndDateTime = EndHour;
        events.WhatId = hs.Id;
        events.Home_Service__c=hs.Id;
        events.OwnerId=u.Id;
       	events.Description = 'Description';
        events.RecordTypeId = '012410000013G9CAAU';
        events.Current_Appointment__c=False;      
        
        insert events; 
        
        test.startTest();
        
        events.OwnerId=u.Id;
        events.Current_Appointment__c=True;
        upsert events;
        
        test.stopTest();
        
        
    }
}