@isTest
global class SettingHttpCalloutMock implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'text/plain');
        response.setBody('{"id": "32e2be66-7499-4188-83d5-757e3586fc20","timestamp": "2017-09-08T23:11:05Z 812195"}');
        response.setStatusCode(200);
        return response; 
    }

}