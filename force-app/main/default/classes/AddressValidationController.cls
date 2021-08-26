/********************************************************************************************
* Class Name : AddressValidationController
* Created By : Sankar Marappan
* Created Date : 29/03/2016
* Author : MST
* Description: Used to validate the given address by USPS when new address created and as well updating the existing address.
**********************************************************************************************/
public class AddressValidationController {
    
    public Address__c address {get;set;}
    public AddressWrapper responseAddressWrap {get;set;}
    private AddressWrapper requestAddressWrap,responseAddressWrapper;
    private String request;
    public Boolean isConfirm {get;set;}
    
    public AddressValidationController(ApexPages.StandardController stdCon){
        //Used to get the current record info
        this.address = (Address__c)stdCon.getRecord();
        isConfirm = false;
        //Get the Address record, when users clicks edit button on the Address.
        if(address.Id != null){
            this.address = [SELECT Id,Street__c,City__c,State__c,Zip_Code__c,Home_Type__c,Country__c,County__c,Data_Provider__c FROM Address__c WHERE Id =: address.Id];
        }
    }
    public pageReference Validate(){
        isConfirm = true;
        requestAddressWrap = new AddressWrapper();
        responseAddressWrapper = new AddressWrapper();
        //Construct request payload
        requestAddressWrap.Line1 = '';
        requestAddressWrap.Line2 = (String)(address.Street__c != null ? address.Street__c :'');
        requestAddressWrap.City = (String)(address.City__c != null ? address.City__c : '');
        requestAddressWrap.State = (String)(address.State__c != null ? address.State__c : '');
        requestAddressWrap.Zip5 = (String)(address.Zip_Code__c != null ? address.Zip_Code__c : '');
        //Generate payload as json
        request = requestAddressWrap.createJson(requestAddressWrap);
        System.Debug('Request Payload+++++'+request); 
        // Instantiate a new http object
        Http http = new Http();
        // Instantiate a new HTTP request, specify the method (POST) as well as the endpoint
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://address-verification.nuhome.com/v1/address/verify');
        req.setMethod('POST');
        req.setHeader('Accept', 'application/Json');
        req.setBody(request);
        //req.setCompressed(true); // otherwise we hit a limit of 32000
        try {        
    		// Send the request, and return a response
            HttpResponse res = http.send(req);
            System.debug('Response Payload ============>'+res.getBody());
            if(res.getStatuscode() == 200){               
                // Parse JSON response to get all the field values.
                JSONParser parser = JSON.createParser(res.getBody());
                while (parser.nextToken() != null) {
                    if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                        (parser.getText() == 'Description')) {
                            isConfirm = false;
                            // Get the value of the description.
                            parser.nextToken();
                            system.debug('Description: ' + parser.getText());
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,parser.getText()));
                            return null;
                        }
                }
                responseAddressWrap = responseAddressWrapper.parse(res.getBody());
                System.debug('ResponseAddressWrap: '+responseAddressWrap.parse(res.getBody()));
            }
            else if(res.getStatuscode() == 400){
                isConfirm = false;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Address Not Found'));
            }
        } catch(System.CalloutException e) {
            System.debug('Callout error: '+ e);
        }        
        return null;
    }
    public pageReference save(){
        //Assign values from responseAddressWrapper class
        this.address.Street__c = responseAddressWrap.Line1 != '' ? responseAddressWrap.Line1 : responseAddressWrap.Line2 != ''?responseAddressWrap.Line2:'';
        this.address.City__c = responseAddressWrap.City;
        this.address.State__c = responseAddressWrap.State;
        this.address.Zip_Code__c = responseAddressWrap.Zip5;
        this.address.Zip_Plus_Four__c = responseAddressWrap.Zip4;
        
        if(this.address != null){
            try{
                upsert address;
            }
            catch(Exception e){
                ApexPages.addMessages(e);
                System.debug(e.getMessage());
                return null;
            }
        }
        pageReference pageRef = new pageReference('/'+address.id);
        pageRef.setRedirect(true);
        return pageRef;
    }
    public pageReference confirmCancel(){        
        if(this.address.id == null){
            this.address = new Address__c();
            isconfirm = false;
        }
        else{
            isconfirm = false;
        }
        return null;
    }
    public class AddressWrapper{
        public String Line1 {get;set;}  //2027 E University Dr Unit 107
        public String Line2 {get;set;}  //
        public String City {get;set;}   //Tempe
        public String State {get;set;}  //AZ
        public String Zip5 {get;set;}
        public String Zip4 {get;set;}   //85281
        public AddressWrapper parse(String json){ 
            return (AddressWrapper)System.JSON.deserialize(json, AddressWrapper.class);
        }
        public String createJson(AddressWrapper addressWrapper){            
            return (String) System.JSON.serialize(addressWrapper);
        }  
    }
}