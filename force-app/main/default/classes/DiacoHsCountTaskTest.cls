/*

 Diaco
 @author 			Esnayder Morales Corpas href=<esnaydermorales25@gmail.com>
 Project:			diacoHsCountTask
 Description:		Test to trigger DiacoTaskUnified
     
 Changes (Version)
 _________________________________________

   No.		Date			Author					Description
   ____	__________      __________________      _____________________________________
@version	1.0		07/10/2019		            Esnayder Morales (ES)	Initial implementation  of the class.
@version	2.0		01/01/2021		            JUll Quintero Daza - Maps delivery date check in
*/

@isTest
public class DiacoHsCountTaskTest {

    @TestSetup static void makeData() {

        // Settings magic sms
        smagicinteract__SMS_SenderId__c senderSolar = new smagicinteract__SMS_SenderId__c(
        	smagicinteract__Label__c = 'Sales:Solar',
            smagicinteract__senderId__c = '1233423544'
        ); 
        insert senderSolar;
        smagicinteract__SMS_SenderId__c senderWater = new smagicinteract__SMS_SenderId__c(
        	smagicinteract__Label__c = 'Sales:Water',
            smagicinteract__senderId__c = '1233423544'
        ); 
        insert senderWater;
        smagicinteract__SMS_Template__c template = new smagicinteract__SMS_Template__c();
		template.smagicinteract__Text__c = 'Hello {!Home_Services__c.first_name__c}, this is N-Ergy with a friendly reminder for your solar appointment today between {!Home_Services__c.appt_window_time__c}. Please text “C” to confirm. We look forward to meeting with you!';
		template.smagicinteract__Name__c = 'Automatic Text - Confirmation "C" Solar';
		insert template;
        smagicinteract__SMS_Template__c template2 = new smagicinteract__SMS_Template__c();
		template2.smagicinteract__Text__c = 'Hello {!Home_Services__c.first_name__c}, this is Water with a friendly reminder for your Water appointment today between {!Home_Services__c.appt_window_time__c}. Please text “C” to confirm. We look forward to meeting with you!';
		template2.smagicinteract__Name__c = 'Automatic Text - Confirmation "C" Water';
        insert template2;
        
        Text_Settings_Appt__c text = new Text_Settings_Appt__c(
        	Sale_Confirmation_C_Home_Automation__c = true,
            Sale_Confirmation_C_Pest_Control__c = true,
            Sale_Confirmation_C_Water__c = true
        );
        insert text;

        Account Acc = new Account();
        Acc.FirstName = 'Account ';
        Acc.LastName = 'Test';
        Acc.RecordTypeId ='012410000012NOKAA2';
        Acc.Street__c='test';
        Acc.City__c='test';
        Acc.State__c='AZ';
        Acc.Zip__c='test';
        Acc.Phone = '000000000';
        insert Acc; 

        Personnel__c per = new Personnel__c();
        per.Name = 'test';
        per.First_Name__c = 'test';
        per.Last_Name__c = 'test';
        per.Kunnect_ID__c = 'none';
        insert per;
        
        Home_Services__c hs = new  Home_Services__c();
        hs.Account__c = Acc.Id;
        hs.RecordTypeId = '012410000013G9KAAU';
        hs.Name='test test test test';
        hs.ApptSetter__c = per.Id;

        Home_Services__c hs2 = new  Home_Services__c();
        hs2.Account__c = Acc.Id;
        hs2.RecordTypeId = '012410000013G9MAAU';
        hs2.Name='test test test test';
        hs2.ApptSetter__c = per.Id;
        List<Home_Services__c> homeServices = new List<Home_Services__c>{hs,hs2};
        insert homeServices;

        // Deliveries
        TestClassUtil.createZipcodeForBranch();
        TestClassUtil.createAccount(2);
        TestClassUtil.createCheetahGiftCardOrder();
        TestClassUtil.createDriver();  
        TestClassUtil.createProductAndHungStatus();
        TestClassUtil.createBranch();
        TestClassUtil.createAddress(2);
        TestClassUtil.createUserAddress(2);
        TestClassUtil.createDeliveryParameter(1);
        Gift_Card_Orders__c giftCardOrder = [SELECT ID FROM Gift_Card_Orders__c LIMIT 1];
        Driver__c driver =  [SELECT ID FROM Driver__c LIMIT 1];
        Branch__c branch = [SELECT ID FROM Branch__c LIMIT 1];
        List<Delivery_Object__c> deliveryObjectLst = new List<Delivery_Object__c>();
        
        for(User_Address__c current : [SELECT Id,UserAccount__c FROM User_Address__c]){
            Delivery_Object__c deliveryObject = new Delivery_Object__c();
            deliveryObject.Person_Account__c = current.UserAccount__c;
            deliveryObject.User_Address__c = current.Id;
            deliveryObject.Driver__c = driver.id;
            deliveryObject.name = '1';
            deliveryObject.Branch_Object__c = branch.id;
            deliveryObject.Parent_Gift_Card_Order__c = giftCardOrder.id;
            deliveryObject.Hung_Status__c = 'Cant Find';            
            deliveryObjectLst.add(deliveryObject);
        }        
        insert deliveryObjectLst;   
    }

    @IsTest
    static void test() {

        test.startTest();

        test.setMock(HttpCalloutMock.class, new diacoSendSweepstakeHttpCallOutMock());

        Home_Services__c[] homeServices = [SELECT Id FROM Home_Services__c];
        Delivery_Object__c[] deliveries = [SELECT Id FROM Delivery_Object__c];

        List<Task> tasks = new List<Task>();
        for(Integer i = 0; i<=3; i++) {
            
            Task task = new Task();
            task.Subject = 'Confirmation Call - No answer';
            task.WhatId = homeServices[0].Id;
            task.Description = 'Test'+i;
            task.Call_Notes__c = 'TEST '+i;
            task.Call_Purpose__c ='Confirmation';
            task.Call_Status__c = 'Attempted Call';

            Task task2 = new Task();
            task2.Subject = 'Confirmation Call - No answer';
            task2.WhatId = homeServices[1].Id;
            task2.Description = 'Test'+i;
            task2.Call_Notes__c = 'TEST '+i;
            task2.Call_Purpose__c ='Confirmation';
            task2.Call_Status__c = 'Attempted Call';

            Task task3 = new Task();
            task3.Subject = 'Check In';
            task3.WhatId = deliveries[0].Id;
            task3.Description = 'Test'+i;
            tasks.add(task); tasks.add(task2); tasks.add(task3);
        }        
        insert tasks;
        test.stopTest();
        
    }
    
    @isTest static void testAllLeadFormLogs(){
        //Verificar dado caso se actualicen mas task del mismo LF 

        Lead_Form__c newLF=new Lead_Form__c();
        insert newLF;
    
        Task task2 = new Task();
        task2.Subject = 'Confirmation Call - No answer';
        task2.WhatId = newLF.Id;
        task2.Dispositions__c='No Answer';
        Test.startTest();
        insert task2;
        Test.stopTest();    
    }

}