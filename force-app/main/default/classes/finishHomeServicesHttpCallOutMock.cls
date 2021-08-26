@isTest
global class finishHomeServicesHttpCallOutMock implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse response = new HttpResponse();
        String body = '';
        if(req.getEndpoint() =='https://salesforcewebsiteapi.herokuapp.com/api/contacts/send-grid'){
             body = '{"response": "Succefully"}'; 
        }else if(req.getEndpoint() =='https://salesforcewebsiteapi.herokuapp.com/api/campaing'){
             body = '{"response": "Succefully"}'; 
        }
        
        System.debug('endpoint : '+req.getEndpoint());
        response.setHeader('Content-Type', 'text/plain');
        response.setBody(body);
        //response.setHeader('origin', 'https://myhomeservices--preprod.cs42.my.salesforce.com');
        response.setStatusCode(200);
        return response;
    }

}