@isTest
global class MapsDeliveryDriverControllerMockTest implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setStatusCode(200);
        return response; 
    }
}