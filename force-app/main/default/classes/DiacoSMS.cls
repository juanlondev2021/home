/*
 * Diaco
 * @author             Jull Quintero D
 * Project:            SMS
 * Description:        Create Diaco SMS
 *
 * Changes (Version)
 * _________________________________________
 *            No.        Date            Author                    Description
 *            ____    __________        __________________      _____________________________________
 * @version   1.0    19/12/2020         Jull Quintero D          Initial implementation of the class.
 **/

public class DiacoSMS {
    public static List<dsms__Message__c> listSmsDiaco = new List<dsms__Message__c>();
    
    private Id parentId{get;set;}
    private String senderId{get;set;}
    private Id templateId{get;set;}
    private String SMSText{get;set;}
    private String mobileNumber {get;set;}
    private Datetime sendDate{get;set;}
    private Boolean smsTrigger{get;set;} 

    /*@Author: Jull Q Daza - 2/12/2020
     * This Constructor is responsible to Create Diaco SMS
     * 
     * This method is used in:
     * Constructor class CreateSMS
     * 
     *@param Id (Record Id)
     *@param String (Sender Id) 
     *@param Id (Template Id)
     *@param String (SMSText ) 
     *@param String (Mobile Phone Number)
     *@param Datetime (sendDate)
     *@param Boolean (Activate Trigger)
     */
    public DiacoSMS(Id parentId,String senderId,Id templateId,String SMSText,String mobileNumber,Datetime sendDate,Boolean smsTrigger){
        this.parentId = parentId;
        this.senderId = senderId;
        this.templateId = templateId;
        this.SMSText = SMSText;
        this.mobileNumber = mobileNumber;
        this.sendDate = sendDate;
        this.smsTrigger = smsTrigger;

        dsms__Message__c  sms = new dsms__Message__c();
        sms.dsms__parentId__c = this.parentId;
        sms.dsms__From__c = this.senderId;
        if( String.isNotBlank(this.SMSText) ) {
            sms.dsms__Message__c = this.SMSText;
        }else {
            sms.dsms__Template__c = this.templateId;
        }
        sms.dsms__To__c = this.mobileNumber;   
        sms.dsms__Send_Date__c = this.sendDate;
        sms.dsms__trigger__c = this.smsTrigger;
        listSmsDiaco.add(sms);
    }    
}