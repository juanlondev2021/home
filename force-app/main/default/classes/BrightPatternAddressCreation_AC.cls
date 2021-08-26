/*******************************************************************************************************************
Created by: MST
Description: Agent will create Person Account via Brightpattern popup page(Brightpatterncreatepoup).  At before going to create
person account and user address, it will search the address is already existing address or valid address, if it is 
already existing, then it will create new person account and user address(Associate with existing address). 
If Address is not exist, but if it valid, then it will create new person account, address and user address records.
If address is not valid then agent could not create Person Account.
****************************************************************************************************************/

Public Class BrightPatternAddressCreation_AC
{
    public String streetNumber{get;set;}
    public String streetName{get;set;}
    public String city{get;set;}
    public String State{get;set;}
    public String Country{get;set;}
    public String zipCode{get;set;}
    Public List<Address__c> addressList{get;set;}
    public AddressWrapper requestAddressWrap {get;set;}
    public AddressWrapper responseAddressWrap {get;set;}
    public String request;
    public String response;
    public Boolean isConfirm {get;set;}
    public Boolean isError {get;set;}
    public String FirstName{get;set;}
    public String lastName{get;set;}
    public String scanCode{get;set;}
    public String PersonEmail{get;set;}
    public String phone{get;set;}
    public string addType{get;set;}
    public string Didid{get;set;}
    public string stepId{get;set;}
    public string campaign{get;set;}
    public string acknowledge{get;set;}
    public String addressId{get;set;}
    public BrightPatternAddressCreation_AC()
    {
        Didid = ApexPages.currentPage().getParameters().get('Didid');
        stepId = ApexPages.currentPage().getParameters().get('stepid');
        campaign = ApexPages.currentPage().getParameters().get('campaign');
        addressId = ApexPages.currentPage().getParameters().get('address');
        List<Address__c> addressList = [SELECT Id,Street__c,City__c,State__c,Full_Zip_Code__c,Country__c FROM Address__c WHERE Id =: (Id)addressId];
        if(addressList.size() > 0){
            streetName = addressList[0].Street__c;
            city = addressList[0].City__c;
            state = addressList[0].State__c;
            zipCode = addressList[0].Full_Zip_Code__c;
            country = addressList[0].Country__c;
        }
    }
    // Searching the Address.
    public pagereference SearchAddress()
    {
        String Query = 'Select id,State__c, Street__c, Zip_Code__c, Country__c,City__c FROM Address__c WHERE ';
        
        StreetName = StreetName.trim();
        zipCode = zipCode.trim();
        city  = city.trim();
        Country = Country.trim();
        // State  = State.trim();
        
        if(streetName != Null && streetName !='' && zipCode != Null && zipCode !='')
        {
            
            Query +=' (Street__c like \'%'+ streetName +'%\''+ ' AND';
            Query +='  Zip_Code__c like \'%'+ zipCode +'%\'' +')'+' OR';
        }
        
        
        Query += '(';
        
        if(streetName != Null && streetName !='' )
        {
            Query +=' Street__c like \'%'+ streetName +'%\''+ ' AND';
        }
        
        if(zipCode != Null && zipCode !='')
        {
            Query +=' Zip_Code__c like \'%'+ zipCode +'%\'' +' AND';
        }
        
        if(city != '' && city != Null)
        {
            Query +=' City__c like \'%'+ city +'%\'' + ' AND';
        }
        
        
        if(State != '' && State != 'None' && state!=Null)
        {
            Query +=' State__c like \'%'+ State +'%\'' + ' AND';
        }
        
        
        
        Query = query.removeEnd('AND');
        Query += ')';
        System.debug('Query ++++++++++++++++++++++++++++++++++ ' + Query);
        addressList = Database.Query(Query);
        
        if(addressList.size() > 0)
        {
            String addressId;
            
            addressId = addressList[0].id;
            Address__c updateAdd = new Address__c();
            updateAdd.invalid__c = false;
            updateAdd.id = addressList[0].id;
            update updateAdd;
            
            String branch ='';
            List<Branch__c> branchList = new List<Branch__c>();
            if(addressList[0].state__c != Null && addressList[0].city__c!= Null)
                branch = addressList[0].state__c+'-'+addressList[0].city__c;
            
            if(branch != '')
            {
                branchList = [SELECT Id, Name FROM Branch__c WHERE Name = :branch limit 1];
            }
            
            
            
            
            Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            Account newAcc = new Account();
            newAcc.lastName = lastName;
            newAcc.firstName = firstName;
            newAcc.PersonEmail = PersonEmail;
            newAcc.Recordtypeid = accountRecordTypeId;
            newAcc.phone = phone;
            newAcc.scan_code__c = scanCode;
            newAcc.respond_Date__c = Date.Today();
            insert newAcc; // creating new account.
            
            User_Address__c newUserAddress = new User_Address__c();
            newUserAddress.Address__c = addressId;
            newUserAddress.UserAccount__c = newAcc.id;
            newUserAddress.Phone__c = phone;
            newUserAddress.active__c= true;
            newUserAddress.user_address_type__c= addType;
            newUserAddress.CreatedfromBP__c = true;
            newUserAddress.X1st_IB_Agent__c = userInfo.getUserId();
            newUserAddress.X1st_IB_Agent_Date__c = System.Now();
            newUserAddress.InteractionStepId__c = stepId;
            insert newUserAddress;   // creating new user address.
            
            PageReference reference=new PageReference('/apex/BrightPatternpopup?id='+newAcc.id+'&Didid='+Didid+'&Campaign='+campaign+'&stepid='+stepId+'&userAddressId='+newUserAddress.id);
            reference.setRedirect(true);     
            return reference;
        }
        
        
        else
        { // Validating the address.
            
            AddressWrapper requestAddressWrap = new AddressWrapper();
            AddressWrapper responseAddressWrapper = new AddressWrapper();
            requestAddressWrap.Line1 = '';
            requestAddressWrap.Line2 =(String)(streetName != '' ? streetName :'');
            requestAddressWrap.City = (String)(City != '' ? City : '');
            requestAddressWrap.State = (String)(State != '' ? State : '');
            requestAddressWrap.Zip5 = (String)(zipCode != '' ? zipCode : '');
            System.Debug('Request Wrapper+++++'+requestAddressWrap);            
            request = requestAddressWrap.createJson(requestAddressWrap);
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            Http http = new Http();
            req.setEndpoint(' https://address-verification.nuhome.com/v1/address/verify');
            req.setMethod('POST');
            req.setHeader('Accept', 'application/Json');
            req.setBody(request);
            //req.setCompressed(true); // otherwise we hit a limit of 32000
            try {
                
                Integer responseCode;
                if(test.isRunningTest())
                    responseCode = 200;
                else
                {
                    res = http.send(req);
                    responseCode = res.getStatuscode();
                }
                if(responseCode == 200){
                    System.debug('Response============>'+res.getBody());
                    // Parse JSON response to get all the totalPrice field values.
                    JSONParser parser = JSON.createParser(res.getBody());
                    isConfirm = True;
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
                    if(!test.isRunningTest())
                        responseAddressWrap = responseAddressWrapper.parse(res.getBody());
                    system.debug('!!!isConfirm: ' + isConfirm);
                    if( isConfirm == false)
                    {
                        
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Invalid Address'));
                        return null;
                    }
                    
                    if(isConfirm == True)
                    {
                        
                        String street;
                        if(streetNumber == Null)
                            streetNumber = '';
                        if(streetName == Null)
                            streetName = '';
                        
                        Street =  streetNumber+' '+ streetName;
                        String branch ='';
                        List<Branch__c> branchList = new List<Branch__c>();
                        if(responseAddressWrap.city != Null && responseAddressWrap.state != Null)
                            branch = responseAddressWrap.state+'-'+responseAddressWrap.city;
                        
                        if(branch != '')
                        {
                            
                            branchList = [SELECT Id, Name FROM Branch__c WHERE Name = :branch limit 1];
                        }
                        
                        String street1 = responseAddressWrap.Line1;
                        String Street2 = responseAddressWrap.Line2;
                        String zipCode = responseAddressWrap.Zip5;
                        
                        String uniqueKey1 = street1+':'+zipCode;
                        String uniqueKey2 = street2+':'+zipCode;
                        
                        List<Address__c> existingAddress = [SELECT id from Address__c WHERE (Unique_Key__c = :uniqueKey1 or Unique_Key__c = :uniqueKey2) Limit 1];
                        
                        
                        Address__c newAddress = new Address__C();
                        newAddress.name = street+':'+city+':'+state;
                        newAddress.Street__c = responseAddressWrap.Line1 != '' ? responseAddressWrap.Line1 : responseAddressWrap.Line2 != ''?responseAddressWrap.Line2:'';
                        newAddress.Zip_Code__c = responseAddressWrap.Zip5;
                        newAddress.City__c = responseAddressWrap.City;
                        newAddress.Country__c = country;
                        newAddress.State__c = responseAddressWrap.State;
                        newAddress.Zip_Plus_Four__c = responseAddressWrap.Zip4;
                        if(branchList.size() > 0)
                            newAddress.branch__c = branchList[0].id;
                        
                        try
                            
                        {   
                            
                            String addressId;
                            if(!(existingAddress.size() > 0))
                            {
                                insert newAddress;
                                addressId = newAddress.id;
                            }
                            else
                            {
                                addressId = existingAddress[0].id;
                                
                                Address__c updateAdd = new Address__c();
                                updateAdd.id = existingAddress[0].id;
                                updateAdd.invalid__c = false;
                                update updateAdd;
                                
                            }
                            
                            
                            
                            Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
                            Account newAcc = new Account();
                            newAcc.lastName = lastName;
                            newAcc.firstName = firstName;
                            newAcc.PersonEmail = PersonEmail;
                            newAcc.Recordtypeid = accountRecordTypeId;
                            newAcc.phone = phone;
                            newAcc.scan_code__c = scanCode;
                            newAcc.respond_Date__c = Date.Today();
                            insert newAcc; // creating new account.
                            
                            User_Address__c newUserAddress = new User_Address__c();
                            newUserAddress.Address__c = addressId;
                            newUserAddress.UserAccount__c = newAcc.id;
                            newUserAddress.Phone__c = phone;
                            newUserAddress.active__c= true;
                            newUserAddress.user_address_type__c= addType;
                            newUserAddress.CreatedfromBP__c = true;
                            newUserAddress.X1st_IB_Agent__c = userInfo.getUserId();
                            newUserAddress.X1st_IB_Agent_Date__c = System.Now();
							newUserAddress.InteractionStepId__c = stepId;                        
                            try
                            {
                                insert newUserAddress;  
                                PageReference reference=new PageReference('/apex/BrightPatternpopup?id='+newAcc.id+'&Didid='+Didid+'&Campaign='+campaign+'&stepid='+stepId+'&userAddressId='+newUserAddress.id);
                                reference.setRedirect(true);     
                                return reference; // creating new user address.
                            }
                            
                            Catch(DMLException e)
                            {
                                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
                            }
                        }
                        
                        Catch(DMLException e)
                        {
                            
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
                        }
                        
                        
                        
                        
                    }
                }
                else if(res.getStatuscode() == 400){
                    isConfirm = false;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Address Not Found'));
                }
            } catch(System.CalloutException e) {
                System.debug('Callout error: '+ e);
                System.debug(res.toString());
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
                
            }
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
    
    
    
    
    // Getting State picklist values from USPS_States_List__c custom settings.
    public List<SelectOption> getStates()
    {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult =  Address__c.State__c.getDescribe();
        
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        options.add(new SelectOption('', 'None')); 
        for( Schema.PicklistEntry currVal : picklistValues)
        {
            options.add(new SelectOption(currVal.getLabel(), currVal.getValue())); 
            
        }   
        
        return options;
    }
    
    // Getting Appointment Outcome picklist values from Inventory field.
    public List<SelectOption> getAddressType()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Renter', 'Renter')); 
        options.add(new SelectOption('Un-validated Homeowner', 'Un-validated Homeowner')); 
        options.add(new SelectOption('Family of Renter', 'Family of Renter')); 
        options.add(new SelectOption('Family of Un-validated Homeowner', 'Family of Un-validated Homeowner')); 
        return options;
    }
    
    // Redirecting to Account Search Page.
    Public PageReference GotoAccSearchPage()
    {
        
        PageReference reference=new PageReference('/apex/BrightPatternSearchPopup?Didid='+Didid+'&stepid='+stepId+'&Campaign='+campaign); 
        reference.setRedirect(true);     
        return reference;
        
    } 
}