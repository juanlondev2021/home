/*
 * Diaco
 * @author             Jull Quintero D
 * Project:            SMS
 * TestClass:          CreateSMSTest
 * Description:        Create Diaco SMS OR Magic SMS
 *
 * Changes (Version)
 * _________________________________________
 *            No.        Date            Author                    Description
 *            ____    __________        __________________      _____________________________________
 * @version   1.0    19/12/2020         Jull Quintero D          Initial implementation of the class.
 **/

public class CreateSMS extends DiacoSMSettings {

    /*
     * @Author: Jull Q Daza - 19/12/2020
     *
     * This Constructor is responsible to Create Diaco SMS OR Magic SMS
     *  
     * @param List (SObject)
     * @param Map (SObject) 
     * @param String (Object ApiName)
     * @param Boolean (Update)
     */
    public CreateSMS(SObject[] currents, Map<Id, SObject> oldMap,Boolean isInsert,Boolean isUpdate) {
        if( !currents.isEmpty() ) {
            Id recordId = (Id)currents[0].get('Id');
            String objectApiName = recordId.getSObjectType().getDescribe().getName();        
            NotCondData notCondactives = getConditionsToEvaluate(objectApiName,isInsert,isUpdate);
    
            Integer currentLgth = currents.size();
            if(notCondactives != null && notCondactives.conditionsByNot != null && !notCondactives.conditionsByNot.isEmpty()) {

                for (Integer i = 0; i < currentLgth; i++) {
                    SObject current = currents[i];
                    SObject old = isUpdate ? oldMap.get(current.Id) : null;
        
                    for (Id notToEval : notCondactives.notifications.keyset()) {
                        SMS_Notification_Status__c notification = notCondactives.notifications.get(notToEval);
                        List<SMS_Send_Condition__c> conditions = notCondactives.conditionsByNot.get(notToEval);
                        if( notification != null && conditions != null  )
                            if ( evaluateConditions(notification,conditions,current,old,isUpdate) ) {
                                makeSMS(current,notification);
                            }  
                    }
                }

                sendSMS();
            }
        }
    }

    public static void sendSMS() {

        // Insert SMS
        System.debug('MagicSMS ' + MagicSMS.listSmsMagics);
        if( !MagicSMS.listSmsMagics.isEmpty() ) {
            Database.insert(MagicSMS.listSmsMagics, true);
            MagicSMS.listSmsMagics.clear();
        }
        
        System.debug('DiacoSMS ' + DiacoSMS.listSmsDiaco);
        if( !DiacoSMS.listSmsDiaco.isEmpty() ) {
            if( !Test.isRunningTest() )Database.insert(DiacoSMS.listSmsDiaco, true);
            DiacoSMS.listSmsDiaco.clear();
        }
    }

    public static void makeSMS(SObject current, SMS_Notification_Status__c notification) {
        if( notification.active__c ) {
            // create sms
            Id parentId = (Id)current.get(notification.ParentId_ApiName__c);
            String phoneNumber = (String)current.get(notification.PhoneNumber_ApiName__c);
            System.debug('>> parentId ' + parentId);
            System.debug('>> phoneNumber ' + phoneNumber); 
            if( parentId != null && phoneNumber!= null ) {
                if( notification.Provider__c == 'Diaco SMS' ) { 
                    // Diaco SMS
                    new DiacoSMS(
                        parentId,
                        notification.Diaco_SenderId__c,
                        notification.Diaco_TemplateId__c,
                        notification.SMSText__c,
                        phoneNumber,
                        DateTime.now(),
                        true
                    );            
                } 
                
                if( notification.Provider__c == 'Magic SMS' || Test.isRunningTest() ) { 
                    // Magic SMS
                    new MagicSMS(
                        parentId,
                        notification.Magic_SenderId__c,
                        notification.Magic_TemplateId__c,
                        notification.SMSText__c,
                        phoneNumber,
                        notification.Magic_Source__c
                    );
                }
            }
        }
    }
}