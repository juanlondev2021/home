/**
* Diaco
* @author 			Jorge Martinez href=<jorgeality29@gmail.com>
* Project:			Docusign Integration
* Description:		Class responsible to do the requests to docusign web service.
*
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		31/10/2018		Jorge Martinez (JM)		Initial implementation of the class.
**/
public class diacoDocusignApiRestIntegration {
    public docuSignConf__c conf{get;set;}
    List<docuSignConf__c> docusignconf{get;set;}
    
    /*constructor */
    public diacoDocusignApiRestIntegration(){
        conf = new docuSignConf__c();
        docusignconf = [select Id, tokenPart1__c, tokenPart2__c, tokenPart3__c, account__c 
                                              from docuSignConf__c];
        conf = docusignconf[0]; 
    }
    
    
    /**
     *
     * Method responsible of generating a token for every request.
     *
     * @return reponse, this response contain a access token to make resquest, a token type and the token refresh to get a new access token.
     *
     */
    public  HttpResponse generatorToken() {
        String endpoint = 'https://account.docusign.com/oauth/token';
        string key = 'MjA4NmZiYTUtZDlmNC00NmU5LTgzYzgtMDk3Nzg0ZjA5NzQ0OjMwYjcyM2FhLTlmZWUtNDYwNC05ZTUwLWRiYTI2YjVmMzMxMQ==';
        String body = 'grant_type=refresh_token&refresh_token='+refreshToken();
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setHeader('Authorization','Basic ' + key);
        request.setBody(body);
        HttpResponse response = http.send(request);
        
        if (response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                         response.getStatusCode() + ' ' + response.getStatus()+' token');
        } else {
            System.debug('response.body token : '+response.getBody() );
        }
        return response;
    }
    
    /**
     *
     * Method responsible of returning a refresh token saved in this org.
     *
     * @return refresh token, this refresh token returned in this function is used to get a new access token.
     *
     */
    public String refreshToken(){
        return conf.tokenPart1__c + conf.tokenPart2__c + conf.tokenPart3__c;
    }
    
    /**
     *
     * Method responsible of saving a  new refresh token generate in every access token generation.
     * we take the refresh token in 3 parts to save it in the custom setting named docuSignConf__c.
     * 
     *
     */
    public void getRefreshToken(string token){
        string token1 = '';
        string token2 = '';
        string token3 = '';
        string tokentotal = '';
        for(Integer i = 0; i < 255; i++){
            token1 = token1 + token.substring(i, i + 1);
        }
        for(Integer i = 255; i < 510; i++){
            token2 = token2 + token.substring(i, i + 1);
        }
        for(Integer i = 510; i < token.length() ; i++){
            token3 = token3 + token.substring(i, i + 1);
        }
        tokentotal = token1+token2+token3;
        if(tokentotal == token ){
            System.debug('igual');
            conf.tokenPart1__c = token1;
            conf.tokenPart2__c = token2;
            conf.tokenPart3__c = token3;
        }
        upsert conf;
    }
    /**
     * this method is responsible of converting in a object the response received
     * of a made petition to docusign  to get  the access token and the refresh token
     * 
     **/
    public diacoTokenFromDocusign getResponseAsObject(HttpResponse response){
        diacoTokenFromDocusign tokens = (diacoTokenFromDocusign)JSON.deserialize(response.getBody(), diacoTokenFromDocusign.class);
        return tokens;
    }
    /**
     * this method is reponsible of getting the contract as pdf from docusign 
	 */
    public  HttpResponse gettingDocumentAsPDF(String envelopeId,String token) {
        String endpoint = 'https://na3.docusign.net/restapi/v2/accounts/'+conf.account__c+'/envelopes/'+envelopeId+'/documents/1';
        system.debug(endpoint);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        request.setHeader('Authorization', 'Bearer ' + token);
        HttpResponse response = http.send(request);
        if (response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                         response.getStatusCode() + ' ' + response.getStatus());
        } else {
            system.debug('this is the body');
            System.debug('response.body : '+response.getBody());
        }
        return response;
    }
    /**
     * method responsible of save the pdf document obtained from docusign as an Attachment in the home service
     */
    public Attachment saveContract(Home_Services__c home, HttpResponse response){
        ContractsController cc = new ContractsController();
        Account acct = [SELECT AcctFirstName__c, AcctLastName__c
                        from Account where id = :home.Account__c];       
        Blob retBlob = response.getBodyAsBlob();
        Attachment attachmentPDF = new Attachment();
        attachmentPdf.parentId = home.Id;
        attachmentPdf.name = acct.AcctFirstName__c+' '+ acct.AcctLastName__c+' - '+cc.products(home.RecordTypeId)+' contract -'+home.sendDate__c.month()+'/'+ home.sendDate__c.day()+'/'+ home.sendDate__c.year()+'.pdf';
        attachmentPdf.body = retBlob;
        return attachmentPDF;
    }
    
    /**
     * this method is reponsible of getting the envelopes statuses 
	 */
    public  HttpResponse gettingEnvelopesStatus(String envelopeId,String token) {
       
        String endpoint = 'https://na3.docusign.net/restapi/v2/accounts/'+conf.account__c+'/envelopes/'+envelopeId;
        system.debug(endpoint);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        request.setHeader('Authorization', 'Bearer ' + token);
        HttpResponse response = http.send(request);
        if (response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected here: ' +
                         response.getStatusCode() + ' ' + response.getStatus());
        } else {
            system.debug('this is the body 2');
            System.debug('response.body : '+response.getBody());
        }
        return response;
    }
    
    
    /**
     * this method is responsible of converting in a object the response received
     * of a made petition to docusign  to get  the envelope status.
     * 
     **/
    public diacoDocusignEnvelopes getEnvelopesAsObject(HttpResponse response){
        diacoDocusignEnvelopes envelopes = (diacoDocusignEnvelopes)JSON.deserialize(response.getBody(), diacoDocusignEnvelopes.class);
        return envelopes;
    }
}