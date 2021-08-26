@isTest
public class DiacoSMSettingsTest {
    @TestSetup
    static void makeData(){
        confirmationCall();
    }

    public static void confirmationCall() {
        List<dsms__Phone_Number__c> diacoPhoneNumberSMS = new List<dsms__Phone_Number__c>();
        List<String> diacoNamesSMS = new List<String>{'Water','Pest','Remodel','HA','Solar'};
        Integer diacoNamesLgth = diacoNamesSMS.size();
        for (Integer i = 0; i < diacoNamesLgth; i++) {
            diacoPhoneNumberSMS.add(
                new dsms__Phone_Number__c(
                Name=diacoNamesSMS[i],
                Slack_Channel__c = 'test-slack',
                dsms__Active__c = true,
                dsms__Country_Code__c = '1',
                dsms__Phone_Number__c = '+123456789' + i)
            );
        }
        upsert diacoPhoneNumberSMS;

        // magic sender id
        List<smagicinteract__SMS_SenderId__c> magicSerderIdSMS = new List<smagicinteract__SMS_SenderId__c>();
        List<String> magicLabels = new List<String>{'Sales:Water','Sales:Pest','Sales:Remodel','Sales:HA','Sales:Solar'};
        Integer magicLabelLgth = magicLabels.size();
        for (Integer j = 0; j < magicLabelLgth; j++) {
            magicSerderIdSMS.add(
                new smagicinteract__SMS_SenderId__c(
                smagicinteract__senderId__c = '1480800079'+j,
                smagicinteract__Label__c = magicLabels[j])
            );
        }
        upsert magicSerderIdSMS;

        // Magic template
        List<smagicinteract__SMS_Template__c> magicTemplates = new List<smagicinteract__SMS_Template__c>();
        List<String> magicNamesTemplates = new List<String>{'Sales Appt Confirmation "C"'};
        Integer magicNamesTLgth = magicNamesTemplates.size();
        for (Integer t = 0; t < magicNamesTLgth; t++) {
            magicTemplates.add(
                new smagicinteract__SMS_Template__c(
                    smagicinteract__Name__c = magicNamesTemplates[t],
                    smagicinteract__Text__c = 'test'+t
                )
            );
        }
        upsert magicTemplates;

        //SMS Notification Status
        List<SMS_Notification_Status__c> notifications = new List<SMS_Notification_Status__c>();
        for (Integer z = 0; z < diacoNamesLgth; z++) {
            String conditions; String customLogic;
            if( diacoNamesSMS[z] == 'Water' ) {
                conditions = 'CUSTOM_lOGIC';
                customLogic = '1 && 2';
            }else if( diacoNamesSMS[z] == 'Pest' ){
                conditions = 'OR';
            }else {
                conditions = 'AND';
            }
            notifications.add(
                new SMS_Notification_Status__c (
                    Name='test'+z,
                    ParentId_ApiName__c = 'Id',
                    conditions__c = conditions,
                    Customize_Logic__c = customLogic,
                    Active__c = true,
                    Category__c = diacoNamesSMS[z],
                    Diaco_SenderId__c = diacoPhoneNumberSMS[z].dsms__Phone_Number__c,
                    Diaco_TemplateId__c = magicTemplates[0].Id,
                    Magic_SenderId__c = magicSerderIdSMS[z].smagicinteract__senderId__c,
                    Magic_Source__c = '12345',
                    Magic_TemplateId__c = magicTemplates[0].Id,
                    Object_ApiName__c = 'Home_Services__c',
                    PhoneNumber_ApiName__c = 'Phone_Number_1__c',
                    Provider__c = 'Diaco SMS',
                    Type__c = 'test'
                )
            );
        }

        upsert notifications;

        // SMS Send Condition
        List<SMS_Send_Condition__c> conditions = new List<SMS_Send_Condition__c>();
        integer notificationsLgth = notifications.size();
        for (Integer r = 0; r < notificationsLgth; r++) {
            conditions.add(
                new SMS_Send_Condition__c(
                    Name = 'COMPAREC'+r,
                    Number__c = r,
                    IsUpdate__c = true,
                    Notification_Id__c = notifications[r].Id,
                    FieldApiName__c = 'Confirmation_Call_Count__c',
                    Compare_Static_Operation__c = '==',
                    Compare_Static_Value__c = '5',
                    Condition_Type__c = 'COMPAREC',
                    ObjectApiName__c = 'Home_Services__c'
                )
            );
            conditions.add(
                new SMS_Send_Condition__c(
                    Name = 'CHANGEC'+r,
                    Number__c = r,
                    IsUpdate__c = true,
                    Notification_Id__c = notifications[r].Id,
                    FieldApiName__c = 'Confirmation_Call_Count__c',
                    Condition_Type__c = 'CHANGEC',
                    ObjectApiName__c = 'Home_Services__c'
                )
            );
            conditions.add(
                new SMS_Send_Condition__c(
                    Name = 'FIND_BY_RECORDTYPE'+r,
                    Number__c = r,
                    Compare_Static_Operation__c = 'Id',
                    IsUpdate__c = true,
                    Notification_Id__c = notifications[r].Id,
                    FieldApiName__c = 'RecordTypeId',
                    Compare_Static_Value__c = 'Solar',
                    Condition_Type__c = 'FIND_BY_RECORDTYPE',
                    ObjectApiName__c = 'Home_Services__c'
                )
            );
            conditions.add(
                new SMS_Send_Condition__c(
                    Name = 'CONTAINS'+r,
                    Number__c = r,
                    IsUpdate__c = true,
                    Notification_Id__c = notifications[r].Id,
                    FieldApiName__c = 'Name',
                    Compare_Static_Value__c = 'test',
                    Condition_Type__c = 'CONTAINS',
                    ObjectApiName__c = 'Home_Services__c'
                )
            );
            conditions.add(
                new SMS_Send_Condition__c(
                    Name = 'ISNOTNULL'+r,
                    Number__c = r,
                    IsUpdate__c = true,
                    Notification_Id__c = notifications[r].Id,
                    FieldApiName__c = 'Account__c',
                    Condition_Type__c = 'ISNOTNULL',
                    ObjectApiName__c = 'Home_Services__c'
                )
            );
            conditions.add(
                new SMS_Send_Condition__c(
                    Name = 'ISNULL'+r,
                    Number__c = r,
                    IsUpdate__c = true,
                    Notification_Id__c = notifications[r].Id,
                    FieldApiName__c = 'Appt_End_Time__c',
                    Condition_Type__c = 'ISNULL',
                    ObjectApiName__c = 'Home_Services__c'
                )
            );            
        }
        upsert conditions;
    }

    public static void consentCanvasser() {
        List<dsms__Phone_Number__c> diacoPhoneNumberSMS = new List<dsms__Phone_Number__c>();
        List<String> diacoNamesSMS = new List<String>{'Consent'};
        Integer diacoNamesLgth = diacoNamesSMS.size();
        for (Integer i = 0; i < diacoNamesLgth; i++) {
            diacoPhoneNumberSMS.add(
                new dsms__Phone_Number__c(
                Name=diacoNamesSMS[i],
                Slack_Channel__c = 'test-slack',
                dsms__Active__c = true,
                dsms__Country_Code__c = '1',
                dsms__Phone_Number__c = '+123456789' + i)
            );
        }
        upsert diacoPhoneNumberSMS;

        // magic sender id
        List<smagicinteract__SMS_SenderId__c> magicSerderIdSMS = new List<smagicinteract__SMS_SenderId__c>();
        List<String> magicLabels = new List<String>{'Consent'};
        Integer magicLabelLgth = magicLabels.size();
        for (Integer j = 0; j < magicLabelLgth; j++) {
            magicSerderIdSMS.add(
                new smagicinteract__SMS_SenderId__c(
                smagicinteract__senderId__c = '1480800079'+j,
                smagicinteract__Label__c = magicLabels[j])
            );
        }
        upsert magicSerderIdSMS;

        //SMS Notification Status
        SMS_Notification_Status__c notification = new SMS_Notification_Status__c (
            Name='Consent Canvasser',
            ParentId_ApiName__c = 'Id',
            conditions__c = 'AND',
            Active__c = true,
            Diaco_SenderId__c = diacoPhoneNumberSMS[0].dsms__Phone_Number__c,
            Magic_SenderId__c = magicSerderIdSMS[0].smagicinteract__senderId__c,
            Magic_Source__c = '12345',
            Object_ApiName__c = 'Account',
            PhoneNumber_ApiName__c = 'Phone',
            Provider__c = 'Diaco SMS',
            Type__c = 'test',
            SMSText__c = 'test'
        );

        upsert notification;
    }

    public static void OBSecurityCampaign() {

        // Diaco Template
        dsms__Template__c diacoTemplateSms = new dsms__Template__c(
            Name = 'OBSecurity',
            dsms__Message__c = 'test',
            dsms__Primary_Object__c = 'Home_Services__c'
        );
        
        upsert diacoTemplateSms;

        // Diaco Sender Id
        dsms__Phone_Number__c diacoPhoneNumber = new dsms__Phone_Number__c(
            Name='OBSecuritySenderId',
            Slack_Channel__c = 'test-slack',
            dsms__Active__c = true,
            dsms__Country_Code__c = '1',
            dsms__Phone_Number__c = '+123456789'
        );
        upsert diacoPhoneNumber;

        // Magic template
        smagicinteract__SMS_Template__c magicTemplateSMS = new smagicinteract__SMS_Template__c(
            smagicinteract__Name__c = 'OBSecuritySenderId',
            smagicinteract__Text__c = 'test'
        );
        upsert magicTemplateSMS;

        // magic sender id
        smagicinteract__SMS_SenderId__c magicSerderId = new smagicinteract__SMS_SenderId__c(
            smagicinteract__senderId__c = '1480800079',
            smagicinteract__Label__c = 'OBSecuritySenderID');
        upsert magicSerderId;

        //SMS Notification Status
        SMS_Notification_Status__c notification = new SMS_Notification_Status__c (
            Name='OB Security Campaign',
            ParentId_ApiName__c = 'Id',
            conditions__c = 'AND',
            Active__c = true,
            Diaco_TemplateId__c = diacoTemplateSms.Id,
            Diaco_SenderId__c = diacoPhoneNumber.dsms__Phone_Number__c,
            Magic_TemplateId__c = magicTemplateSMS.Id,
            Magic_SenderId__c =magicSerderId.smagicinteract__senderId__c,
            Magic_Source__c = '12345',            
            Object_ApiName__c = 'Home_Services__c',
            PhoneNumber_ApiName__c = 'Phone_Number_1__c',
            Provider__c = 'Diaco SMS' );

        upsert notification;
    }

    @IsTest
    static void test() {
        
        Test.startTest();

            Id personAcctRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            Account account = new Account(
                FirstName='test',
                BillingState = 'CA', LastName = 'Pass v2',
                RecordTypeId = personAcctRecordTypeId,
                PersonDoNotCall =True,
                Verbal_Consent__c='No',
                phone='1234567890');
            insert account;

            Id hsSolarSL = Schema.SObjectType.Home_Services__c.getRecordTypeInfosByName().get('Solar Sales').getRecordTypeId();
            Home_Services__c hs = new Home_Services__c(
                    Name                          = '',
                    Account__c                    = account.Id,
                    Recordtypeid                  = hsSolarSL,
                    Appointment_Date_Time__c      = Datetime.now(),
                    Appt_End_Time__c              = null
                    
                );
            insert hs;

            // getConditionsToEvaluate
            DiacoSMSettings.NotCondData notCondactives = DiacoSMSettings.getConditionsToEvaluate('Home_Services__c',false,true);
            DiacoSMSettings.getConditionsToEvaluate('Home_Services__c',true,false);

            System.assertNotEquals(notCondactives.conditionsByNot.values().size(), 0);
            // evaluateConditions
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
            List<SMS_Send_Condition__c> conditions = notCondactives.conditionsByNot.values()[0];
            SMS_Notification_Status__c notification = notCondactives.notifications.get(conditions[0].Notification_Id__c);
            DiacoSMSettings.evaluateConditions(notification,conditions,currentHS[0],oldHS[0],true);
            System.assertEquals( DiacoSMSettings.containsRecordtype(currentHS[0].Id,currentHS[0].RecordTypeId,'Solar'), true);

            // getParentNames
            Set<Id> parentIds = new Set<Id>{hs.Id,account.Id};
            DiacoSMSettings.getParentNames(parentIds);

            // getDiacoSMSenderSlackChannel
            Set<String> diacoSenderIds = new Set<String>();
            List<dsms__Phone_Number__c> senderIds = [SELECT Id,Name,dsms__Phone_Number__c,dsms__Active__c 
                                                    FROM dsms__Phone_Number__c 
                                                    WHERE dsms__Active__c=true];
            Integer senderIdLength = senderIds.size();
            for (Integer j = 0; j < senderIdLength; j++) {
                diacoSenderIds.add(senderIds[j].dsms__Phone_Number__c);
            }
            DiacoSMSettings.getDiacoSMSenderSlackChannel(diacoSenderIds);
        Test.stopTest();        
    }
}