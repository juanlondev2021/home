/**
 * Diaco
 * @author             Jull Quintero Daza
 * TestClass:          diacoKnifeFunc_tst
 * Description:        Global Function
 *
 * Changes (Version)
 * _________________________________________
 *            No.        Date            Author                    Description
 *            ____    __________        __________________      _____________________________________
 * @version    1.0    6/04/2021         Jull Quintero D         Initial implementation of the class.
 **/

public class diacoKnifeFunc {

    /**
    * @author Jull Quintero | 6/04/2021 
    * @description: Send Email
    * @param emails(List<String>) 
    * @param subject(String) 
    * @param body(String) 
    **/
    public static Messaging.SendEmailResult[] sendEmail(List<String> address,String subject,String body) {
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = address;
        message.optOutPolicy = 'FILTER';
        message.subject = subject;
        message.plainTextBody = body;
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
        return Messaging.sendEmail(messages);
    }

    /**
    * @author Jull Quintero | 7/04/2021 
    * @description : set multipickList values
    * @param values(List<String>) 
    **/
    public static String formatMultipickList(List<String> values) {
        if (values == null) return null;
        return String.join(values, ';');
    }

    public static List<Map<String, String>> getPicklistValues(String objectName, List<String> picklistFields) {

        List<Map<String, String>> picklistValues = new List<Map<String, String>>();
        List<String> types = new List<String>();
        List<String> typesValues = new List<String>();
        types.add(objectName);
        Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
        for(Schema.DescribeSobjectResult res : results) {
            for(String field : picklistFields) {
                Map<String, String> values = new Map<String, String>();
                System.debug('>field ' + field);
                for (Schema.PicklistEntry entry : res.fields.getMap().get(field).getDescribe().getPicklistValues()) {
                    if (entry.isActive()) {
                        values.put(entry.getValue(), entry.getLabel());
                    }
                }
                picklistValues.add(values);
            }
        }
        return picklistValues;
    }

    public static List<RecordType> getDataRecordType(String objectName) {

        List<RecordType> recordTypes = [SELECT id, name FROM RecordType WHERE sObjectType = :objectName];
        return recordTypes;
    }

    public static Id getRecordTypeIdbyName(String objectName, String recordTypeName) {
        return  Schema.getGlobalDescribe().get(objectName).getDescribe().getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
    }

    public static String getRecordTypeNameById(String objectName, Id recordTypeId) {
        return Schema.getGlobalDescribe().get(objectName).getDescribe().getRecordTypeInfosById().get(recordTypeId).getName();
    }   

    public static  List<PicklistByRecordTypeDTO> getPicklistValueByRecordtype(String objectType, String fieldName,List<Id> recordTypeIds) {

        String sessionId = getSessionIdFromVFPage();
        List<PicklistByRecordTypeDTO> valuesByRecordType = new List<PicklistByRecordTypeDTO>();
        for (Id recordTypeId : recordTypeIds) {    
            String Endpoint = URL.getSalesforceBaseUrl().toExternalForm();      
            endpoint += '/services/data/v45.0';
            endpoint += '/ui-api/object-info/' + objectType + '/picklist-values/' + recordTypeId + '/' + fieldName;

            EncodingUtil.urlEncode(endpoint,'UTF-8');

            HttpRequest req = new HttpRequest();
    
            req.setHeader('Authorization', 'OAuth ' + sessionId);
            req.setHeader('Accept', 'application/json '); 
            req.setHeader('Content-Type', 'application/json');
            req.setEndpoint(endpoint);
            req.setMethod('GET');
            Http http = new Http();
    
            HTTPResponse res = http.send(req);

            Map<String, String> result = new Map<String,String>();
            if( res.getStatus() == 'OK' && res.getStatusCode() == 200 ) {
        
                Map<String,Object> root = (Map<String,Object>) JSON.deserializeUntyped( res.getBody() );
                
                System.debug( ' Response Body : ' + res.getBody() );
    
                List<Object> pValues = (List<Object>) root.get( 'values' );
                //system.debug(pValues);
                for(Object pValue : pValues) {                        
                    Map<String,Object> pValueMap = (Map<String,Object>)pValue;
                    result.put( (String) pValueMap.get('value'), (String) pValueMap.get('label') );    
                }

                valuesByRecordType.add(
                    new PicklistByRecordTypeDTO (
                        fieldName,
                        recordTypeId,
                        result
                    )
                );
                //System.debug( ' result ' + result );
            }
        }
    

        //system.debug('>> valuesByRecordType ' + valuesByRecordType);

        return valuesByRecordType;
    }

    public static  List<PicklistByRecordTypeDTO> getPicklistValueByRecordtype(String objectType,Id recordTypeId, List<String> fieldNames) {
        
        String sessionId = getSessionIdFromVFPage();
        List<PicklistByRecordTypeDTO> valuesByRecordType = new List<PicklistByRecordTypeDTO>();

        for (String fieldName : fieldNames) {    
            
            String Endpoint = URL.getSalesforceBaseUrl().toExternalForm();      
            endpoint += '/services/data/v45.0';
            endpoint += '/ui-api/object-info/' + objectType + '/picklist-values/' + recordTypeId + '/' + fieldName;

            EncodingUtil.urlEncode(endpoint,'UTF-8');

            HttpRequest req = new HttpRequest();
    
            req.setHeader('Authorization', 'OAuth ' + sessionId);
            req.setHeader('Accept', 'application/json '); 
            req.setHeader('Content-Type', 'application/json');
            req.setEndpoint(endpoint);
            req.setMethod('GET');
            Http http = new Http();
    
            HTTPResponse res = http.send(req);

            Map<String, String> result = new Map<String,String>();
            if( res.getStatus() == 'OK' && res.getStatusCode() == 200 ) {
        
                Map<String,Object> root = (Map<String,Object>) JSON.deserializeUntyped( res.getBody() );
                
                System.debug( ' Response Body : ' + res.getBody() );
    
                List<Object> pValues = (List<Object>) root.get( 'values' );
                //system.debug(pValues);
                for(Object pValue : pValues) {                        
                    Map<String,Object> pValueMap = (Map<String,Object>)pValue;
                    result.put( (String) pValueMap.get('value'), (String) pValueMap.get('label') );    
                }

                valuesByRecordType.add(
                    new PicklistByRecordTypeDTO (
                        fieldName,
                        recordTypeId,
                        result
                    )
                );
                //System.debug( ' result ' + result );
            }
        }
        
        //system.debug('>> valuesByRecordType ' + valuesByRecordType);

        return valuesByRecordType;
    }

    private static String getSessionIdFromVFPage() {

        String sessionId = '';
        // Refer to the Page
        PageReference reportPage = Page.SessionIdFromVFPage;
        // Get the content of the VF page
        String vfContent;
        if (!test.isRunningTest()) {
            vfContent = reportPage.getContent().toString();
        }else {
            vfContent = 'Start_Of_Session_Id00D2h0000008b2W!ARgAQKwlAPai99wSQG10TeCDumKQI1HMXnReY.YIcEUPaD6790q4H40mXFdwRXaynB03cpM3_YoFyvvgKczChUp_x9CQPmkUEnd_Of_Session_Id';
        }
        System.debug('vfContent '+vfContent);
        // Find the position of Start_Of_Session_Id and End_Of_Session_Id
        Integer startP = vfContent.indexOf('Start_Of_Session_Id') + 'Start_Of_Session_Id'.length(),
        endP = vfContent.indexOf('End_Of_Session_Id');
        // Get the Session Id
        sessionId = vfContent.substring(startP, endP);
        System.debug('sessionId '+sessionId);

        return sessionId;
    }
    
    public class PicklistByRecordTypeDTO {
        @AuraEnabled
        public String name;
        @AuraEnabled
        public Id recordTypeId;
        @AuraEnabled
        public Map<String,String> result;

        public PicklistByRecordTypeDTO() {
        }

        public PicklistByRecordTypeDTO(String name, Id recordTypeId, Map<String,String> result) {
            this.name = name;
            this.recordTypeId = recordTypeId;
            this.result = result;
        }
    }

}