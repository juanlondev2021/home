/*

 Diaco
 @author 			Esnayder Morales Corpas href=<esnaydermorales25@gmail.com>
 Project:			diacoSendGridSincronize
 Description:		class reponsible to simulate response
     
 Changes (Version)
 _________________________________________

   No.		Date			Author					Description
   ____	__________      __________________      _____________________________________
@version	1.0		05/10/2019		Esnayder Morales (ES)	Initial implementation  of the class.
*/
@isTest
global class diacoSendGridSincronizeHttpCallOutMock implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse response = new HttpResponse();
        String body = '{'+
    			'"job_id": "b11e718f-e95c-4a92-8b44-2ec14fe92f68"'+
            '}';
        response.setHeader('Content-Type', 'text/plain');
        response.setBody(body);
        //response.setHeader('origin', 'https://myhomeservices--preprod.cs42.my.salesforce.com');
        response.setStatusCode(200);
        return response;
    }

}