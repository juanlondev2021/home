@isTest
global class DiacoSendVacancyEmailsHttpCallOutMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse response = new HttpResponse();
        String body = '';
        if(req.getEndpoint() == 'https://api.sendgrid.com/v3/mail/send'){
            body = '{ HTTP/1.1 202}';
            //----/
        }else{
            body = '{ HTTP/1.1 202}';
        }
        // Create a fake response.
        // Set response values, and 
        System.debug('endpoint : '+req.getEndpoint());
        response.setHeader('Content-Type', 'text/plain');
        response.setBody(body);
        response.setStatusCode(200);
        return response;
    }
}