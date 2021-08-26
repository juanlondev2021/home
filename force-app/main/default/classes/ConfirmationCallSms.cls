/*
 * Diaco
 * @author             Jull Quintero D
 * Project:            SMS
 * TestClass:          ConfirmationCallSmsTest
 * Description:        Create Confirmation "C" In Diaco SMS Or Magic SMS
 *
 * Changes (Version)
 * _________________________________________
 *            No.        Date            Author                    Description
 *            ____    __________        __________________      _____________________________________
 * @version   1.0    02/12/2020         Jull Quintero D          Initial implementation of the class.
 * @version   1.1    15/12/2020         Jull Quintero D          implementation SMS Class

 **/

public class ConfirmationCallSms extends DiacoSMSettings {
    private static final List<String> SDIACOPHONENUMBERS = new List<String>{'Water','Pest','Remodel','HA','Solar'};
    private static final List<String> SMAGICLABELS = new List<String>{'Sales:Water','Sales:Pest','Sales:Remodel','Sales:HA','Sales:Solar'};
    private static final List<String> SMAGICTEMPLATES = new List<String>{'Sales Appt Confirmation "C"'};

    /*
    *@Author: Jull Q Daza - 02/12/2020
     * This Constructor is responsible to create SALES CONFIRMATION CALL SMS
     * 
     * Is used in:
     * 
     * HomeServicesTriggerHelper.cls
     * 
     * @param List Home_Services__c newHS, List Home_Services__c oldHS
     */

    public ConfirmationCallSms(List<Home_Services__c> homeServices, Map<Id,Home_Services__c> oldHServiceMap) {

        Integer homeServiceLength = homeServices.size();
        for (Integer i = 0; i < homeServiceLength; i++) {
            Home_Services__c currentHS = homeServices[i];
            Home_Services__c oldHS = oldHServiceMap.get(currentHS.Id);
            if( currentHS.Confirmation_Call_Count__c == 5 &&  
                String.isNotBlank(currentHS.Phone_Number_1__c) &&
                String.isNotBlank(currentHS.Appt_Window_Time__c) &&
                String.isNotBlank(currentHS.Automatic_Text_Confirmation_C__c) &&
                currentHS.Confirmation_Call_Count__c != oldHS.Confirmation_Call_Count__c )
            {   
                Sms water = new Sms(
                    currentHS,oldHS,DiacoSMSettings.getTextSetting.Sale_Confirmation_C_Water__c,
                    'Water','Sale_Confirmation_C_Water','Water','Sales:Water','Sales Appt Confirmation "C"'
                ); 
                if( water.sendSMS() ) continue;

                Sms pestControl = new Sms(
                    currentHS,oldHS,DiacoSMSettings.getTextSetting.Sale_Confirmation_C_Pest_Control__c,
                    'Pest Control','Sale_Confirmation_C_Pest_Control','Pest','Sales:Pest','Sales Appt Confirmation "C"'
                ); 
                if( pestControl.sendSMS() ) continue;

                Sms remodel = new Sms(
                    currentHS,oldHS,DiacoSMSettings.getTextSetting.Sale_Confirmation_C_Window__c,
                    'Remodel','Sale_Confirmation_C_Remodel','Remodel','Sales:Remodel','Sales Appt Confirmation "C"'
                ); 
                if( remodel.sendSMS() ) continue;

                Sms HomeAutomation = new Sms(
                    currentHS,oldHS,DiacoSMSettings.getTextSetting.Sale_Confirmation_C_Home_Automation__c,
                    'HA','Sale_Confirmation_C_Home_Automation','HA','Sales:HA','Sales Appt Confirmation "C"'
                ); 
                if( HomeAutomation.sendSMS() ) continue;

                Sms solar = new Sms(
                    currentHS,oldHS,DiacoSMSettings.getTextSetting.Sale_Confirmation_C_Solar__c,
                    'Solar','Sale_Confirmation_C_Solar','Solar','Sales:Solar','Sales Appt Confirmation "C"'
                ); 
                if( solar.sendSMS() ) continue;
            }
        }
        if( !MagicSMS.listSmsMagics.isEmpty() ) {
            Database.insert(MagicSMS.listSmsMagics, false);
            MagicSMS.listSmsMagics.clear();
        }
        
        if( !DiacoSMS.listSmsDiaco.isEmpty() ) {
            if( !Test.isRunningTest() )Database.insert(DiacoSMS.listSmsDiaco, false);
            DiacoSMS.listSmsDiaco.clear();
        }

    }

    private static String getMessage(Home_Services__c currentHS) {
        String message = 'Hello ' + currentHS.first_name__c + ', this is ' + currentHS.Industry_Company_Name__c + ' with a friendly reminder for your ' + currentHS.Industry_Formula__c + ' appointment tomorrow between ' + currentHS.appt_window_time__c + 
        '. Please text “C” to confirm. We look forward to meeting with you!';
        return message;
    }

    /*@Author: Jull Q Daza - 15/12/2020
     * This method is responsible to create SMS With Magic Or Diaco SMS for Home Service Record type;
     * Water, Pest, Remodel,Home Automation, Solar
     * 
     * This method is used in:
     * Constructor class ConfirmationCallSms
     * 
     *@param Home_Services__c new Home Service
     *@param Home_Services__c old Home Service 
     *@param Text_Settings_Appt__c Custom Setting(Hierarchy)
     *@param String RecordType Name
     *@param Diaco_SMS_Setting__mdt Custom Metadata Type
     *@param dsms__Phone_Number__c SMS Diaco Sender Name
     *@param smagicinteract__SMS_SenderId__c SMS Magic Sender Name 
     *@param smagicinteract__SMS_Template__c SMS Magic Template Name 
     */
    private class Sms{
        private Home_Services__c currentHS{get;set;}
        private Home_Services__c oldHS{get;set;}
        private Boolean textActive{get;set;}
        private String oType{get;set;}
        private String diacoSmsMtd{get;set;}
        private String dSMSenderName{get;set;}
        private String mgicSenderName{get;set;}
        private String magicTemplateName{get;set;}

        private Sms(Home_Services__c currentHS,Home_Services__c oldHS,Boolean textActive,
                    String oType,String diacoSmsMtd,String dSMSenderName,
                    string mgicSenderName, string magicTemplateName) 
        {
            this.currentHS = currentHS;
            this.oldHS = oldHS;
            this.textActive = textActive;
            this.oType = oType;
            this.diacoSmsMtd = diacoSmsMtd;
            this.dSMSenderName = dSMSenderName;
            this.mgicSenderName = mgicSenderName;
            this.magicTemplateName = magicTemplateName;
        }

        public Boolean sendSMS() {
            if( containsRecordtype(this.currentHS.RecordTypeId,this.textActive,this.oType,'Home_Services__c') ) {
                // create sms
                Boolean smsDiacoActivate = diacoSMSActive(this.diacoSmsMtd);
                if( smsDiacoActivate ) {
                    // diaco sms
                    String message = getMessage(this.currentHS);
                    String senderId = getDiacoSMSenderId(SDIACOPHONENUMBERS).get(this.dSMSenderName);
                    if( senderId != null ) 
                        new DiacoSMS(
                            senderId,
                            this.currentHS.Id,
                            this.currentHS.Phone_Number_1__c,
                            message,// messages
                            DATE.today(),
                            true
                        );             
                }
                if( !smsDiacoActivate || Test.isRunningTest() ) {
                    // magic sms
                    String senderId = getMagicSenderId(SMAGICLABELS).get(this.mgicSenderName);
                    Id templateId = getMagicTemplate(SMAGICTEMPLATES).get(this.magicTemplateName);
                    if( templateId != null && senderId != null )
                        new MagicSMS(
                            templateId,
                            senderId,
                            'Home_Services__c',
                            this.currentHS.Id,
                            this.currentHS.Phone_Number_1__c,
                            '1495' //source
                        );
                }
                return true;
            }return false;
        } 
    }
}