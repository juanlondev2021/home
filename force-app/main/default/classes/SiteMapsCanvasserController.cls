/**
 *
 * Diaco
 * Project: Site Maps Canvasser      
 * Description: Lightning In
 * Apex class: SiteMapsCanvasserTest
 * Changes (Version)
 * _________________________________________
 *
 *          No.     Date            Author                  Description
 *          ____    __________      __________________      _____________________________________
 * @version 1.0     11-06-2020      Jull Quintero Daza      Initial implementation  of the class.
 * @version 1.1     04-22-2021      Jull Quintero Daza      Fix Verbal Consent and Consent Type
 */

public with sharing class SiteMapsCanvasserController {
    /**
    *@Description
    * This method is responsible to get: 
    * Object Account, Confimacion Id, Account Picklist values.
    * 
    * This method is used in:
    * SiteMapasCanvasser_HomeOwner.cmp
    *
    * @param String recordId
    * @param List picklistFields (list apiNames)
    * @return WrappedResponse
    **/
    @AuraEnabled
    public static WrappedResponse getDataAccount(Id recordId,List<String> picklistFields) {        
        User_Address__c[] uAddress =  
        [
            SELECT 
                Id,
                UserAccount__c,
                Confirmation_Number__c 
            FROM User_Address__c 
            WHERE UserAccount__c=:recordId ORDER BY CreatedDate DESC 
            LIMIT 1
        ];

        string confirmationId = null;
        if( !uAddress.isEmpty() ) confirmationId=uAddress[0].Confirmation_Number__c;
        
        // Get Account
        String objectName = recordId.getSobjectType().getDescribe().getName();
        id currentId;
        if ( objectName == 'Account' ) {
            currentId = recordId;
        }else if ( objectName == 'Delivery_Object__c' ) {
            currentId  = 
            [
                SELECT 
                    Id,
                    Person_Account__c 
                FROM Delivery_Object__c 
                WHERE Id = :recordId 

            ]?.Person_Account__c;
        }

        Account account = getAccount(currentId);

        // Get PicklistValues Appointment__c
        List<Map<String, String>> picklistValues = diacoKnifeFunc.getPicklistValues('Account', picklistFields);
        
        WrappedResponse response = new WrappedResponse();
        response.account = account;
        response.confirmationId = confirmationId;
        response.picklistValues = picklistValues;
        return response;
    }

    /**
    *@Description
    * This method is responsible to Update Account and Create canvas Task 
    * 
    * This method is used in:
    * SiteMapasCanvasser_HomeOwner.cmp
    *
    * @param Account account
    * @param Decimal latitude
    * @param Decimal longitude
    * @return WrappedResponse
    **/
    @AuraEnabled
    public static WrappedResponse setAccount(Account account, Decimal latitude, Decimal longitude) {
        WrappedResponse response = new WrappedResponse();
        try {
            // Create Task
            createCanvasTask(account,latitude,longitude);

            // Count task
            Task[] tasks = 
            [
                SELECT Subject 
                FROM Task 
                WHERE WhatId = :account.Id AND Subject LIKE '%Canvasser Disposition%'
            ];
            account.Total_Canvasser_Attempts__c = tasks.size();
            
            // Canvasser info
            account.Canvasser_Geolocation__Latitude__s = latitude;
            account.Canvasser_Geolocation__Longitude__s = longitude;
            account.Last_Canvasser_Attempt__c = Datetime.now();
            account.Dispositioned_By__c = userInfo.getUserId();
            account.Consent_Source__c = 'Canvasser';
            
            // if canvasser Disposition is Consent
            if( account.Canvasser_Disposition__c == 'Consent Y' || account.Canvasser_Disposition__c == 'Consent N' ) {
                /*User[] user = [SELECT Id, Personnel__c FROM User WHERE Id = :userInfo.getUserId()];
                Id personnelId = !user.isEmpty() ? user[0].Personnel__C : null;
                account.Consent_By_Personnel__c = personnelId;
                //account.Consent_Type__c = 'SMS';*/
                account.User_Who_Captured_Verbal_Consent__c = userInfo.getUserId();
                account.Verbal_Consent_Date_Stamp__c = Datetime.now();
                account.Consent_Captured_Date__c = Date.today();
                account.Verbal_Consent__c = account.Canvasser_Disposition__c == 'Consent Y' ? 'Yes' : account.Canvasser_Disposition__c == 'Consent N' ? 'No' : null;
            }
            update account;
            Account accountNw = getAccount(account.Id);
            if( accountNw != null ) {
                response.success = true; response.account = accountNw;
            }else{
                response.success = false; response.message = 'Account not found';
            }
        } catch (Exception e) {
            response.success = false; response.message = e.getMessage();
        }
        return response;
    }

    /**
    *@Description
    * This method is responsible to create SMS Magic
    * 
    * This method is used in:
    * SiteMapasCanvasser_HomeOwner.cmp
    *
    * @param Account
    * @param confirmationId (String)
    * @param phoneNumbers ( List<String>)
    * @return WrappedResponse
    **/
    @AuraEnabled
    public static WrappedResponse sendSMSto(Account account, String confirmationId, List<String> phoneNumbers) {
        WrappedResponse response = new WrappedResponse();
        confirmationId = confirmationId != null ?  confirmationId : '';
        String firstName = !String.isEmpty(account.FirstName) ? account.FirstName : '';
        String lastName = !String.isEmpty(account.LastName) ? account.LastName : '';  
        string fullName = firstName + ' ' + lastName;
        String text = 'Hello ' + fullName +', ' +
        'Click on the link to verify your information: https://app.neighboringaz.com/consent/' + confirmationId + 
        ' Reply “Stop” to opt-out for future SMS.';

        List<SMS_Notification_Status__c> activeNots = 
        [
            SELECT 
                Id,
                Name,
                ParentId_ApiName__c,
                Active__c,
                Category__c,
                Diaco_SenderId__c,
                Diaco_TemplateId__c,
                Magic_SenderId__c,
                Magic_Source__c,
                Magic_TemplateId__c,
                conditions__c,
                Customize_Logic__c,
                Object_ApiName__c,
                PhoneNumber_ApiName__c,
                Provider__c,Type__c
            FROM SMS_Notification_Status__c
            WHERE Name = 'Consent Canvasser' AND Active__c = true
        ];
        
        if( !activeNots.isEmpty() ) {
            SMS_Notification_Status__c notification = activeNots[0];
            notification.SMSText__c = text;
            for (String phone : phoneNumbers) {
                Account canvass = account.clone();
                canvass.Id = account.Id;
                canvass.Phone = phone;
                CreateSMS.makeSMS(canvass,notification);
            }
            CreateSMS.sendSMS();
            account.Dispositioned_By__c = userInfo.getUserId();
            update account;
            response.success = true;
        }else{
            response.success = false; response.message = 'Consent Canvasser No Found';
        }
        return response;
    }

    public static void createCanvasTask(Account account, Decimal latitude, Decimal longitude) {
        string canvasDisposition = !string.isEmpty(account.Canvasser_Disposition__c) ? account.Canvasser_Disposition__c : '';
        string canvasLatitude = latitude != null ? string.valueOf(latitude) : '';
        string canvasLongitude = longitude != null ? string.valueOf(longitude) : '';

        String description = 'Canvarsser Disposition: ' + canvasDisposition + 
        ' - Geolocation:' + canvasLatitude + ',' + canvasLongitude;

        string subject = 'Canvasser Disposition - ' + canvasDisposition;

        Task canvasser = new Task();
        canvasser.ActivityDate = DATE.today();
        canvasser.Description = description;
        canvasser.Geolocation__Latitude__s = latitude;
        canvasser.Geolocation__Longitude__s = longitude;
        canvasser.Status = 'Completed';
        canvasser.Subject = subject;
        canvasser.WhatId = account.Id;
        
        insert canvasser; 
    }

    public static Account getAccount(Id recordId) {
        Account[] accounts = 
        [
            SELECT 
                Id,
                FirstName,
                LastName,
                Phone,
                PersonEmail,
                Street__c,
                Zip__c,
                State__c,
                City__c,
                Year_Built__c,
                Pool__c,
                Number_of_AC_Units__c,
                Number_of_Stories__c,
                Homeowner_2_First_Name__c,
                Homeowner_2_Last_Name__c,
                Homeowner_2_Email__c,
                Homeowner_2_Phone_Number__c,
                Homeowner_2_Mobile__c,
                Canvasser_Disposition__c,
                Canvasser_Notes__c 
            FROM Account 
            WHERE Id=:recordId 
        ];
        
        return !accounts.isEmpty() ? accounts[0] : null;
    } 

    public class WrappedResponse{
        @AuraEnabled
        public Account account{get;set;}
        @AuraEnabled
        public String confirmationId{get;set;}
        @AuraEnabled
        public List<SObject> sms{get;set;}
        @AuraEnabled
        public Boolean success{get;set;}
        @AuraEnabled
        public String message{get;set;}
        @AuraEnabled
        public List<Map<String, String>> picklistValues{get;set;}
        public WrappedResponse(){}
    }
}