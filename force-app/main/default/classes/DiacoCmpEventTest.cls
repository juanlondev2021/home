@isTest
public class DiacoCmpEventTest {
    @isTest static void testAll(){
	User usr = [Select Id from User where Name='Cody Garrett' limit 1];
    	Account acc   = new Account();
        acc.FirstName = 'Test';
        acc.LastName  = 'test';
        Upsert acc;
        Personnel__c personel  = new Personnel__c();                                                                             // Creo Personel: Requisito del HS
        personel.Kunnect_ID__c = 'test';
        personel.First_Name__c = 'test';
        personel.Last_Name__c  = 'test';
        personel.SF_User__c=usr.Id;
        Upsert personel;
        Id rtId = Schema.SObjectType.Home_Services__c.getRecordTypeInfosByName().get('Water Treatment Sales').getRecordTypeId(); // ID del RT - HS Water
        Home_Services__c hs = new Home_Services__c();                                                                             // Creo HS
        hs.Name                             = 'Test Test - Water Treatment Sales';
        hs.RecordTypeId                     = rtId;
        hs.Account__c                       = acc.Id;
        hs.ApptSetter__c                    = personel.Id;
        hs.Confirmation_Call_Count__c       = 5;                                                                                  // Se supone que esto se llena al crear 5 Task pero nos da error de SOQL, entonces hice igual que tu.
        hs.Appointment_Date_Time__c         =null;
        Upsert hs;
        Event ev2   = new Event();
        ev2.Subject = 'Test';
        ev2.StartDateTime = System.now();
        ev2.EndDateTime=System.now();
        ev2.Home_Service__c=hs.Id;
        ev2.WhatId=hs.Id;
        ev2.IsPublic__c= false;
        test.startTest();
        DiacoCmpEvent.saveDataEvent(ev2);
        test.stopTest();
    }
}