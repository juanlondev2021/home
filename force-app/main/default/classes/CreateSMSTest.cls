@isTest
private class CreateSMSTest {
    @TestSetup
    static void makeData() {        
        // Account
        Id personAcctRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Account account = new Account(
            FirstName='test',
            BillingState = 'CA', LastName = 'Pass v2',
            RecordTypeId = personAcctRecordTypeId,
            PersonDoNotCall =True,
            Verbal_Consent__c='No',
            phone='1234567890');
        insert account;

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
                Account__c                    = account.Id,
                Recordtypeid                  = recordtypeHS[k],
                Appointment_Date_Time__c      = Datetime.now()
            ));
        }
        insert homeServices;
    }

    @IsTest
    static void test() {
        
        Test.startTest();
            dsms.diacoSmsExternalTest.setSetup();
            DiacoSMSettingsTest.confirmationCall();
        
            Map<Id,Home_Services__c>  oldHServiceMap = new Map<Id,Home_Services__c>([SELECT Id,Name,Account__c,RecordTypeId,Appointment_Date_Time__c,Appt_End_Time__c,First_Name__c,Appointment_Date__c,Industry_Company_Name__c,Industry_Formula__c,Confirmation_Call_Count__c,Phone_Number_1__c,Appt_Window_Time__c,Automatic_Text_Confirmation_C__c FROM Home_Services__c]);
            List<Home_Services__c> oldHS = oldHServiceMap.values();
            List<Home_Services__c> currentHS = new List<Home_Services__c>();
    
            Integer oldHSLength = oldHS.size();
            for (Integer i = 0; i < oldHSLength; i++) {
                Home_Services__c old = oldHS[i];
                Home_Services__c current = old.clone();
                current.Id = old.Id;
                current.Confirmation_Call_Count__c = 5;
                currentHS.add(current);
            }
            new CreateSMS(currentHS,oldHServiceMap,false,true); 
            new CreateSMS(currentHS,oldHServiceMap,true,false);
        Test.stopTest();
    }
}