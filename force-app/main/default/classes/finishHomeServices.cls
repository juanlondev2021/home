public class finishHomeServices {
    
    @future(callout=true)
    public static void saveContactSendgrid(String email, String firstName, String lastName, String id_account, String id_HS){
        String endpoint = 'https://salesforcewebsiteapi.herokuapp.com/api/contacts/send-grid';
        String body = '{'+
            '"Email":"'+email +'",'+
            '"lastName":"'+lastName+'",'+
            '"Id_Account":"'+id_account+'",'+
            '"Id_HS":"'+id_HS+'",'+
            '"firstName": "'+firstName+'"}';
        //System.debug(body);
        System.debug(body);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('origin', 'https://myhomeservices--preprod.cs42.my.salesforce.com');
        request.setBody(body);
        
        HttpResponse response = http.send(request);
        // Parse the JSON response
        if (response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                         response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug('response.body : '+response.getBody());
            
        }      
        System.debug('Here');
        System.debug('Good');
    }
    
    @future(callout=true)
    public static void sendEmail(String Id){
        String endpoint = 'https://salesforcewebsiteapi.herokuapp.com/api/campaing';
        String body = '{'+
            '"id":"'+Id+'"}';
        //System.debug(body);
        System.debug(body);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('origin', 'https://myhomeservices--preprod.cs42.my.salesforce.com');
        request.setBody(body);
        HttpResponse response = http.send(request);
        // Parse the JSON response
        if (response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                         response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug('response.body : '+response.getBody());
        }        
        System.debug('Good');
    }
}