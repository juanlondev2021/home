/**
 * @description       : 
 * @author            : William Aldana
 * @group             : 
 * @last modified on  : 01-08-2021
 * @last modified by  : William Aldana
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   12-23-2020   William Aldana   Initial Version
**/
public class DiacoSMSNotificationController {

    @AuraEnabled
    public static WrapperResponse getRecordId() {
        List<SMS_Notification_Status__c> sett = [SELECT Id,Name,ParentId_ApiName__c,Active__c,Category__c,Diaco_SenderId__c,Diaco_TemplateId__c,
                                                        SMSText__c,Magic_SenderId__c,Magic_Source__c,Magic_TemplateId__c,conditions__c,Customize_Logic__c,Object_ApiName__c,Provider__c,Type__c,PhoneNumber_ApiName__c
                                                FROM SMS_Notification_Status__c];
        // key will be category
        Map<String, Map<String, DiacoSMSNotificationDTO.typeNot>> mapPrefill = new Map<String, Map<String, DiacoSMSNotificationDTO.typeNot>>();
        List<SMS_Notification_Status__c> allNotifications = new List<SMS_Notification_Status__c>();
        for (SMS_Notification_Status__c notSt : sett) {
            String key = notSt.Category__c == null ? 'Not Categorised' : notSt.Category__c;
            if(mapPrefill.get(key) == null){
                mapPrefill.put(key, new Map<String, DiacoSMSNotificationDTO.typeNot>());        
            }
            String type = notSt.Type__c == null ? 'Not Typed' : notSt.Type__c;
            if(mapPrefill.get(key).get(type) == null){
                mapPrefill.get(key).put(type, new DiacoSMSNotificationDTO.typeNot());
            }
            
            if(mapPrefill.get(key).get(type).notifications == null){
                mapPrefill.get(key).get(type).type = type;
                mapPrefill.get(key).get(type).notifications = new List<SMS_Notification_Status__c>(); 
            }

            mapPrefill.get(key).get(type).notifications.add(notSt);    
            allNotifications.add(notSt);        
        }

        // create List of (DiacoSMSNotificationDTO) to sent to the aura
        List<DiacoSMSNotificationDTO> SMSettings = new List<DiacoSMSNotificationDTO>();
        
        for(String key : mapPrefill.keySet()){
            DiacoSMSNotificationDTO smSetting = new DiacoSMSNotificationDTO();
            smSetting.category = key;
            smSetting.TypeNotList = new List<DiacoSMSNotificationDTO.typeNot>();
            Map<String, DiacoSMSNotificationDTO.typeNot> item = mapPrefill.get(key);
            for (String typeS : item.keySet()) {
                smSetting.TypeNotList.add(item.get(typeS));
            }

            SMSettings.add(smSetting);
        }

        Boolean isSystemAdmin = false;
        Profile[] systemAdmin = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        if ( !systemAdmin.isEmpty() ) {
            isSystemAdmin = systemAdmin[0].Id == UserInfo.getProfileId();
        }
        WrapperResponse response = new WrapperResponse();
        response.SMSettings = SMSettings;
        response.allNotifications = allNotifications;
        response.isSystemAdmin = isSystemAdmin;
        return response;
    }
    
	@AuraEnabled
    public static void SaveInformation(List<SMS_Notification_Status__c> notifications){
        update notifications;
    }
    
    @AuraEnabled
    public static void Createinformation(List<SMS_Notification_Status__c> notifications){
        insert notifications;
    }

    public class WrapperResponse {
        @AuraEnabled
        public List<DiacoSMSNotificationDTO> SMSettings;
        @AuraEnabled
        public  List<SMS_Notification_Status__c> allNotifications;
        @AuraEnabled 
        public Boolean isSystemAdmin;
    } 

}