/** 
 * Diaco
 * @author             Jull Quintero Daza
 * Project:            Delivery Driver
 * TestClass:          MapsDeliveryDriverControllerTest 
 * Description:        Maps Cmp Salesforce 1
 *
 * Changes (Version)
 * _________________________________________
 *            No.        Date            Author                    Description
 *            ____    __________        __________________      _____________________________________
 * @version    1.0    25/02/2021         Jull Quintero D         Initial implementation of the class.
 * @version    1.1    01/05/2021         Jeison Hernandez S      Functions to upload a photo to AWS
 **/


public with sharing class MapsDeliveryDriverController {

    @AuraEnabled(cacheable=true)
    public static WrappedResponse getData() {
        WrappedResponse response = new WrappedResponse();

        List<maps__Route__c> mapsRoutes = [SELECT Id, Name, maps__Date__c,Stop__c,Start__c, 
                                                (SELECT  Id,CreatedDate,Name,/*maps__Latitude__c,maps__Longitude__c,*/maps__SortOrder__c,maps__Route__c,Hung_Status__c,Checkout__c,
                                                Checking__c,Delivery_Object__r.Name,Delivery_Object__r.Hung_Status__c,Delivery_Object__r.Hung_DateTieme__c,Delivery_Object__r.Delivery_Date__c,
                                                Delivery_Object__r.maps_Latitude__c,Delivery_Object__r.maps_Longitude__c,Delivery_Object__r.Street__c,Delivery_Object__r.City__c,Delivery_Object__r.State__c,
                                                 Delivery_Object__r.Zip__c,Delivery_Object__r.County__c, Delivery_Object__r.Hang__c, Delivery_Object__r.Aws_Url__c
                                                FROM Maps__Waypoints__r 
                                                WHERE Delivery_Object__c != Null order by maps__SortOrder__c asc) 
                                            FROM maps__Route__c  
                                            WHERE Id  IN (SELECT maps__Route__c FROM Maps__Waypoint__c WHERE Delivery_Object__c != Null) AND 
                                            maps__Date__c = TODAY AND
                                            maps__User__c = :UserInfo.getUserId() AND Stop__c = NULL ORDER BY CreatedDate];

        List<Maps__Waypoint__c> allWaypoints = new List<Maps__Waypoint__c>();
        if( !mapsRoutes.isEmpty() ) {
            Integer mapsRouteSize = mapsRoutes.size();
            for (Integer i = 0; i < mapsRouteSize; i++) {
                List<maps__Waypoint__c> points = mapsRoutes[i].maps__Waypoints__r;
                integer pointSize = points.size();
                for (Integer x = 0; x < pointSize; x++) {
                    allWaypoints.add(points[x]);
                }                
            }
            response.routes = mapsRoutes;
            response.allWaypoints = allWaypoints;
            response.driverName = UserInfo.getName();
            List<Map<String, String>> picklist_values = diacoKnifeFunc.getPicklistValues('Delivery_Object__c', new list<String>{'Hung_Status__c'});
            response.picklist_values = picklist_values;
            response.success = true;
            return response;
        }

        response.message = 'These routes are not available for today, Contact your admin..';
        response.success = false;

        return response; 
    }

    @AuraEnabled
    public static void uploadPhoto(String recordId, String DeliveryId){
        try {
            sendToAws(recordId,DeliveryId);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @Future(callout=true)
    public static void sendToAws(String recordId,String DeliveryId){
        //S3 Key 
        String key = 'XXXXXXXXXXXXXXXXXX'; 
        //S3 Secret Key 
        String secret = 'XXXXXXXXXXXXXXXX';
        String bucket = 'cdn.myhomeservices.com';
        String folder = 'Driver/'+String.valueOf(Date.today());
        String host = 's3-us-west-1.amazonaws.com';
        String method = 'PUT';
        AWSService service=new AWSService(key,secret,bucket,folder,method,host);
		service.UploadDocuments(recordId,DeliveryId);
    }

    private class AWSService{
        public string awsKey {get;set;}
        public string awsSecret {get;set;}
        public string bucketName {get;set;}
        public string methodName {get;set;}
        public string hostName {get;set;}
        public string folder {get;set;}

        public AWSService(string key, string secret, string bucket, string folder, string method, string host){
            this.awsKey=key;
            this.awsSecret=secret;
            this.bucketName=bucket;
            this.methodName=method;
            this.hostName=host;
            this.folder = folder;
        }

        private string ContentType(string fileType) {
            switch on fileType.toLowerCase() {
                when 'csv' {
                    return 'application/vnd.ms-excel';
                }
                when 'png' {
                    return 'image/png';
                }
                when else {
                    return 'image/jpeg';
                }
            }
        }
        /*
        private string CreateAuthHeader(String contentType,String filename, String formattedDateString,string fileExtension){
            string auth;
            String stringToSign = this.methodName+'\n/\n'+contentType+'\n'+formattedDateString+'\n/'+'/'+filename.toLowerCase()+ '.'+fileExtension.toLowerCase();
            Blob mac = Crypto.generateMac('HMACSHA1', blob.valueof(stringToSign),blob.valueof(this.awsSecret));
            String sig = EncodingUtil.base64Encode(mac);
            auth = 'AWS' + ' ' + this.awsKey + ':' + sig;
            return auth;
        }*/

        public void UploadDocuments(string recordId, String DeliveryId){
            if(string.isBlank(this.awsSecret) || string.isBlank(this.awsKey) || string.isBlank(this.bucketName) || string.isBlank(this.hostName)){
                //throw new BaseException('Set AWS credential');
                System.debug('Set AWS credential');
            }
            
            List<ContentVersion> versions=[SELECT VersionData,Title,ContentDocumentId,FileExtension FROM ContentVersion WHERE ContentDocumentId = :recordId Limit 1];
            
            for(ContentVersion attach:versions){
                try{
                    //File Content
                    //String attachmentBody = EncodingUtil.base64Encode(attach.VersionData);
                    String formattedDateString = Datetime.now().formatGMT('EEE, dd MMM yyyy HH:mm:ss z');
                    
                    String filename = attach.Title;
                    string contentType=ContentType(attach.FileExtension);
                    system.debug('contentType:'+contentType);
                    String resource = '/'+ this.bucketName +'/'+this.folder+'/' + DeliveryId.toLowerCase()+ '.'+attach.FileExtension.toLowerCase();
                    string fileUrl='callout:AWS'+resource;
                    HttpRequest req = new HttpRequest();
                    req.setMethod(this.methodName);
                    req.setEndpoint(fileUrl);
                    req.setHeader('Host', this.bucketName + '.' + this.hostName);
                    //req.setHeader('Content-Length', String.valueOf(attachmentBody.length()));
                    req.setHeader('Content-Encoding', 'UTF-8');
                    req.setHeader('Content-type', contentType);
                    req.setHeader('Connection', 'keep-alive');
                    req.setHeader('Date', formattedDateString);
                    req.setHeader('ACL', 'public-read');
                    //Blob pdfBlob = EncodingUtil.base64Decode(attachmentBody);
                    req.setBodyAsBlob(attach.VersionData);
                    
                    //req.setHeader('Authorization',CreateAuthHeader(contentType, filename, formattedDateString,attach.FileExtension));
                    
                    Http http = new Http();
                    HTTPResponse res = http.send(req);
                    if (res.getStatusCode() == 200 || res.getStatusCode()==201){
                        String Ur = 'https://'+this.hostName+resource;
                        Delivery_Object__c del = new Delivery_object__c(Id=DeliveryId,Aws_Url__c=Ur);
                        ContentDocument docu = new ContentDocument(Id=attach.ContentDocumentId);
                        delete docu;
                        update del;
                    }
                }catch(Exception ex){
                    System.debug(ex);
                }
            }
        }
    }

    public class WrappedResponse {
        @AuraEnabled
        public List<maps__Route__c> routes;
        @AuraEnabled
        public List<Maps__Waypoint__c> allWaypoints;
        @AuraEnabled
        public String driverName;
        @AuraEnabled
        public List<Map<String, String>> picklist_values{get;set;}
        @AuraEnabled
        public Boolean success{get;set;}
        @AuraEnabled
        public String message{get;set;}
    }
}