@isTest
public class CustomSetting_test {
    
    @isTest static void Test(){  
        
        Text_Settings_Appt__c CSetting = new  Text_Settings_Appt__c(
            Name='a4Z0m0000008gcZ',
            Appt_Confirmed_HA__c = true, 
            Appt_Confirmed_SO__c = true, 
            Appt_Confirmed_WA__c = true, 
            Appt_Confirmed_WI__c = true, 
            Appt_Set_HA__c = true,
            Appt_Set_SO__c = true, 	
            Appt_Set_WA__c = true,
            Appt_Set_WI__c = true,
            Sale_Confirmation_Text_Home_Automation__c = true, 
            Sale_Confirmation_Text_Pest_Control__c = true, 
            Sale_Confirmation_Text_Solar__c = true,
            Sale_Confirmation_Text_Water__c = true, 
            Sale_Confirmation_Text_Window__c = true, 
            Sale_New_Appointment_Home_Automation__c = true, 
            Sale_New_Appointment_Pest_Control__c = true,
            Sale_New_Appointment_Solar__c = true, 
            Sale_New_Appointment_Water__c = true, 
            Sale_New_Appointment_Window__c = true, 
            Sale_In_Transit_Home_Automation__c = true, 
            Sale_In_Transit_Pest_Control__c = true,
            Sale_In_Transit_Solar__c = true, 
            Sale_In_Transit_Water__c = true, 
            Sale_In_Transit_Window__c = true,
            Installation_Confirmation_Text_Home_A__c = true, 
            Installation_Confirmation_Text_Pest_C__c = true, 
            Installation_Confirmation_Text_Solar__c = true,
            Installation_Confirmation_Text_Water__c = true, 
            Installation_Confirmation_Text_Window__c = true, 
            Installation_New_Appointment_Home_Aut__c = true,
            Installation_New_Appointment_Pest_Con__c = true, 
            Installation_New_Appointment_Solar__c = true, 
            Installation_New_Appointment_Water__c = true,
            Installation_New_Appointment_Window__c = true, 
            Installation_In_Transit_Home_Automati__c = true, 
            Installation_In_Transit_Pest_Control__c = true,
            Installation_In_Transit_Solar__c = true, 
            Installation_In_Transit_Water__c = true, 
            Installation_In_Transit_Window__c = true 
        );
        
        upsert CSetting;
        
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(CSetting);
        customSettings cs = new customSettings(sc);
        cs.getcustomsetting();
        cs.test();
        customSettings.getRecordId();
        customSettings.SaveInformation(CSetting);
        
        Test.stopTest();   
    }
    
}