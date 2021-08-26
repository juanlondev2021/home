/***********************************************************************************************
* Class Name : MockAddressValidationResponseGenerator
* Created By : Priyanka S
* Created Date : 4/20/2016
* Description : This class is used to cover the code of AddressValidationController. It is used to send the static fake response to the corresponding class.
**********************************************************************************************/
@isTest
global class MockAddressValidationResponseGenerator implements HttpCalloutMock{
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint and method.
        System.assertEquals('https://address-verification.nuhome.com/v1/address/verify', req.getEndpoint());
        System.assertEquals('POST', req.getMethod());        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');  
        // Parse JSON response to get all the field values.
        JSONParser parser = JSON.createParser(req.getBody());
        while (parser.nextToken() != null) {
            //if current token is a field name
            if (parser.getCurrentToken() == JSONToken.FIELD_NAME){
                String fieldName = parser.getText();
                System.debug('fieldName: ' + fieldName);
                //move to token after the field name
                parser.nextToken(); 
                if(fieldName == 'Line2'){
                    //If the given street is blank then send response as badrequest
                    if(parser.getText() == null || parser.getText() == '' ){
                        res.setBody('');
                        res.setStatusCode(400);
                    }
                    //If the given street is invalid then send response as Address not Found
                    else if(parser.getText() == 'Test'){
                        res.setBody('{"Number":"-2147219401","Source":"clsAMS","Description":"Address Not Found.  ","HelpFile":"","HelpContext":""}');
                        res.setStatusCode(200);
                    }
                    else {//Send the response with correct Address
                        res.setBody('{"Line1":"2027 E University Dr Unit 107","Line2":"2027 E University Dr Unit 107","City":"Tempe","State":"AZ","Zip5":"85281","Zip4":"8526"}');
                        res.setStatusCode(200);
                    }                    
                }                
            }
        }  
        return res;
    }   
}