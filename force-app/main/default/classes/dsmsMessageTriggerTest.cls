/*
 * Diaco
 * @author             William Aldana
 * Project:            SMS Message Actions
 * TestClass:          dsmsMessageTriggerTest
 * Description:        Trigger Test Class
 *
 * Changes (Version)
 * _________________________________________
 *            No.        Date            Author                    Description
 *            ____    __________        __________________      _____________________________________
 * @version   1.0     10/12/2020        William Aldana          Initial implementation of the class.
 **/
@istest
private class dsmsMessageTriggerTest {
    @isTest static void testChangeEventConfStatusWithSms() {
        dsms.diacoSmsExternalTest.setSetup();
        DiacoSMSettingsTest.confirmationCall();
        
        Id accRecordTypeId  = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();

        Account acc = new Account();
        acc.Recordtypeid = accRecordTypeId;
        acc.FirstName       = 'Test acc';
        acc.LastName        = 'last test';
        acc.City__c         =  'City';
        acc.County__c       = 'test';
        insert acc;
        
        // home services
        Id hsWaterSL = Schema.SObjectType.Home_Services__c.getRecordTypeInfosByName().get('Water Treatment Sales').getRecordTypeId();
        Id hsPestSL = Schema.SObjectType.Home_Services__c.getRecordTypeInfosByName().get('Pest Control Sales').getRecordTypeId();
        Id hsRemodelSL = Schema.SObjectType.Home_Services__c.getRecordTypeInfosByName().get('Remodel Services').getRecordTypeId();
        Id hsAtomationSL = Schema.SObjectType.Home_Services__c.getRecordTypeInfosByName().get('Home Automation Sales').getRecordTypeId();
        Id hsSolarSL = Schema.SObjectType.Home_Services__c.getRecordTypeInfosByName().get('Solar Sales').getRecordTypeId();
        list<Id> recordtypeHS = new List<Id>{hsWaterSL,hsPestSL,hsRemodelSL,hsAtomationSL,hsSolarSL};
        List<Home_Services__c> homeServices = new List<Home_Services__c>();
        Integer recordtypLgth = recordtypeHS.size();
        for (Integer k = 0; k < recordtypLgth; k++) {
            homeServices.add(new Home_Services__c(
                Name                          = '',
                Account__c                    = acc.Id,
                Home_Services_Status__c       = '',
                Sales_Event_Current_Status__c = '',
                Event__c                      = '',
                Tax__c                        = 'Yes',
                Recordtypeid                  = recordtypeHS[k],
                Appointment_Date_Time__c      = Datetime.now()
            ));
        }
        insert homeServices;

        Event event = new Event(
            WhatId = homeServices[0].Id,
            DurationInMinutes =1,
            ActivityDateTime = Date.Today(),
            Subject = 'test',
            Home_Service__c = homeServices[0].Id,
            IsPublic__c = false,
            Current_Appointment__c = true
        );
        insert event;

        List<dsms__Message__c> dsmsMessages = new List<dsms__Message__c>();
        Integer HomeServicesLgth = HomeServices.size();
        for (Integer i = 0; i < HomeServicesLgth; i++) {
            Home_Services__c hs = HomeServices[i];
            string dsmsPhoneNumber = '+123456789'+i;
            dsmsMessages.add(
                new dsms__Message__c(
                    dsms__Type__c = 'inbound',
                    dsms__From__c = '+9876543278',
                    dsms__parentId__c = hs.id,
                    Home_Services_lk__c = hs.Id,
                    dsms__To__c = dsmsPhoneNumber, 
                    dsms__Message__c = 'c',
                    dsms__Send_Date__c = Date.today(),
                    dsms__trigger__c = true
                )
            );
        }
        insert dsmsMessages;

        List<Event> eventLst =  [Select Id, Confirmation_Status__c from Event where Id = :event.Id];
        if(!eventLst.isEmpty()){
            System.assertEquals('Confirmed via Text', eventLst.get(0).Confirmation_Status__c);
        }
    }
}