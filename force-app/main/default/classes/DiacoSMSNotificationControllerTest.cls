/**
 * @description       : 
 * @author            : William Aldana
 * @group             : 
 * @last modified on  : 01-08-2021
 * @last modified by  : William Aldana
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   12-23-2020   William Aldana   Initial Version
**/
@isTest
private class DiacoSMSNotificationControllerTest {
    @isTest static void testGetRecordId(){
        SMS_Notification_Status__c nt = new SMS_Notification_Status__c();
        nt.Active__c = true;
        nt.Category__c =  'Test Cat';
        nt.Name = 'Test NOT';
        nt.Object_ApiName__c = 'Home_service__c';
        nt.Provider__c = 'SMS NOT';
        nt.Type__c = 'Test Type';
        nt.conditions__c = 'AND';
        nt.ParentId_ApiName__c = 'Id';
        DiacoSMSNotificationController.Createinformation(new List<SMS_Notification_Status__c> {nt});
        //insert nt;
        DiacoSMSNotificationController.getRecordId();
    }

    @isTest static void testSaveChanges(){
        SMS_Notification_Status__c nt = new SMS_Notification_Status__c();
        nt.Active__c = true;
        nt.Category__c =  'Test Cat';
        nt.Name = 'Test NOT';
        nt.Object_ApiName__c = 'Home_service__c';
        nt.Provider__c = 'SMS NOT';
        nt.Type__c = 'Test Type';
        nt.conditions__c = 'AND';
        nt.ParentId_ApiName__c = 'Id';
        insert nt;
        DiacoSMSNotificationController.SaveInformation(new List<SMS_Notification_Status__c> {nt});
    }
}