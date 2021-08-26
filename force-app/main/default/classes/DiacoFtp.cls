/*

Diaco
@author 			Esnayder Morales Corpas href=<esnaydermorales25@gmail.com>
Project:			DiacoFtp
Description:		class reponsible to sincronize call record with useraddress

Changes (Version)
_________________________________________

No.		Date			Author					Description
____	__________      __________________      _____________________________________
@version	1.0		09/05/2020		Esnayder Morales (ES)	Initial implementation  of the class.
*/
public class DiacoFtp {
    
    @future(callout=true)
    public static void execute()
    {
        String endpoint = 'http://ec2-13-56-143-167.us-west-1.compute.amazonaws.com:3000/api/v1.0/ftp';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('origin', 'https://myhomeservices--preprod.cs42.my.salesforce.com');
        
        HttpResponse response = http.send(request);
        // Parse the JSON response
        if (response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                         response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug('response.body : '+response.getBody());
            
        } 
    }


    @future(callout=true)
    public static void saveAllFilesAWS()
    {
        String endpoint = 'http://ec2-13-56-143-167.us-west-1.compute.amazonaws.com:3000/api/v1.0/save-aws';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('origin', 'https://myhomeservices--preprod.cs42.my.salesforce.com');
        
        HttpResponse response = http.send(request);
        // Parse the JSON response
        if (response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                         response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug('response.body : '+response.getBody());
            
        } 
    }

}