@isTest
global class DiacoFtpJobHttpCallOutMock implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse response = new HttpResponse();
        String body = '';
        if(req.getEndpoint() =='http://ec2-13-56-143-167.us-west-1.compute.amazonaws.com:3000/api/v1.0/ftp'){
             body = '{"response": "Succefully"}'; 
        }else if(req.getEndpoint() =='http://ec2-13-56-143-167.us-west-1.compute.amazonaws.com:3000/api/v1.0/save-aws'){
            body = '{"response": "Succefully"}'; 
       }
        response.setHeader('Content-Type', 'text/plain');
        response.setBody(body);
        response.setHeader('origin', 'https://myhomeservices--preprod.cs42.my.salesforce.com');
        response.setStatusCode(200);
        return response;
    }

}