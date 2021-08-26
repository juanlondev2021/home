/**
 * @description       : 
 * @author            : William Aldana
 * @group             : 
 * @last modified on  : 12-24-2020
 * @last modified by  : William Aldana
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   12-24-2020   William Aldana   Initial Version
**/
public class DiacoSMSNotificationDTO {
    @AuraEnabled
    public String category;
    @AuraEnabled
    public List<typeNot> TypeNotList;
    @AuraEnabled
    public List<SMS_Notification_Status__c> notifications;
    
    public class typeNot{
        @AuraEnabled
        public String type;
        @AuraEnabled
        public List<SMS_Notification_Status__c> notifications;
    }
}