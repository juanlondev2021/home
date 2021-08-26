/*

Diaco
@author 			Esnayder Morales Corpas href=<esnaydermorales25@gmail.com>
Project:			diacoCmpTask
Description:		Class reponsible test unit to DiacoCmpTaskController

Changes (Version)
_________________________________________

No.		Date			Author					Description
____	__________      __________________      _____________________________________
@version	1.0		21/10/2019		Esnayder Morales (ES)	Initial implementation  of the class.
*/
@isTest
public class DiacoCmpTaskControllerTest {
    @isTest static void testAll(){
        Personnel__c person = new Personnel__c (
            First_Name__c = '1- None'
        );
        insert person;
        Account acc2 = new Account(
            FirstName = 'Test acc',
            LastName = 'last test',
            PersonEmail = 'test@test.com',
            Street__c= 'Test street',
            State__c= 'AZ',
            City__c = 'Arizona',
            Zip__c = '12345',
            Solar_Status__c= 'Test solar',
            Water_Status__c= 'Test water',
            Window_Status__c = 'Test Window',
            Pest_Control_Status__c= 'Test Pest',
            Home_Automation_Status__c= 'Test HA',
            Validate_Email__c = 'valid'
        );
        insert acc2;
        webForm__c webform = new webForm__c(
            FirstName__c = 'Test acc',
            LastName__c = 'last test',
            email__c = 'test@test.com',
            Account__c = acc2.Id
        );
        insert webform;
        webForm__c webform2 = new webForm__c(
            FirstName__c = 'Test acc',
            LastName__c = 'last test',
            email__c = null
            //Account__c = acc2.Id
        );
        insert webform2;
        User u2 = new user();
        u2.LastName = 'Test Public Calendar';
        u2.Email = 'test2@test.com';
        u2.Alias = 'PubliCa';
        u2.Username = 'TestEvent2@test.com';
        u2.CommunityNickname = 'test122';
        u2.LocaleSidKey = 'en_US';
        u2.TimeZoneSidKey = 'GMT';
        u2.ProfileID = '00e41000001hNuFAAU';
        u2.LanguageLocaleKey = 'en_US';
        u2.EmailEncodingKey = 'UTF-8';
        insert u2;
        Home_Services__c hs2 = new Home_Services__c(
          Name = 'test 2',
            Account__c = acc2.Id,
            ApptSetter__c = person.Id,
            RecordTypeId='012410000013G9OAAU'
        );
        insert hs2;
        Task task = new Task(
            Subject='Call',
            Description= 'Test',
            Web_Form__c=webform.Id,
            WhatId=hs2.Id,
            ActivityDate =Date.newInstance(2016, 12, 9),
            //Hours__c = '03:00 PM - 05:00 PM',
            OwnerId = u2.Id,
            Home_Service__c = hs2.Id,
            Priority = 'Priority',
            Status = 'Completed',
            isPublic__c = true
        );
        insert task;
        Task task2 = new Task(
            Subject='Call',
            Description= 'Test',
            Web_Form__c=webform2.Id,
            WhatId=acc2.Id,
            ActivityDate =Date.newInstance(2016, 12, 9),
            //Hours__c = '03:00 PM - 05:00 PM',
            OwnerId = u2.Id,
            Home_Service__c = hs2.Id,
            Priority = 'Priority',
            Status = 'Start',
            isPublic__c = true
        );
        insert task2;
        test.startTest();
        DiacoCmpTaskController.getIdAccount(webform.Id);
        DiacoCmpTaskController.getTasks(webform.Id);
        DiacoCmpTaskController.updateTask(task, '["012410000013G9GAAU","012410000013G9OAAU"]');
        DiacoCmpTaskController.updateTask(task2, '["012410000013G9GAAU","012410000013G9OAAU"]');
        DiacoCmpTaskController.getDataTask(task.Id);
        DiacoCmpTaskController.getDataHS();
        DiacoCmpTaskController.updateWebForm(acc2.Id, webform.Id);
        test.stopTest();
        
    }
    
}