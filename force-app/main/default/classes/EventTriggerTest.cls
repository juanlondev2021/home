/**
 * @description       : 
 * @author            : William Aldana
 * @group             : 
 * @last modified on  : 10-22-2020
 * @last modified by  : William Aldana
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   09-15-2020   William Aldana   Initial Version
**/
@isTest
private class EventTriggerTest {
    //creating test records, oportunities.
    @testsetup 
    static  void createtestdata(){
        //Region creation
        Region__c recRegion = New Region__c( Name = 'Central' );
        Insert recRegion;          
        
        //Branch creation
        Branch__c recBranch = new Branch__c(Name = 'AZ-Test Branch',Carrier_ID__c='Test',Branch_stage__c = 'Delivering',Region_MD__c = recRegion.Id);
        insert recBranch;
        
        //Account creation.
        Account recAccount = new Account(FirstName = 'Test',
                                        LastName = 'Account Record',
                                        Home_Type__c = 'SF',
                                        // Phone = '(888) 111-4444',
                                        PersonMobilePhone = '(987) 372-6612',
                                        PersonEmail = 'testAcc@ymail.com',
                                        Sales_Price__c = 1000,
                                        Respond_Date__c = Date.Today(),
                                        Branch__c = recBranch.id);
        Insert recAccount;
        System.assertNotEquals(null, recAccount.id);
        
        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'TestOpportunity';
        testOpp.AccountId = recAccount.Id;
        testOpp.StageName = 'Qualified';
        testOpp.CloseDate = system.today();
        insert testOpp;
        system.assertNotEquals(null, testOpp.id);
        
        //CREATE DIACO Appointment Data
        List<DiacoAppoiment2__AppoinmentType__c> appType= new  List<DiacoAppoiment2__AppoinmentType__c>();
        appType.add(new DiacoAppoiment2__AppoinmentType__c(
            Name = 'Installation',
            DiacoAppoiment2__active__c = true
        ));
        appType.add(new DiacoAppoiment2__AppoinmentType__c(
            Name = 'Sales',
            DiacoAppoiment2__active__c = true
        ));
        appType.add(new DiacoAppoiment2__AppoinmentType__c(
            Name = 'Services',
            DiacoAppoiment2__active__c = true
        ));
        insert appType;
        
        DiacoAppoiment2__Industry__c ind = new DiacoAppoiment2__Industry__c();
        ind.Name='Hs';
        insert ind;
        list<DiacoAppoiment2__Sub_Industry__c> subIndustries = new list<DiacoAppoiment2__Sub_Industry__c>();
        subIndustries.add(new DiacoAppoiment2__Sub_Industry__c(
            Name='Water',
            DiacoAppoiment2__Industry__c = ind.Id
        ));
        
        //SET USER; PERSONNEL AND HOMESERVICE
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
        
    }

    //TEST method for the class EventOpportunitiesStageController, Controller for the DiacoEventUnified Trigger
    @isTest  
    static  void OpportunitiesStageControllerTest(){ 
        Opportunity opp = [select id from Opportunity limit 1];
        test.startTest();
        Event testEvent = new Event();
        testEvent.WhatId = opp.Id; 
        testEvent.StartDateTime = system.today() + 2;
        testEvent.EndDateTime = system.today() + 3;
        insert testEvent;
        system.assertNotEquals(null, testEvent.id);
        
        update new Event(id=testEvent.id,Subject = 'Test',StartDateTime = system.today() -1,EndDateTime = system.today(),Completed__c = True);
        test.stopTest();
    }  

    @isTest 
    static void TestUseRepCountEventAndEventConfig(){
        
        Home_Services__c hs = [SELECT id from Home_Services__c Limit 1];
        User u= [SELECT ID from user where Username = 'TestEvent@test.com' Limit 1];
        System.debug('Previous HsCount event');
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

  //creating test records. 
  /*
  @testsetup 
  static void createtestdata(){
        //Region creation
        Region__c recRegion = New Region__c( Name = 'Central' );
        Insert recRegion;          
        
        //Branch creation
        Branch__c recBranch = new Branch__c(Name = 'AZ-Test Branch',Carrier_ID__c='Test',Branch_stage__c = 'Delivering',Region_MD__c = recRegion.Id);
        insert recBranch;
        
        //Account creation.
        Account recAccount = new Account(FirstName = 'Test',
                                        LastName = 'Account Record',
                                        Home_Type__c = 'SF',
                                        // Phone = '(888) 111-4444',
                                        PersonMobilePhone = '(987) 372-6612',
                                        PersonEmail = 'testAcc@ymail.com',
                                        Sales_Price__c = 1000,
                                        Respond_Date__c = Date.Today(),
                                        Branch__c = recBranch.id);
        Insert recAccount;
        System.assertNotEquals(null, recAccount.id);
        
        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'TestOpportunity';
        testOpp.AccountId = recAccount.Id;
        testOpp.StageName = 'Qualified';
        testOpp.CloseDate = system.today();
        insert testOpp;
        system.assertNotEquals(null, testOpp.id);
    }*/

    @isTest 
    static void eventUpdate(){ 
        Account Acc = new Account();
        Acc.FirstName = 'Account ';
        Acc.LastName = 'Test';
        Acc.RecordTypeId ='012410000012NOKAA2';
        Acc.Street__c='test';
        Acc.City__c='test';
        Acc.State__c='AZ';
        Acc.Zip__c='test';
        Acc.PersonEmail = 'pppp@hotmail.com';
        Acc.Validate_Email__c = 'Valid';
        insert Acc;

        Personnel__c per = new Personnel__c();
        per.Name = 'test';
        per.First_Name__c = 'test';
        per.Last_Name__c = 'test';
        per.Kunnect_ID__c = 'none';
        insert per;
        
       
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

        Opportunity opp = [select id from Opportunity limit 1];
        test.startTest();
        Event testEvent = new Event();
        testEvent.WhatId = opp.Id; 
        testEvent.StartDateTime = system.today() + 1;
        testEvent.EndDateTime = system.today() + 2;
        insert testEvent;
        system.assertNotEquals(null, testEvent.id);
        
        update new Event(id=testEvent.id,Subject = 'Test',StartDateTime = system.today() -1,EndDateTime = system.today(),Completed__c = True, Appointment_results__c = 'Sale Pending');
        test.stopTest();
    }   
    
    @isTest 
    static void eventDelete(){ 
        Opportunity opp = [select id from Opportunity limit 1];
        test.startTest();
        Event testEvent = new Event();
        testEvent.WhatId = opp.Id; 
        testEvent.StartDateTime = system.today() + 1;
        testEvent.EndDateTime = system.today() + 2;
        insert testEvent;
        
        delete testEvent;
        
        test.stopTest();
    } 
    
    @isTest 
    static void eventDeleteHS(){
        
        Account Acc = new Account();
        Acc.FirstName = 'Account ';
        Acc.LastName = 'Test';
        Acc.RecordTypeId ='012410000012NOKAA2';
        Acc.Street__c='test';
        Acc.City__c='test';
        Acc.State__c='AZ';
        Acc.Zip__c='test';
        Acc.PersonEmail = 'pppp@hotmail.com';
        Acc.Validate_Email__c = 'Valid';
        insert Acc;

        Personnel__c per = new Personnel__c();
        per.Name = 'test';
        per.First_Name__c = 'test';
        per.Last_Name__c = 'test';
        per.Kunnect_ID__c = 'none';
        insert per;        

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
        insert hs;

        Event testEvent = new Event();
        testEvent.WhatId = hs.Id; 
        testEvent.StartDateTime = system.today() + 1;
        testEvent.EndDateTime = system.today() + 2;
        insert testEvent;

        test.startTest();        
        delete testEvent;
        test.stopTest();
    }

    @isTest static void testAll(){
        try {
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
        u.LastName = 'Test Event x';
        u.Email = 'test@test.com';
        u.Alias = 'Tcode';
        u.Username = 'TestEventx@test.com';
        u.CommunityNickname = 'test12x';
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
        update events;
        
        test.stopTest();
    } catch (Exception ex) {
            
    }
    }

    @isTest 
    static void sendEmail(){ 
        Account Acc = new Account();
        Acc.FirstName = 'Account ';
        Acc.LastName = 'Test';
        Acc.RecordTypeId ='012410000012NOKAA2';
        Acc.Street__c='test';
        Acc.City__c='test';
        Acc.State__c='AZ';
        Acc.Zip__c='test';
        Acc.PersonEmail = 'pppp@hotmail.com';
        Acc.Validate_Email__c = 'Valid';
        insert Acc;

        Personnel__c per = new Personnel__c();
        per.Name = 'test';
        per.First_Name__c = 'test';
        per.Last_Name__c = 'test';
        per.Kunnect_ID__c = 'none';
        insert per;
        
       
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

        Opportunity opp = [select id from Opportunity limit 1];
        test.startTest();
        Event testEvent = new Event();
        testEvent.WhatId = opp.Id; 
        testEvent.StartDateTime = system.today() + 1;
        testEvent.EndDateTime = system.today() + 2;
        insert testEvent;
        system.assertNotEquals(null, testEvent.id);
        
        update new Event(id=testEvent.id,Subject = 'Test',StartDateTime = system.today() -1,EndDateTime = system.today(),Completed__c = True, Appointment_results__c = 'Sale Pending');
        test.stopTest();
        Send_Grid__c sg = new Send_Grid__c();
        sg.Api_Key__c = 'Bearer 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';
        sg.Home_Automation__c = 'd-d75e2ab400a240b0b810fe67c53c5315';
        sg.Solar__c = 'd-d5b8b63c8adb47f185a098b264e8f0d9';
        sg.Water__c = 'd-16a24857fe654a028c64551d78332161';
        sg.Windows__c = 'd-f87dadd3483a44078f480167be55298a';
        sg.Email_Solar__c = 'info@nergysolutions.com';
        sg.Email_Home_Automation__c = 'info@protectionsource.com';
        sg.Email_Water__c = 'info@aquabrightwater.com';
        sg.Email_Window__c = 'info@latchaz.com';
        insert sg;
        try {
            EventTriggerHelper.sendEmail(testEvent);
        } catch (Exception ex) {
            
        }
        
    }       

    @isTest 
    static void testTemplateLoad(){ 
        Send_Grid__c sg = new Send_Grid__c();
        sg.Api_Key__c = 'Bearer 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';
        sg.Home_Automation__c = 'd-d75e2ab400a240b0b810fe67c53c5315';
        sg.Solar__c = 'd-d5b8b63c8adb47f185a098b264e8f0d9';
        sg.Water__c = 'd-16a24857fe654a028c64551d78332161';
        sg.Windows__c = 'd-f87dadd3483a44078f480167be55298a';
        sg.Email_Solar__c = 'info@nergysolutions.com';
        sg.Email_Home_Automation__c = 'info@protectionsource.com';
        sg.Email_Water__c = 'info@aquabrightwater.com';
        sg.Email_Window__c = 'info@latchaz.com';
        insert sg;

        EventTriggerHelper.getTemplate('Solar');
        EventTriggerHelper.getTemplate('Water');
        EventTriggerHelper.getTemplate('Window');
        EventTriggerHelper.getTemplate('Home Automation');
    }
}