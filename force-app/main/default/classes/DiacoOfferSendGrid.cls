public class DiacoOfferSendGrid {
	@InvocableMethod(label='Send Offers Email' description='Send Offers Email.')
    public static void SendEmail(List<String> param) {
        List<Account> Acc = [Select Id, PersonEmail
                       from Account where Id IN :param];
        List<String> emails = new List<String>();
        if(Acc.size()>0){
            for(Account ac : Acc){
                emails.add(ac.PersonEmail);
            }
            if(!System.isFuture() && 
               !System.isBatch() ){
            sendEmail(body(emails));
            }
        }
        
    }
    
    @future(callout=true)
    public static void sendEmail(String body){
        System.debug(body);
        sendEmails(body);
    }
    
    public static HttpResponse sendEmails(String body){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://api.sendgrid.com/v3/mail/send');
        request.setMethod('POST');
        request.setHeader('authorization', apikeySendgrid());
        request.setHeader('Content-Type', 'application/json');
        request.setBody(body);
        System.debug(request.getBody());
        HttpResponse response = http.send(request);
        // Parse the JSON response
        if (response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                         response.getStatusCode() + ' ' + response.getStatus());
            
        } else {
            System.debug('response.body : '+response.getBody());
        } 
        
        return response;
        
    }
    
    public static String apikeySendgrid(){
        Send_Grid__c config = [select Api_Key__c 
                               from Send_Grid__c];
        return config.Api_Key__c;
    }
    
    public static String body(List<String> emails){
        String body = '', bodyEmail='';
        body = '{"personalizations": [{'+
            '"to": [';
        for(String text : emails){
            bodyEmail+='{"email":"'+text+'"},';
        }   
        body+= bodyEmail.removeEnd(',')+ ']}],"template_id": "d-77ff0f422bd646fda86d9d927ef40b95",'+
            '"subject": "Next Day",'+
            '"from": {"email": "welcome@nextdaydeliverycompany.com","name": "Next Day"}}';
        return body;
    }
}