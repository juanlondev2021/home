/*********************************************************
Creted By: MST
Description : Webservice class to void the docusign envelope.
**********************************************************/
global class nuHome_Docusign
{
    webservice static void voidMethod(String Docusignenvid)
    { 
        system.debug('#########envelope called');
        Map<String,DocusignCredentials__c> documap = DocusignCredentials__c.getall();
        String accountID = documap.get('DousignCredential1').AccountId__c;
        String UserName = documap.get('DousignCredential1').UserName__c;
        String Password = documap.get('DousignCredential1').Password__c;
        String IntegratorKey = documap.get('DousignCredential1').IntegratorKey__c;
        String TemplateID = documap.get('DousignCredential1').TemplateID__c;
        String useremail = UserInfo.getUserEmail();
        string endpoint = 'https://www.docusign.net/restapi/v2/accounts/'+accountID+'/envelopes';
        

        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint+'/'+Docusignenvid);
        req.setMethod('PUT');
        String authorizationHeader = '<DocuSignCredentials><Username>'+UserName+'</Username><Password>'+Password+'</Password><IntegratorKey>'+IntegratorKey+'</IntegratorKey></DocuSignCredentials>';
        req.setHeader('X-DocuSign-Authentication', authorizationHeader);
        req.setHeader('Accept','application/json');
        req.setHeader('Host','demo.docusign.net');
        req.setHeader('Content-Length','162100');
        req.setHeader('Content-Type','application/json');
        req.setHeader('Content-Disposition','form-data');
        system.debug('Header Debug'+authorizationHeader);
        //Docusign Request payload with recipient informations and the account is to be merged in the docusign document.
        
        String json=        '{'+
            '"status":"voided",'+
            '"voidedReason":"\n\nNuHome Agreement Cancelled."'+
            '}';
        
        req.setBody(json);
        
        Http http = new Http();
        HTTPResponse res;
                if(!test.isRunningTest()){
        res = http.send(req);
                        
        system.debug('Response debug'+res);
            }    
        
        
    }
}