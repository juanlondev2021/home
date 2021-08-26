@isTest
global class diacoSendSweepstakeHttpCallOutMock implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse response = new HttpResponse();
        String body = '';
        if(req.getEndpoint() =='https://salesforcewebsiteapi.herokuapp.com/sendgrid/api/sweepstake' ||
           req.getEndpoint() == 'https://salesforcewebsiteapi.herokuapp.com/sendgrid/api/sweepstake-one'
          || req.getEndpoint() == 'https://salesforcewebsiteapi.herokuapp.com/sendgrid/api/sweepstake-sms'){
             body = '{"response": "Succefully"}'; 
        }else if(req.getEndpoint() == 'https://api.neverbounce.com/v4/single/check?key=Apikey******&email=test@test.com'){
            
            body = '{'+
                '"status": "success",'+
                '"result": "valid",'+
                '"flags": ['+
                '"has_dns",'+
                '"has_dns_mx"'+
                '],'+
                '"suggested_correction": "",'+
                '"execution_time": 499'+
                '}';
        }
        
        System.debug('endpoint : '+req.getEndpoint());
        response.setHeader('Content-Type', 'text/plain');
        response.setBody(body);
        response.setHeader('origin', 'https://myhomeservices--preprod.cs42.my.salesforce.com');
        response.setStatusCode(200);
        return response;
    }

}