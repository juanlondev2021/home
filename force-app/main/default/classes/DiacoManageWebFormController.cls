/**
* Diaco
* @author 			Álvaro Ortega href=<aovargas05@gmail.com>
* Project:			WebFormManage
* Description:		WebFormManage
*
* Changes (Version)
* ___________________________________
*			No.		Date			Author					Description
*			_____	__________		____________________	____________________________________
* @version	1.0		03/04/2019		Alvaro Ortega (AO)		Initial implementation of the class
**/
public class DiacoManageWebFormController {
    @AuraEnabled
    public static List<RecordType> getDataRecordType(){
        List<RecordType> RT = [select Id, Name 
                            from RecordType 
                            where sObjectType='Home_Services__c' AND Name like '%Sales'];
        return RT;
    }
    
    @AuraEnabled
    public static Account getCurrentInfo(String recordId){
        String objectType = getObjectType(recordId);
        List<Account> acs;
        system.debug('||||||||||||||||||||||'+objectType);
        if(objectType.contains('Account')){
            acs = [select Id, Name, Interests__c, Phone_Rep_Email__c
                   from Account 
                   where Id=:recordId];
        }else if(objectType.contains('webForm')){
            List<webForm__c> wf = [select Id, Account__c
                                         from webForm__c 
                                         where Id=:recordId];
            if(wf.size() > 0){
                acs = [select Id, Name, Interests__c, Phone_Rep_Email__c
                       from Account 
                       where Id=:wf[0].Account__c];
            }else{
                return null;
            }
        }else{
            acs = [select Id, Name, Interests__c, Phone_Rep_Email__c
                   from Account 
                   where Id=:recordId];
        }
        
        if(acs.size() > 0){
            return acs[0];
        }
        return null;
    }
    
    public static String getObjectType(String recordId){
        String objectAPIName = '';
        String keyPrefix = recordId.substring(0,3);
        for(Schema.SObjectType obj : Schema.getGlobalDescribe().Values()){
            String prefix = obj.getDescribe().getKeyPrefix();
            if(prefix != null && prefix.contains(keyPrefix)){
                objectAPIName = obj.getDescribe().getName();
                break;
            }
        }
        return objectAPIName;
    }
    
    @AuraEnabled
    public static webForm__c createWebForm(webForm__c webForm){
        upsert webForm;
        return webForm;
    }
    
    @AuraEnabled
    public static Account saveAccount(Account Acc){
        upsert Acc;
        return Acc;
    }
    
    @AuraEnabled
    public static webForm__c deleteWebForm(String recordId){
        webForm__c w = new webForm__c();
        w.Id = recordId;
        delete w;
        return w;
    }
    
    @AuraEnabled
    public static List<webForm__c> getWebForms(String recordId){
        List<webForm__c> wfs = [select Id, Name, Book_Now_Date__c, Notes__c, Interests__c, Status__c, Home_Service__c
                               from webForm__c
                               where Account__c = : recordId
                               order by CreatedDate desc];
        return wfs;
    }
    
    @AuraEnabled        
    public static List<String> getPickListValuesIntoList(String objectName, String fieldName){
        List<String> pickListValuesList = new List<String>();
        //Schema.DescribeFieldResult fieldResult = DiacoAlarm__Diaco_Customer_Alarm__c.DiacoAlarm__DiacoCsEventGroupsToForward__c.getDescribe();
        Schema.SObjectType objectType = Schema.getGlobalDescribe().get(objectName);
        // get the fields on the object
        Map<String, SObjectField> fieldMap = objectType.getDescribe().fields.getMap();
        // The key to the map is the api name of the field
        Schema.SobjectField theField = fieldMap.get(fieldName);
        Schema.DescribeFieldResult fieldResult = theField.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
            //System.debug('Values in Rating are: '+pickListValuesList);
        }     
        return pickListValuesList;
    }
    
}