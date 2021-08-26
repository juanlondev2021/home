/**
* Diaco
* @author 			Jorge Martinez href=<jorgeality29@gmail.com>
* Project:			SalesRabbit Integration
* Description:		Class responsible for serving to give fake responses
*
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		04/09/2018		Jorge Martinez (JM)		Initial implementation of the class.
**/
@isTest
global class DiacoSalesRabbitIntegrationCalloutMock implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        String body = '';
        if(req.getMethod() == 'GET'){
           body = '{"data":[{'+
                	'"id":85,"userName":"Cody Garrett","userId":911705138,"firstName":"test jorge",'+
                	'"lastName":"test martinez","phonePrimary":"","phoneAlternate":"","email":"te111@s.com",'+
                	'"street1":"street2 test","street2":"","city":"city2 test","state":"AK","zip":"66666",'+
                	'"country":"USA","latitude":64.2008413,"longitude":-149.4936733,"status":"Other",'+
                	'"notes":"take anothe appointment","customFields":{"salesForceId":"a30V0000001Mp2vIAC",'+
                	'"confirmationNumber":"15206869"},"businessName":"","appointment":"2018-09-04T15:23:46+00:00",'+
                	'"statusModified":"2018-09-04T15:33:48+00:00","dateCreated":"2018-09-04T15:23:46+00:00",'+
                	'"dateModified":"2018-09-04T15:34:02+00:00"}],"meta":{"resultsPerPage":10000,"morePages":false,"currentPage":1}}';
            res.setStatusCode(200);
        }else if(req.getMethod() == 'POST'){
            body  ='{"data":{"id":85,"userName":"Cody Garrett","userId":911705138,"firstName":"test jorge",'+
                	'"lastName":"test martinez","phonePrimary":"","phoneAlternate":"","email":"te111@s.com",'+
                	'"street1":"street2 test","street2":"","city":"city2 test","state":"AK","zip":"66666",'+
                	'"country":"USA","latitude":null,"longitude":null,"status":"New Lead","notes":null,'+
                	'"customFields":{"salesForceId":"a30V0000001Mp3PIAS","confirmationNumber":"15206870"},'+
                	'"businessName":"","appointment":"2018-09-04T16:09:26+00:00","statusModified":"2018-09-04T16:09:26+00:00",'+
                	'"dateCreated":"2018-09-04T16:09:26+00:00","dateModified":"2018-09-04T16:09:26+00:00"}}';
            res.setStatusCode(201);
        }
        res.setBody(body);
        System.debug('body : '+res.getBody());
        return res;
    }
}