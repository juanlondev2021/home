@isTest
private class DiacoSMSCallAttemptControllerTest {
    @TestSetup
    static void makeData() {
        Test.startTest();
        // SMS
        dsms.diacoSmsExternalTest.setSetup();
        DiacoSMSettingsTest.OBSecurityCampaign();

        // Account
        Id personAcctRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Account acct = new Account(
                FirstName='test',
                BillingState = 'CA', LastName = 'Pass v2',
                RecordTypeId = personAcctRecordTypeId,
                PersonDoNotCall =True,
                Verbal_Consent__c='No',
                phone='1234567890'
        );
        insert acct;
        
        Address__c address = new Address__c();
        address.city__c = 'Test';
        address.county__c= 'Test';
        address.street__c= 'Test';
        address.zip_code__c= 'Test';
        address.Region_Code__c = 'Test';
        address.Zip_Plus_Four__c = 'Test';
        address.state__c= 'AZ';
        address.country__c= 'US';
        //address.Branch__c = newBranch.id;  
        address.Home_Type__c = 'CT';    
        address.MSA__c = 'Tucson AZ'; 
        
        insert address;
        
        User_Address__c inserUserAdd = new User_Address__c();
        inserUserAdd.useraccount__c = acct.id;
        inserUserAdd.address__c= address.id;
        
        insert inserUserAdd;

        // Home Service
        Home_Services__c hs = new Home_Services__c(
            Name = 'test',
            Account__c = acct.Id,
            Home_services_Status__c = '',
            Event_Count__c = 0,
            Installation__c = null,
            Service__c = null
        );
        
        insert hs;
        Test.stopTest();
    }

    @IsTest
    static void test(){
        
        Home_Services__c[] homeService = [SELECT Id,Phone_Number_1__c,Confirmation_Call_Count__c,Confirmation_Call_Notes__c,Confirmation_Call_Status__c FROM Home_Services__c LIMIT 1];

        User_Address__c[] uAddress =  [SELECT Id,Confirmation_Number__c,UserAccount__c FROM User_Address__c LIMIT 1];

        Test.startTest();
            DiacoSMSCallAttemptController.getData(uAddress[0].Confirmation_Number__c);
            DiacoSMSCallAttemptController.sendSMSTo(homeService[0]);
        Test.stopTest();
        
    }
}