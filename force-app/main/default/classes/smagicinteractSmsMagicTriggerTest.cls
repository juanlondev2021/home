/*
 * Diaco
 * @author             William Aldana
 * Project:            SMS Message Actions
 * TestClass:          smagicinteractSmsMagicTriggerTest
 * Description:        Trigger Test Class
 *
 * Changes (Version)
 * _________________________________________
 *            No.        Date            Author                    Description
 *            ____    __________        __________________      _____________________________________
 * @version   1.0     10/12/2020        William Aldana          Initial implementation of the class.
 **/
@istest
private class smagicinteractSmsMagicTriggerTest {
    @isTest static void testChangeEventConfStatusWithSms(){

        Id accRecordTypeId  = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();

        Account acc = new Account();
        acc.Recordtypeid = accRecordTypeId;
        acc.FirstName       = 'Test acc';
        acc.LastName        = 'last test';
        acc.City__c         =  'City';
        acc.County__c       = 'test';
        insert acc;
        
        Home_Services__c hs = new Home_Services__c();
        hs = new Home_Services__c(
            Name                          = '',
            Account__c                    = acc.Id,
            Home_Services_Status__c       = '',
            Sales_Event_Current_Status__c = '',
            Event__c                      = '',
            Tax__c                        = 'Yes'
        );
        insert hs;

        Event event = new Event(
            WhatId = hs.Id,
            DurationInMinutes =1,
            ActivityDateTime = Date.Today(),
            Subject = 'test',
            Home_Service__c = hs.Id,
            IsPublic__c = false,
            Current_Appointment__c = true
        );
        insert event;

        smagicinteract__smsMagic__c sms = new smagicinteract__smsMagic__c();
        sms = new smagicinteract__smsMagic__c(
        smagicinteract__Direction__c = 'IN',
            smagicinteract__SMSText__c ='c',
            Home_Service__c = hs.Id,
            smagicinteract__SenderId__c  = '0000000000',
            smagicinteract__PhoneNumber__c = '0000000000',
            smagicinteract__external_field__c = 'test'
        );
        Insert sms;

        List<Event> eventLst =  [Select Id, Confirmation_Status__c from Event where Id = :event.Id];
        if(!eventLst.isEmpty()){
            System.assertEquals('Confirmed via Text', eventLst.get(0).Confirmation_Status__c);
        }
    }
}