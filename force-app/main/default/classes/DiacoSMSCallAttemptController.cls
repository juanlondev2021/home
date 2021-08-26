/**
* Diaco
* @author             Jull Quintero D
* Project:            SMS Security campaing
* Description:        Show Call attempt count so Agent can determine when to send out SMS.
* TestClass:          DiacoSMSCallAttemptControllerTest
*
* Changes (Version)
* _________________________________________
*            No.        Date            Author                    Description
*            ____    __________        __________________      _____________________________________
* @version    1.0   17/02/2021         Jull Quintero D          Initial implementation of the class.
 **/

public with sharing class DiacoSMSCallAttemptController {
    @AuraEnabled
    public static WrappedResponse getData(string confirmationNum) {
        WrappedResponse response = new WrappedResponse();

        // user adders
        User_Address__c[] uAddress =  [SELECT Id,Confirmation_Number__c,UserAccount__c FROM User_Address__c WHERE Confirmation_Number__c=:confirmationNum ORDER BY CreatedDate DESC LIMIT 1];

        if( !uAddress.isEmpty() ) {
            Id accountId = uAddress[0].UserAccount__c;
            // Account
            Account[] accounts = [SELECT Id,Name,FirstName,LastName
                                FROM Account 
                                WHERE Id=:accountId LIMIT 1];
            // Home services
            Map<Id,RecordType> HomeAutomationIds = new Map<Id,RecordType>([SELECT Id, Name FROM RecordType WHERE sObjectType = 'Home_Services__c' AND NAME LIKE '%Home Automation%']);

            Home_Services__c[] homeServices = [SELECT Id,Name,Phone_Number_1__c,Confirmation_Call_Count__c,Confirmation_Call_Notes__c, Confirmation_Call_Status__c FROM Home_Services__c WHERE Account__c = :accountId AND RecordTypeId IN :HomeAutomationIds.keySet() ORDER BY CreatedDate DESC];
            
            if ( !accounts.isEmpty() ) {
                response.account = accounts[0];
                response.homeServices = homeServices;
                response.success = true;
                return response;
            }
        } 
        response.success = false; response.message = 'Home Service Not Found';
        return response;
    }

    @AuraEnabled
    public static WrappedResponse sendSMSTo(Home_Services__c homeService) {
        WrappedResponse response = new WrappedResponse();
        List<SMS_Notification_Status__c> activeNots = [SELECT Id,Name,ParentId_ApiName__c,Active__c,Category__c,Diaco_SenderId__c,
                                                            Diaco_TemplateId__c,Magic_SenderId__c,Magic_Source__c,Magic_TemplateId__c,
                                                            conditions__c,Customize_Logic__c,Object_ApiName__c,PhoneNumber_ApiName__c,
                                                            Provider__c,Type__c,SMSText__c
                                                        FROM SMS_Notification_Status__c
                                                        WHERE Name = 'OB Security Campaign' AND Active__c = true];

        if ( !activeNots.isEmpty() && homeService != null ) {
            try {
                SMS_Notification_Status__c notification = activeNots[0];
                CreateSMS.makeSMS(homeService,notification);
                CreateSMS.sendSMS();
                response.success = true; response.message = 'The SMS has been sent successfully';
            } catch (Exception e) {
                response.success = false; response.message = e.getMessage();
            }
        }else {
            response.success = false; response.message = 'SMS OB Security Campaig Not Found';
        }
        return response;
    }

    public class WrappedResponse {
        @AuraEnabled
        public Home_Services__c[] homeServices{get;set;}
        @AuraEnabled
        public Account account{get;set;}
        @AuraEnabled
        public Boolean success{get;set;}
        @AuraEnabled
        public String message{get;set;}
    }
}