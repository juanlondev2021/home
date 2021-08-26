/**************************************************************************************************************
                    Created By: MST
                    Description : This class will send DocuSign envelope to emails
***************************************************************************************************************/
public class AuthCallout {

 //Docusign credentials are fetched from custom settings.
 
 Map<String,DocusignCredentials__c> documap = DocusignCredentials__c.getall();
 String accountID = documap.get('DousignCredential1').AccountId__c;
 String UserName = documap.get('DousignCredential1').UserName__c;
 String Password = documap.get('DousignCredential1').Password__c;
 String IntegratorKey = documap.get('DousignCredential1').IntegratorKey__c;
 String TemplateID = documap.get('DousignCredential1').TemplateID__c;
 String useremail = UserInfo.getUserEmail();
 public string endpoint = 'https://www.docusign.net/restapi/v2/accounts/'+accountID+'/envelopes';
 
 //List of contacts will be received from vf page and it is processed in this method.
 
   public String basicAuthCallout(List<Contact> contactEmailList){
   list<dsfs__DocuSign_Status__c> liststatus = new list<dsfs__DocuSign_Status__c>();
   Map<String,dsfs__DocuSign_Status__c> docusignMap = new Map<String,dsfs__DocuSign_Status__c>();
   
     for(Contact li:contactEmailList){
     
     HttpRequest req = new HttpRequest();
     req.setEndpoint(endpoint);
     req.setMethod('POST');
//<SendOnBehalfOf>'+useremail+'</SendOnBehalfOf>
     String authorizationHeader = '<DocuSignCredentials><SendOnBehalfOf>'+useremail+'</SendOnBehalfOf><Username>'+UserName+'</Username><Password>'+Password+'</Password><IntegratorKey>'+IntegratorKey+'</IntegratorKey></DocuSignCredentials>';
     req.setHeader('X-DocuSign-Authentication', authorizationHeader);
     req.setHeader('Accept','application/json');
     req.setHeader('Host','demo.docusign.net');
     req.setHeader('Content-Length','162100');
     req.setHeader('Content-Type','application/json');
     req.setHeader('Content-Disposition','form-data');
     system.debug('Header Debug'+authorizationHeader);
     //Docusign Request payload with recipient informations and the account is to be merged in the docusign document.
     
        String json=        '{'+
        ' '+
        ' "emailSubject": "NuHome Payment Authorization Form",'+
        ' "emailBlurb": "NuHome Promotions is sending you this request for your electronic signature and enter or update confidential payment information.\n\nPlease review and electronically sign by following the link below. ",'+
        ' "templateId": "'+TemplateID+'",'+
        ' "envelopeIdStamping": "false",'+
        ' "customFields":{'+
        '    "textCustomFields":['+
        '      {'+
        '        "name":"##SFAccount",'+
        '        "required":"true",'+
        '        "show":"false",'+
        '        "value":"'+li.accountid+'"'+
        '      }'+
        '    ]'+
        '  },'+
        ' "templateRoles": ['+
        '  {'+
        '     "roleName": "Signer 1",'+
        '     "name": "'+li.name+'",'+
        '     "email": "'+li.email+'",'+
        '     "recipientId": "1"'+
        '   }'+
        ' ],'+
        ' "status": "sent"'+
        '}';
    
     req.setBody(json);

     Http http = new Http();
     HTTPResponse res;
      
         //Callout to docusign
         try{
         res = http.send(req);
         system.debug('Response debug'+res);
         }
         catch(Exception e){
             return e+'';
         }
         //Parsing the response
         JSON2Apex obj = JSON2Apex.parse(res.getBody());
         if(obj.status=='sent'){
         //Inserting envelopid in docusign status object
         dsfs__DocuSign_Status__c dsfs= NEW dsfs__DocuSign_Status__c();
         dsfs.dsfs__DocuSign_Envelope_ID__c = String.valueof(obj.envelopeId);
         dsfs.dsfs__Company__c = li.accountid;
         liststatus.add(dsfs);
         }else{
            return res.getBody();
         }
    
     
    }
    if(liststatus.size() > 0)
      insert liststatus;
     
   return 'sent';
   }
}