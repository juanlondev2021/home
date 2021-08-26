/*
 * Diaco
 * @author             Jull Quintero D
 * Project:            SMS
 * Description:        Create Magic SMS
 *
 * Changes (Version)
 * _________________________________________
 *            No.        Date            Author                    Description
 *            ____    __________        __________________      _____________________________________
 * @version   1.0    02/12/2020         Jull Quintero D          Initial implementation of the class.
 **/
public class MagicSMS {
    public static List<smagicinteract__smsMagic__c> listSmsMagics = new List<smagicinteract__smsMagic__c>();
    
    private static Id ownerId;
    private static Id getOwnerId 
    {
        get{
            User[] user = [SELECT Id FROM User WHERE Name='Cody Garrett' limit 1];
            if( !user.isEmpty() ) ownerId = user[0].Id;
            return ownerId;
        }
    }

    private Id parentId{get;set;}
    private String senderId{get;set;}
    private Id templateId{get;set;} 
    private String SMSText{get;set;}
    private String mobileNumber{get;set;}
    private String source{get;set;}

    /*@Author: Jull Q Daza - 2/12/2020
     * This Constructor is Responsible to Create Magic SMS
     * 
     * This method is used in:
     * Constructor class CreateSMS
     * 
     *@param Id (record Id)
     *@param String (Sender Id) 
     *@param Id (Template Id)
     *@param String (SMSText ) 
     *@param String (Mobile Phone Number)
     *@param String (source)
     */
    public MagicSMS(Id parentId,String senderId,Id templateId,String SMSText,String mobileNumber,String source) {
        this.parentId = parentId;
        this.senderId = senderId;
        this.templateId = templateId;
        this.SMSText = SMSText;
        this.mobileNumber = mobileNumber;
        this.source = source;
        
        smagicinteract__smsMagic__c  sms = new smagicinteract__smsMagic__c(); 

        String objectName =  this.parentId.getSobjectType().getDescribe().getName();
        if( objectName == 'Home_Services__c' ) { sms.Home_Service__c = this.parentId;} else if( objectName == 'Installation__c' ) { sms.Installation__c = this.parentId;}
        else if( objectName == 'Account' ) { sms.smagicinteract__Account__c = this.parentId;} else if( objectName == 'Appointment__c'){sms.appointment__c = this.parentId;}
        else if( objectName == 'Lead_Form__c') { sms.lead_form__c = this.parentId;} else if( objectName == 'Service__c' ) { sms.Service__c = this.parentId;}
        else if( objectName == 'User_Address__c') { sms.user_address__c = this.parentId; } else if( objectName == 'webForm__c' ) { sms.webform__c = this.parentId;}
        sms.smagicinteract__SenderId__c = this.senderId;

        if( String.isNotBlank(this.SMSText) ) {
            sms.smagicinteract__SMSText__c = this.SMSText;
        }else {
            sms.smagicinteract__SMS_Template__c = this.templateId;
        }
        sms.smagicinteract__PhoneNumber__c = this.mobileNumber;
        sms.smagicinteract__Source__c = this.source;

        sms.smagicinteract__ObjectType__c = objectName;  
        sms.OwnerId = ownerId == null ? getOwnerId : ownerId;
        
        listSmsMagics.add(sms);
    }
}