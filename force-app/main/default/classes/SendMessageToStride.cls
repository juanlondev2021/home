public class SendMessageToStride {
    public static void test() {}
    /*
    @future(callout=true)
	public static void StrideMessage(String room, String text) {
        //SendMessageToStride.StrideCallout(room, text);
    }
    
    
  	public static HttpResponse StrideCallout(String room, String message) {
        
        settings_page__c CS = Database.query('SELECT Id, Site_id__c, Chat_id__c, Chat_App_Token__c FROM settings_page__c WHERE Name = :room LIMIT 1');
        
        String endpoint = 'https://api.atlassian.com/site/' + CS.Site_id__c + '/conversation/' + CS.Chat_id__c + '/message';
        String body = '{'+
                         '"version":1,'+
                         '"type":"doc",'+
                         '"content":[{'+
                           '"type":"paragraph",'+
                           '"content":[{'+
                               '"type":"mention",'+
                               '"attrs":{'+
                                  ' "id":"all",'+
                                   '"text":"@all",'+
                                   '"accessLevel":"CONTAINER",'+
                                  ' "userType":"SPECIAL"'+
                               '}'+
                            '},'+
                            '{'+
                                '"type": "text",'+
                                '"text": "'+ message+'"'+
                            '}'	+
                           ' ]'+
                          '}]'+
                        '}' ;        
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setHeader('Authorization', 'Bearer ' + CS.Chat_App_Token__c);
        request.setHeader('Content-Type', 'application/json');
        request.setBody(body);
        HttpResponse response = http.send(request);
        // Parse the JSON response
        if (response.getStatusCode() != 201) {
            System.debug('The status code returned was not expected: ' +
                response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug('response.body : '+response.getBody());
            System.debug('request HEader : '+request.getHeader('Authorization'));
            System.debug('request Body : '+request.getBody());
           	System.debug ('EndPoint : '+request.getEndpoint());
            
        }
        return response;
    }*/
}