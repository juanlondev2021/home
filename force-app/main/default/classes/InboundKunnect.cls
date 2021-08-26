/**
 * Diaco
 * @author             Esnayder Morales
 * Project:            kunnect Inbound, syncKunnectToSalesforce
 * TestClass:          InboundKunnectTest
 * Description:        JOB to POST Homse Service Server, Inser User Address Kunnect DB
 *
 * Changes (Version)
 * _________________________________________
 *            No.        Date            Author                    Description
 *            ____    __________        __________________      _____________________________________
 * @version    1.0    08/04/2021         Esnayder Morales         Initial implementation of the class.
 **/
public class InboundKunnect {
	
    public static void execute(){
        Actions();
    }
    
    @future(callout=true)
    private static void Actions() {
        String endpoint = 'https://salesforcewebsiteapi.herokuapp.com/api/v1.0/inbound/KunnectSF';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('origin', 'https://myhomeservices--preprod.cs42.my.salesforce.com');
        
        HttpResponse response = http.send(request);
        // Parse the JSON response
        if (response.getStatusCode() != 200) {
            diacoKnifeFunc.sendEmail(new List<String>{'emorales@diaco.us'}, 
                                     'Error Inbound syncKunnectToSalesforce', 
                                     response.getStatusCode() + '\n ' + response.getStatus() +'\n '+response.getBody()
                                    );
            System.debug('The status code returned was not expected: ' +
                         response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug('response.body : '+response.getBody());
            
        } 
    }
    
}