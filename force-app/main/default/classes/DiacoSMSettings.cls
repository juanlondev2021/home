/*
 * Diaco
 * @author             Jull Quintero D
 * Project:            SMS
 * TestClass:          DiacoSMSettingsTest
 * Description:        Diaco SMS Settings
 *
 * Changes (Version)
 * _________________________________________
 *            No.        Date            Author                    Description
 *            ____    __________        __________________      _____________________________________
 * @version   1.0    10/12/2020         Jull Quintero D          Initial implementation of the class.
 * @version   2.0    19/12/2020         Jull Quintero D          SMS Trigger Condition 
 **/

public virtual class DiacoSMSettings {

    // Condition Types
    private static String CHANGE_CONDITION = 'CHANGEC'; 
    private static String COMPARE_STATIC_CONDITION = 'COMPAREC'; 
    private static String CONTAINS_RECORDTYPE = 'FIND_BY_RECORDTYPE'; 
    private static String CONTAINS = 'CONTAINS'; 
    private static String ISNULL = 'ISNULL'; 
    private static String ISNOTNULL = 'ISNOTNULL'; 


    // Logic
    private static String OR_LOGIC = 'OR';
    private static String AND_LOGIC = 'AND'; 
    private static String CUSTOM_lOGIC = 'CUSTOM_lOGIC'; 

    private static Boolean isUpdateOld;
    private static Boolean isInsertOld;
    private static String objectApiNameOld;
    private static NotCondData conditionsToEvaluate;

    private static Map<String,String> diacoSenderName;

    /*
    *@Author: Jull Q Daza - 19/12/2020
     * This method is responsible to get SMS Trigger Notifications
     * 
     * This method is used in:
     * CreateSMS.cls
     * 
     * @param String (Object ApiName)
     * @param Boolean (Update)
     */
    public static NotCondData getConditionsToEvaluate(String objectApiName,Boolean isInsert, Boolean isUpdate) {
        if( objectApiNameOld != objectApiName || isUpdateOld != isUpdate || isInsertOld != isInsert) {

            List<SMS_Send_Condition__c> conditionFromObject = [SELECT Id,ObjectApiName__c,Notification_Id__c,IsInsert__c,IsUpdate__c,Number__c,
                                                                    FieldApiName__c,Condition_Type__c,Compare_Static_Value__c,
                                                                    Compare_Static_Operation__c
                                                                FROM SMS_Send_Condition__c 
                                                                WHERE ObjectApiName__c = :objectApiName AND 
                                                                (IsInsert__c = :isInsert OR IsUpdate__c = :isUpdate) ];

            List<SMS_Notification_Status__c> activeNots = [SELECT Id,ParentId_ApiName__c,Active__c,Category__c,Diaco_SenderId__c,Diaco_TemplateId__c,SMSText__c,
                                                                Magic_SenderId__c,Magic_Source__c,Magic_TemplateId__c,conditions__c,Customize_Logic__c,
                                                                Object_ApiName__c,PhoneNumber_ApiName__c,Provider__c,Type__c
                                                            FROM SMS_Notification_Status__c
                                                            WHERE Object_ApiName__c = :objectApiName AND Active__c = true];

            Map<Id, SMS_Notification_Status__c> activeNotsMap = new Map<Id, SMS_Notification_Status__c>(activeNots);
            Map<Id, List<SMS_Send_Condition__c>> conditionsByNot = new Map<Id, List<SMS_Send_Condition__c>>();
    
            Integer conditionFromObjectSize = conditionFromObject.size();
            for (Integer i = 0; i < conditionFromObjectSize; i++) {
                SMS_Send_Condition__c contoeval = conditionFromObject[i];
                if( activeNotsMap.get(contoeval.Notification_Id__c) != null && activeNotsMap.get(contoeval.Notification_Id__c).Active__c ) {
                    Id notId = activeNotsMap.get(contoeval.Notification_Id__c).Id;
                    if( conditionsByNot.get(notId) == null ) {
                        conditionsByNot.put(notId, new List<SMS_Send_Condition__c>());
                    }
                    conditionsByNot.get(notId).add(contoeval);
                }
            }

            NotCondData returnValue = new NotCondData();
            returnValue.notifications = activeNotsMap;
            returnValue.conditionsByNot = conditionsByNot;

            conditionsToEvaluate = returnValue;
            objectApiNameOld = objectApiName;
            isInsertOld = isInsert;
            isUpdateOld = isUpdate;
        }
        return conditionsToEvaluate;
    }

    /*
    *@Author: Jull Q Daza - 21/12/2020
     * This method is responsible to evaluate Conditions By Notification Id
     * 
     * This method is used in:
     * CreateSMS.cls
     * 
     * @param List SMS_Send_Condition__c (Custom Setting)
     * @param SObject (newObject)
     * @param SObject (oldObject)
     * @param Boolean (isUpdate)
     */
    public static Boolean evaluateConditions(SMS_Notification_Status__c notification,List<SMS_Send_Condition__c> tgrConditions,SObject newObject,SObject oldObject,Boolean isUpdate) {
        Map<String,Boolean> meetCond = new Map<String,Boolean>();
        Integer tgrConditionsLgth = tgrConditions.size();
        for (Integer i = 0; i < tgrConditionsLgth; i++) {
            SMS_Send_Condition__c condition = tgrConditions[i];
            Boolean value = false;
            if( condition.Condition_Type__c == CONTAINS_RECORDTYPE ) {
                if( String.isNotBlank(condition.Compare_Static_Value__c) && String.isNotBlank(condition.Compare_Static_Operation__c) ) {

                    Id objRecordId = (Id)newObject.get(condition.Compare_Static_Operation__c);
                    Id recordTypeId = (Id)newObject.get(condition.FieldApiName__c);
                    value = containsRecordtype(objRecordId,recordTypeId,condition.Compare_Static_Value__c);
                }

            } else if( condition.Condition_Type__c == CONTAINS ) {
                if( condition.Compare_Static_Value__c != null ) {
                    
                    value = String.valueOf(newObject.get(condition.FieldApiName__c)).contains(condition.Compare_Static_Value__c);
                }

            } else if( condition.Condition_Type__c == CHANGE_CONDITION ) {
                if( isUpdate && oldObject != null ) {
                    
                    value = newObject.get(condition.FieldApiName__c) != oldObject.get(condition.FieldApiName__c);
                }else { value = true;}

            } else if( condition.Condition_Type__c == COMPARE_STATIC_CONDITION ) {
                if( String.isNotBlank(condition.Compare_Static_Operation__c) && String.isNotBlank(condition.Compare_Static_Value__c) ) {
                    String evalExpression =  '"' + newObject.get(condition.FieldApiName__c) + '"' + condition.Compare_Static_Operation__c + '"'+ condition.Compare_Static_Value__c + '"';
                    System.debug('>> evalExpression: ' + evalExpression);
                    value = new RT_Expression(evalExpression).evalBool();
                }
            } else if( condition.Condition_Type__c  == ISNULL ) {
                value = newObject.get(condition.FieldApiName__c) == null;
            
            } else if( condition.Condition_Type__c  == ISNOTNULL ) {
                value = newObject.get(condition.FieldApiName__c) != null;

            } else { return false; }

            if ( notification.conditions__c == CUSTOM_lOGIC ) {
                if( condition.Condition_Type__c == null ) return false;
                meetCond.put(String.valueOf(condition.Number__c), value);
            }else {
                meetCond.put(String.valueOf(i), value);
            }
        }

        Boolean value = false;
        // OR
        if ( notification.conditions__c == OR_LOGIC ) {
            list<Boolean> values = meetCond.values();
            if( values.contains(true) ) value = true;
            
        } // AND 
        else if ( notification.conditions__c == AND_LOGIC ) {
            list<Boolean> values = meetCond.values();
            if( !values.contains(false) ) value = true;
            
        }
        // Custom Logic
        else if( notification.conditions__c ==  CUSTOM_lOGIC ) {
            if( notification.Customize_Logic__c != null ) {
                String customLogic =  notification.Customize_Logic__c; //'( 1 || 2 ) && 3';
                List<String> logicHar = customLogic.split('');
                Integer logicHarSize = logicHar.size();
                string logical= '';
                for (Integer i = 0; i < logicHarSize; i++) {
                    String str = logicHar[i];
                    String val = string.valueOf(meetCond.get(str)); 
                    logical += val != null ? val: str;
                }    
                System.debug('>> logical: ' + logical);
                if( string.isNotBlank(logical) ) {
                    value = new RT_Expression(logical).evalBool();
                    System.debug('>> value: ' + value);
                }
            }
        }
        return value;
    }

    /*
    *@Author: Jull Q Daza - 10/12/2020
     * This method is responsible to return true if string name is contained in record type
     * 
     * @param SObject (newObject)
     * @param String (nameStr) 
     */
    @TestVisible
    private static Boolean containsRecordtype(Id objRecordId,Id recordTypeId,String nameStr) {
        if( objRecordId != null && recordTypeId != null ) {
            String objectName = objRecordId.getSObjectType().getDescribe().getName();        
            string recordtypeName = Schema.getGlobalDescribe().get(objectName).getDescribe().getRecordTypeInfosById().get(recordTypeId).getName();
            if( recordtypeName.contains(nameStr) ) {
                return true;
            }   
        }
        return false;
    }
    

    /*
    *@Author: Jull Q Daza - 10/12/2020
     * This method is responsible to get Slack Channel
     * 
     * This method is used in:
     * DsmsMessageTriggerHelper.cls
     * 
     * @param List String Phone Number
     */
    public static Map<String,String> getDiacoSMSenderSlackChannel(Set<String> phones) {
        if( diacoSenderName == null ) {
            diacoSenderName = new Map<String,String>();
            List<dsms__Phone_Number__c> senderIds = [SELECT Id,Name,dsms__Phone_Number__c,dsms__Active__c,Slack_Channel__c 
                                                    FROM dsms__Phone_Number__c 
                                                    WHERE dsms__Phone_Number__c IN :phones AND dsms__Active__c=true];
            Integer senderIdLength = senderIds.size();
            for (Integer i = 0; i < senderIdLength; i++) {
                diacoSenderName.put(senderIds[i].dsms__Phone_Number__c, senderIds[i].Slack_Channel__c);
            }
            return diacoSenderName;
        }
        return diacoSenderName;
    }


    /*
    *@Author: Jull Q Daza - 11/12/2020
     * This method is responsible to get Account name by Parent Id
     * 
     * This method is used in:
     * DsmsMessageTriggerHelper.cls
     * 
     * @param Set Ids
     */
    public static Map<Id,String> getParentNames (Set<Id> parentIds) {
        List<Account> accts = new List<Account>();
        List<Home_services__c> hServices = new List<Home_services__c>();
        Map<Id,String> parentName = new Map<Id,String>();
        Set<String> hsIds = new Set<String>();
        Set<String> acctIds = new Set<String>();

        for (String parentId : parentIds) {
            String sObjName = id.valueOf(parentId).getSObjectType().getDescribe().getName();
            if( sObjName == 'Account' ){
                acctIds.add(parentId);
            }else if( sObjName == 'Home_services__c' ){
                hsIds.add(parentId);
            }
        }

        if( !hsIds.isEmpty() ) {
            hServices =  [SELECT Id,Account__c,Account__r.Name FROM Home_services__c WHERE Id IN :hsIds];
        }

        if( !acctIds.isEmpty() ) {
            accts = [SELECT Id, Name FROM Account WHERE Id IN :acctIds];
        }
        if( !accts.isEmpty() || !hServices.isEmpty() ) {
            Integer acctsLgth = accts.size(); Integer hServicesLgth = hServices.size(); 
            for (Integer i = 0; i < acctsLgth; i++) {
                parentName.put(accts[i].id, accts[i].name);
            }

            for (Integer j = 0; j < hServicesLgth; j++) {
                Home_services__c  hs = hServices[j];
                if( hs.Account__c != null )
                    parentName.put(hs.id, hs.Account__r.Name);
            }
        }
        return parentName;
    }

    public class NotCondData{
        public Map<Id, SMS_Notification_Status__c> notifications;
        // conditions by notification id
        public Map<Id, List<SMS_Send_Condition__c>> conditionsByNot;
    }
}