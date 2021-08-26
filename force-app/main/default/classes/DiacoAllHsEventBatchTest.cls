@isTest
public class DiacoAllHsEventBatchTest {
    @testSetup 
    static void setup() {
             
        String accountRT = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        String eventSalesRt = Schema.getGlobalDescribe().get('Event').getDescribe().getRecordTypeInfosByName().get('Sales').getRecordTypeId();
        String eventInstallationRt = Schema.getGlobalDescribe().get('Event').getDescribe().getRecordTypeInfosByName().get('Installation').getRecordTypeId();
       // String eventServicesRt = Schema.SObjectType.Event.getRecordTypeInfosByName().get('Service Technician').getRecordTypeId();
       // String hsWaterSalesRt = Schema.SObjectType.Home_Services__c.getRecordTypeInfosByName().get('Water Treatment Installation').getRecordTypeId();
        String installationWaterRt = Schema.SObjectType.Installation__c.getRecordTypeInfosByName().get('Water').getRecordTypeId();
		String serviceWaterRt = Schema.SObjectType.Service__c.getRecordTypeInfosByName().get('Water').getRecordTypeId();
         
        Personnel__c person = new Personnel__c (
            First_Name__c = 'Test Personnel',
            Kunnect_ID__c = 'test'

        );
        insert person;
        Account acc = new Account(
            FirstName = 'Test acc',
            LastName = 'last test',
            RecordTypeId = accountRT,
            Street__c = 'test',
            City__c = 'test',
            Zip__c = '12345',
            State__c = 'AZ'

        );
        insert acc;


        Home_Services__c hs = new Home_Services__c(
            Name = 'test',
            Account__c = acc.Id,
            ApptSetter__c = person.Id,
            Home_services_Status__c = '',
            Event_Count__c = 0,
            Installation__c = null,
            Service__c = null
         
        );
        insert hs;

        Installation__c install = new Installation__c(
            Name='test',
            RecordTypeId = installationWaterRt,
            Home_Service__c = hs.Id
        );
        insert install;
       
       Service__c service = new Service__c (
       		NAme = 'Test',
            RecordTypeID = serviceWaterRt,
            Home_Service__c = hs.Id
       );

        Event event = new Event(
            WhatId = hs.Id,
            RecordTypeId = eventSalesRt,
            DurationInMinutes =1,
            ActivityDateTime = Date.Today(),
            Subject = 'test',
            Home_Service__c = hs.id,
            IsPublic__c = false
        );
        insert event;

        Event event2 = new Event(
            WhatId = install.Id,
            RecordTypeId = eventInstallationRt,
            DurationInMinutes =1,
            ActivityDateTime = Date.Today(),
            Subject = 'test',
            Home_Service__c = hs.id,
            IsPublic__c = false
        );
        insert event2;
        
        
}
    
    static testmethod void test() {        
        Test.startTest();
        DiacoAllHsEventBatch uca = new DiacoAllHsEventBatch(1);
        Database.executeBatch(uca);
        Test.stopTest();
        // after the testing stops, assert records were updated properly
    }
    
}