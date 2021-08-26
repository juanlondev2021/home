/**************************************************************************************************************
Created By:MST Solutions.
Description : This is the class for to interact with the case object using REST API webservice method.
***************************************************************************************************************/

Public Class nuHome_Case_API{
    
    //This method is to fetch the case list which is created by current user and the current user owned cases.
    Public static list<parsecase.cls_records> getCasemethod(){
     //Authentication to get access token
     //String endpoint = 'https://test.salesforce.com/services/oauth2/token?grant_type=password&client_id=3MVG9ahGHqp.k2_yG2Bb4YaxVXDFPnWCk8Kwr5Pz_.LV8P_OBKmITEVDb7MOCO7Dhqzn3bzmBR.yUQV9tiZFR&client_secret=7589080793434905588&username=venkatesh@nuhome.com.fullsb&password=mstnuhome1';
     String endpoint = 'https://login.salesforce.com/services/oauth2/token?grant_type=password&client_id=3MVG9fMtCkV6eLheWHriTClrETen51Nr5CfeI5G.Xo1N._x36vNeZoYE02BDWmaLBL7Y6aDfnGjKhVg4nSoyz&client_secret=281146588281601248&username=venkatesh@nuhome.com&password=mstnuhome1';
     HttpRequest req = new HttpRequest();
     req.setEndpoint(endpoint);
     req.setMethod('POST');
     Http http = new Http();
     string responseBody = '';
     HTTPResponse res;
     if(test.isRunningTest())
         responseBody = '{"access_token":"00D7A0000008pf5!AQkAQC.up57t_w.gDwGNRSwboiQwOhN2Z5.eZD76m2X.FflRtR9Z68l5fwyirIJakt3f3xfg0Ihv7RfpQtcLmxlLrEUGfXre","instance_url":"https://nuhome--MST.cs44.my.salesforce.com","id":"https://test.salesforce.com/id/00D7A0000008pf5UAA/0057A000000YcX2QAK","token_type":"Bearer","issued_at":"1452752215566","signature":"OHVQtYjJCEw3jE9e2xkldch1BaVPrcFxo1G9CsC/WQo="}';
     else
         responseBody = http.send(req).getBody();
     //Passing the response to wrapper class to get the access token.
     nuHome_Case_Response response = nuHome_Case_Response.parse(responseBody);
     id ownerID = userinfo.getuserid();
     String Query = 'SELECT+Id,+IsDeleted,+CaseNumber,+ContactId,+AccountId,+EntitlementId,+RecordTypeId,+Type,+Reason,+Status,+Origin,+Subject,+Description,+Priority,+IsClosed,+ClosedDate,+OwnerId,+SlaStartDate,+SlaExitDate,+CreatedDate,+CreatedById,+MilestoneStatus,+Sub_Type__c+FROM+Case+WHERE+(ownerid+=+\''+ownerID+'\'+AND+status!=\'closed\')+OR+Created_By__c+=+\''+ownerID+'\'';
     //Fetching the list of cases.
     String endpoint2 = response.instance_url+'/services/data/v20.0/query/?q='+Query;
     HttpRequest req2 = new HttpRequest();
     req2.setEndpoint(endpoint2);
     req2.setMethod('GET');
     req2.setHeader('Accept', 'application/json');
     req2.setHeader('Authorization','Bearer '+response.access_token);

     Http http2 = new Http();
     HTTPResponse res2 ;
     string responseBody2 = '';
     if(test.isRunningTest())
         responseBody2 = '{"totalSize":1,"done":true,"records":[{"attributes":{"type":"Case","url":"/services/data/v20.0/sobjects/Case/5007A00000194emQAA"},"Id":"5007A00000194emQAA","IsDeleted":false,"CaseNumber":"00001183","ContactId":null,"vf_owner__c":"Chris Edelen","Contact_Name__c":null,"AccountId":null,"Account_Name__c":null,"EntitlementId":"5507A0000004CidQAE","RecordTypeId":"0127A000000084pQAA","Type":"Attorney General","Reason":"User didn&#39;t attend training","Status":"Escalated","Origin":"Web","Subject":null,"Description":"Test Description","Priority":"Medium","IsClosed":false,"ClosedDate":null,"OwnerId":"005j000000BX2ucAAD","SlaStartDate":"2016-01-12T12:52:28.000+0000","SlaExitDate":null,"CreatedDate":"2016-01-12T12:52:28.000+0000","CreatedById":"005j000000Ax79dAAB","MilestoneStatus":"Open Violation","Sub_Type__c":null}]}';
     else
         responseBody2 = http2.send(req2).getBody();
         
     parsecase parsedcase = parsecase.parse(responseBody2);
     return parsedcase.records;
  
    }
    
    //Method to create comment in case comment object.
    Public static String setCommentmethod(String getidcase, String casecommentString){
    //Authentication to get access token
     String endpoint = 'https://login.salesforce.com/services/oauth2/token?grant_type=password&client_id=3MVG9fMtCkV6eLheWHriTClrETen51Nr5CfeI5G.Xo1N._x36vNeZoYE02BDWmaLBL7Y6aDfnGjKhVg4nSoyz&client_secret=281146588281601248&username=venkatesh@nuhome.com&password=mstnuhome1';
     HttpRequest req = new HttpRequest();
     req.setEndpoint(endpoint);
     req.setMethod('POST');
     Http http = new Http();
     HTTPResponse res; 
     string responseBody = '';
     //Passing the response to wrapper class to get the access token.
     if(test.isRunningTest())
         responseBody = '{"access_token":"00D7A0000008pf5!AQkAQEYmd49AKjQpDwdru12hBUTCjcXySuRVaiZEAf7p4PWSFqnWZbAlPcJBM1IW.taK_dfUs6oanH78Bp.NTi0mNIXYBkmU","instance_url":"https://nuhome--MST.cs44.my.salesforce.com","id":"https://test.salesforce.com/id/00D7A0000008pf5UAA/0057A000000YcX2QAK","token_type":"Bearer","issued_at":"1452767177569","signature":"+1SBbup4NRwre5OKTmyjKgVGxAP5vbCWOSXsOvutoZc="}';
     else
         responseBody = http.send(req).getBody();
     nuHome_Case_Response response = nuHome_Case_Response.parse(responseBody);
     //Call to case object to create case comment.
     String endpoint2 = response.instance_url+'/services/data/v20.0/sobjects/Casecomment/';
     HttpRequest req2 = new HttpRequest();
     req2.setEndpoint(endpoint2);
     req2.setMethod('POST');
     req2.setHeader('Content-Type', 'application/json');
     req2.setHeader('Authorization','Bearer '+response.access_token);
        String json=        '{'+
        '"ParentId": "'+getidcase+'",'+
        '"CommentBody": "'+casecommentString+'"'+
        '}';
     req2.setBody(json);
     Http http2 = new Http();
     HTTPResponse res2 ;
     string response2Body = '';
     if(test.isRunningTest())
         response2Body = '{"id":"00a7A000000Ld4SQAS","success":true,"errors":[]}';
     else
         response2Body = http2.send(req2).getBody();
         
    return response2Body;

        
    }
    //Fetch the list of comments for the particular case id.
    Public static list<parseCasecomment.cls_records> getcommentlistmethod(String getidcase){
             //Authentication to get access token
             String endpoint = 'https://login.salesforce.com/services/oauth2/token?grant_type=password&client_id=3MVG9fMtCkV6eLheWHriTClrETen51Nr5CfeI5G.Xo1N._x36vNeZoYE02BDWmaLBL7Y6aDfnGjKhVg4nSoyz&client_secret=281146588281601248&username=venkatesh@nuhome.com&password=mstnuhome1';
             HttpRequest req = new HttpRequest();
             req.setEndpoint(endpoint);
             req.setMethod('POST');
             Http http = new Http();
             HTTPResponse res;
             string responseBody = '';
             if(test.isRunningTest())
                 responseBody = '{"access_token":"00D7A0000008pf5!AQkAQEYmd49AKjQpDwdru12hBUTCjcXySuRVaiZEAf7p4PWSFqnWZbAlPcJBM1IW.taK_dfUs6oanH78Bp.NTi0mNIXYBkmU","instance_url":"https://nuhome--MST.cs44.my.salesforce.com","id":"https://test.salesforce.com/id/00D7A0000008pf5UAA/0057A000000YcX2QAK","token_type":"Bearer","issued_at":"1452781168608","signature":"MgMKA6BoTG3/MV7GZiAoQ9NI8l0EfQjDwJhAfzmgAqU="}';
             else
                 responseBody = http.send(req).getBody();
            
             //Passing the response to wrapper class to get the access token.
             nuHome_Case_Response response = nuHome_Case_Response.parse(responseBody);
            
             //Fetching callout to Case Comment object.
             String Query = 'SELECT+id+,CommentBody+FROM+CaseComment+where+ParentId=\''+getidcase+'\'+AND+IsDeleted=false';
             String endpoint2 = response.instance_url+'/services/data/v20.0/query/?q='+Query;
             HttpRequest req2 = new HttpRequest();
             req2.setEndpoint(endpoint2);
             req2.setMethod('GET');
             req2.setHeader('Accept', 'application/json');
             req2.setHeader('Authorization','Bearer '+response.access_token);
        
             Http http2 = new Http();
             HTTPResponse res2; 
             string response2Body = '';
             if(test.isRunningTest())
                 response2Body = '{"totalSize":2,"done":true,"records":[{"attributes":{"type":"CaseComment","url":"/services/data/v20.0/sobjects/CaseComment/00a7A000000LctPQAS"},"Id":"00a7A000000LctPQAS","CommentBody":"Created By: Venkatesh Selvaraj (2016-01-12 18:57:05)   &#124;&#124; Updated By: Venkatesh Selvaraj (2016-01-13 12:53:10)  &#124;&#124;   Test"},{"attributes":{"type":"CaseComment","url":"/services/data/v20.0/sobjects/CaseComment/00a7A000000Ld4SQAS"},"Id":"00a7A000000Ld4SQAS","CommentBody":"Created By: Venkatesh Selvaraj (2016-01-14 10:26:16) &#124;&#124;"}]}';
             else
                 response2Body =  http2.send(req2).getBody();
             //Parsing the response by sending the response to the wrapper class.
             
             parseCasecomment parsedCasecomment = parseCasecomment.parse(response2Body);
             return parsedCasecomment.records;
    
    }
    //Method to delete the particular case record.
    Public static String commentDelete(String getidcase){
             //Authentication to get access token
             String endpoint = 'https://login.salesforce.com/services/oauth2/token?grant_type=password&client_id=3MVG9fMtCkV6eLheWHriTClrETen51Nr5CfeI5G.Xo1N._x36vNeZoYE02BDWmaLBL7Y6aDfnGjKhVg4nSoyz&client_secret=281146588281601248&username=venkatesh@nuhome.com&password=mstnuhome1';
             HttpRequest req = new HttpRequest();
             req.setEndpoint(endpoint);
             req.setMethod('POST');
             Http http = new Http();
             HTTPResponse res ;
             string responseBody = '';
             if(test.isRunningTest())
                 responseBody = '{"access_token":"00D7A0000008pf5!AQkAQEYmd49AKjQpDwdru12hBUTCjcXySuRVaiZEAf7p4PWSFqnWZbAlPcJBM1IW.taK_dfUs6oanH78Bp.NTi0mNIXYBkmU","instance_url":"https://nuhome--MST.cs44.my.salesforce.com","id":"https://test.salesforce.com/id/00D7A0000008pf5UAA/0057A000000YcX2QAK","token_type":"Bearer","issued_at":"1452778039247","signature":"T/OAu5gdw7KvCwHQPBomoDd1ZoOwEnDYR1MwzBTyM6s="}';
             else 
                 responseBody = http.send(req).getBody();
             
             system.debug('### del --- '+responseBody);
             //Passing the response to wrapper class to get the access token.
             nuHome_Case_Response response = nuHome_Case_Response.parse(responseBody);
            
             //Delete callout to case comment object.
             String endpoint2 = response.instance_url+'/services/data/v20.0/sobjects/Casecomment/'+getidcase;
             HttpRequest req2 = new HttpRequest();
             req2.setEndpoint(endpoint2);
             req2.setMethod('DELETE');
             req2.setHeader('Accept', 'application/json');
             req2.setHeader('Authorization','Bearer '+response.access_token);
        
             Http http2 = new Http();
             HTTPResponse res2;
             string response2Body = '';
             if(Test.IsRunningTest())
                 response2Body = '';
             else
                 response2Body  = http2.send(req2).getBody();

            system.debug('---Response 2 Body----' + response2Body);
             return response2Body;
    
    }
    
        Public static String commentPatch(String getidcase,String Comments){

             //Authentication to get access token
             String endpoint = 'https://login.salesforce.com/services/oauth2/token?grant_type=password&client_id=3MVG9fMtCkV6eLheWHriTClrETen51Nr5CfeI5G.Xo1N._x36vNeZoYE02BDWmaLBL7Y6aDfnGjKhVg4nSoyz&client_secret=281146588281601248&username=venkatesh@nuhome.com&password=mstnuhome1';
             HttpRequest req = new HttpRequest();
             req.setEndpoint(endpoint);
             req.setMethod('POST');
             Http http = new Http();
             HTTPResponse res ;
             String responseBody = ''; 
             //Passing the response to wrapper class to get the access token.
             if(test.isRunningtest())
             responseBody = '{"access_token":"00D7A0000008pf5!AQkAQEYmd49AKjQpDwdru12hBUTCjcXySuRVaiZEAf7p4PWSFqnWZbAlPcJBM1IW.taK_dfUs6oanH78Bp.NTi0mNIXYBkmU","instance_url":"https://nuhome--MST.cs44.my.salesforce.com","id":"https://test.salesforce.com/id/00D7A0000008pf5UAA/0057A000000YcX2QAK","token_type":"Bearer","issued_at":"1452777377823","signature":"+XMUZa4yy8N2AdnfIHxpgpx7Gf8p+IeJNKGdDSXEa2s="}';
             else
             responseBody = http.send(req).getBody();
             
             system.debug('------------Response 1 ----- ' + responseBody);
             nuHome_Case_Response response = nuHome_Case_Response.parse(responseBody);        
            
             //Update callout to case comment object.
             String endpoint2 = response.instance_url+'/services/data/v20.0/sobjects/Casecomment/'+getidcase+'?_HttpMethod=PATCH';
             HttpRequest req2 = new HttpRequest();
             req2.setEndpoint(endpoint2);
             req2.setMethod('POST');
             req2.setHeader('Content-Type', 'application/json');
             req2.setHeader('Authorization','Bearer '+response.access_token);
             String json=       '{'+
        '"CommentBody": "'+Comments+'"'+
        '}';
             req2.setBody(json);
             Http http2 = new Http();
             HTTPResponse res2 ;
             String response2Body = '';
              if(test.isRunningTest())
                response2Body = '';
              else  
                response2Body = http2.send(req2).getBody();
                
             system.debug('------------Response 2 ----- ' + response2Body);
             return response2Body;
    
    }
    Public static String casePatch(String id){
             //Authentication to get access token
             String endpoint = 'https://login.salesforce.com/services/oauth2/token?grant_type=password&client_id=3MVG9fMtCkV6eLheWHriTClrETen51Nr5CfeI5G.Xo1N._x36vNeZoYE02BDWmaLBL7Y6aDfnGjKhVg4nSoyz&client_secret=281146588281601248&username=venkatesh@nuhome.com&password=mstnuhome1';
             HttpRequest req = new HttpRequest();
             req.setEndpoint(endpoint);
             req.setMethod('POST');
             Http http = new Http();
             HTTPResponse res = http.send(req);
             system.debug('############# res body'+ res.getBody());

             //Passing the response to wrapper class to get the access token.
             nuHome_Case_Response response = nuHome_Case_Response.parse(res.getBody());        
            
             //Case edit callout
             String endpoint2 = response.instance_url+'/services/data/v20.0/sobjects/Case/'+id+'?_HttpMethod=PATCH';
             HttpRequest req2 = new HttpRequest();
             req2.setEndpoint(endpoint2);
             req2.setMethod('POST');
             req2.setHeader('Content-Type', 'application/json');
             req2.setHeader('Authorization','Bearer '+response.access_token);
             String json=   '';    
             req2.setBody(json);
             Http http2 = new Http();
             HTTPResponse res2 = http2.send(req2);
             system.debug('############# res2 body '+ res2.getBody());
             return req2.getbody();
    
    }

    

}