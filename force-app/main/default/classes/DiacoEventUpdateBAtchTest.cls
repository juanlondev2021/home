@isTest
public class DiacoEventUpdateBAtchTest {
    @testSetup 
    static void setup() {
        String accountRT = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        String eventSalesRt = Schema.getGlobalDescribe().get('Event').getDescribe().getRecordTypeInfosByName().get('Sales').getRecordTypeId();
        Personnel__c person = new Personnel__c (
            First_Name__c = 'Test Personnel',
            Kunnect_ID__c = 'test'

        );
        insert person;
        Account account = new Account(
                FirstName = 'Test acc',
                LastName = 'last test',
                RecordTypeId = accountRT,
                Street__c = 'test',
                City__c = 'test',
                Zip__c = '12345',
                State__c = 'AZ'
    
            );
        
        insert account;
        List<Home_Services__c> homeServices = new List<Home_Services__c>();
        for (Integer i = 0;i<=10;i++) {
            homeServices.add(new Home_Services__c(
                Name = 'test',
                Account__c = account.Id,
                ApptSetter__c = person.Id,
                Home_services_Status__c = '',
                Event_Count__c = 0,
                Installation__c = null,
                Service__c = null
             
            ));
        }
        insert homeServices;
        DateTime myDateTime = DateTime.newInstance(2021, 1, 31, 7, 8, 16);
        DateTime newDateTime = myDateTime.addHours(3);
        List<Event> events = new List<Event>();
        for (Home_Services__c hs : homeServices) {
            events.add(new Event(
                StartDateTime = myDateTime,
                EndDateTime = newDateTime,
                Home_Service__c = hs.Id,
                WhatId = hs.Id,
                RecordTypeId = eventSalesRt,
                Current_Appointment__c = true
            ));
        }
        insert events;
    }

    static testmethod void test() {   
        List<Event> events = [select Id, Home_Service__c, Home_Service__r.Appointment_Date_Time__c, 
        Home_Service__r.Appt_End_Time__c, StartDateTime, EndDateTime 
        from Event where Current_Appointment__c = true];
        System.debug('Events update');
        System.debug(events);
        Test.startTest();
        DiacoEventUpdateBAtch uca = new DiacoEventUpdateBAtch(200);
        Database.executeBatch(uca);
        Test.stopTest();
        // after the testing stops, assert records were updated properly
    }
    
}