/***********************************************************************************
Created by : MST
Description : 
            It will search the User Address based on the Name, Confirmation Number, Gift Card Number, Scan code,
Mobile and Address details. 
            If user address is available, then it will display the search result under page block table. 
            Agent can select the user address and move into next brightpatternpopup page.
            while selecting user address, it will do some kind validation that, the address is valid one or not.
            If it is not valid address, then it will ask agent to update the correct user address/create new address.
************************************************************************************/

Public class BrightPatternSearchPopup_AC
{
    public string name{get;set;}
    public string phone{get;set;}
    public string scanCode{get;set;}
    public string streetNumber{get;set;}
    public string streetName{get;set;}
    public string city{get;set;}
    public string state{get;set;}
    public string zipCode{get;set;}
    public string confirmationNumber{get;set;}
    public List<user_Address__c> userAddressList{get;set;}
    public boolean searchFlag{get;set;}
    public integer total_size{get;set;} //used to show user the total size of the list
    private integer counter=0;  //keeps track of the offset
    private integer list_size=20; //sets the page size or number of rows
    public boolean showSearchBlk{get;set;}
    public String searchAccountId{get;set;}
    public string Didid{get;set;}
    public string stepId{get;set;}
    public string campaign{get;set;}
    public String addressId{get;set;}
    public Address__c address {get;set;}
    public Boolean isConfirm {get;set;}
    public AddressWrapper responseAddressWrap{get;set;}
    public AddressWrapper requestAddressWrap{get;set;}
    public AddressWrapper responseAddressWrapper{get;set;}
    public String selectedAddress{get;set;}
    private String request;
    public String displayUpdate{get;set;}
    public Id userAccoundId{get;set;}
    public BrightPatternSearchPopup_AC()
    {
        userAccoundId = null;
        address = new Address__c();
        isConfirm = false;
        displayUpdate = '';
        name = '';
        scanCode = '';
        streetNumber = '';
        streetName = '';
        city = '';
        state = '';
        zipCode = '';
        confirmationNumber = '';
        searchFlag = false;
        showSearchBlk = false;
        Didid = ApexPages.currentPage().getParameters().get('Didid');
        stepId = ApexPages.currentPage().getParameters().get('stepid');
        campaign = ApexPages.currentPage().getParameters().get('campaign');
        addressId = ApexPages.currentPage().getParameters().get('address');
        
    }
    
    
    // displaying current page on product list page.
    public Integer getPageNumber() {
        return counter/list_size + 1;
    }
    
    // Calculating total number of pages.
    public Integer getTotalPages() {
        try{
            if (math.mod(total_size, list_size) > 0) {
                return total_size/list_size + 1;
            } else {
                return (total_size/list_size);
            }
        }catch(Exception e){
            return 0;
        }
    }
    
    //Pagination
    public PageReference Beginning() { //user clicked beginning
        counter = 0;
        searchAccount();
        return null;
    }
    
    public PageReference Previous() { //user clicked previous button
        counter -= list_size;
        searchAccount();
        return null;
    }
    
    public PageReference Next() { //user clicked next button
        counter += list_size;
        searchAccount();
        return null;
    }
    
    public PageReference End() { //user clicked end
        counter = total_size - math.mod(total_size, list_size);
        searchAccount();
        return null;
    }
    
    public Boolean getDisablePrevious() { 
        //this will disable the previous and beginning buttons
        if (counter>0) return false; else return true;
    }
    
    public Boolean getDisableNext() { //this will disable the next and end buttons
        if (counter + list_size < total_size) return false; else return true;
    }
    
    // Searching User Address with Account details
    public pagereference searchAccount()
    {
        List<User_Address__c> accList = New List<User_Address__c>();
        
        List<Gift_Card_Activation__c> giftCardActivationList = new List<Gift_Card_Activation__c>();
        List<Gift_Card__c> giftCardsList = new List<Gift_Card__c>();
        userAddressList = new List<User_Address__c>();
        Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        String Query  =  'SELECT Id,UserAccount__c,UserAccount__r.Name,Confirmation_Number__c,UserAccount__r.type,UserAccount__r.personmobilephone,'+
            'UserAccount__r.PersonHomePhone,UserAccount__r.PersonOtherPhone,UserAccount__r.PersonEmail,' + 
            'Scan_Code__c,Respond_Date__c,'+
            'Address__r.City__c,Address__r.Street__c, ' +
            'Address__r.State__c,Address__r.Zip_Code__c '+
            'FROM User_Address__c  ';
        
        String cond;
        cond = '  WHERE useraccount__r.recordtypeid = :accountRecordTypeId ' +'AND';
        
        Boolean runQuery;
        
        if(scanCode != '' && scanCode != Null)
        {
            String searchStr1 = '*'+scanCode+'*';
            runQuery = true;
            
            String searchQuery = 'FIND \'' + searchStr1 + '\' IN ALL FIELDS RETURNING  User_Address__c(Id,UserAccount__c,scan_code__c),Gift_Card_Activation__c(Name,Person_Account__c,Gift_Card_Order__r.Name,id),Gift_Card__c(Name,Gift_Card_Order__r.Name,id,Gift_Card_Order__c)';
            List<List <sObject>> searchList = search.query(searchQuery);
            accList = ((List<User_Address__c>)searchList[0]);
            giftCardActivationList = ((List<Gift_Card_Activation__c>)searchList[1]);
            giftCardsList = ((List<Gift_Card__c>)searchList[2]);
            
            Set<String> Ids = new Set<String>();
            
            for(User_Address__c userAdd : accList)
            { 
                Ids.add(userAdd.UserAccount__c);
            }
            
            
            for(Gift_Card_Activation__c giftActivation : giftCardActivationList)
            {
                Ids.add(giftActivation.Person_Account__c);
            }
            
            Set<Id> giftCardOrderIds = new Set<Id>();
            for(Gift_Card__c currCard : giftCardsList)
            {
                giftCardOrderIds.add(currCard.Gift_Card_Order__c);
            }
            
            for(Gift_Card_Activation__c currActiveCard : [SELECT Id, Person_Account__c FROM Gift_Card_Activation__c WHERE Gift_Card_Order__c IN :giftCardOrderIds])
            {
                Ids.add(currActiveCard.Person_Account__c);
            }
            
            cond +=' useraccount__c IN :Ids '+'AND'; 
            
        }
        
        if(name != '' && name != Null)
        {
            runQuery = true;
            cond +=' (useraccount__r.FirstName like \'%'+ name +'%\'' + '  OR ';
            cond +=' useraccount__r.Name like \'%'+ name +'%\'' + '  OR ';
            cond +=' useraccount__r.FirstName like \''+ name +'%\'' +'  OR ';
            cond +=' useraccount__r.lastName like \'%'+ name +'%\'' + '  OR ';
            cond +=' useraccount__r.lastName like \''+ name +'\'' +' OR ';
            cond +=' useraccount__r.Spouse_Other_Name__c  like \''+ name +'\'' +' OR ';
            cond +=' useraccount__r.Spouse_Other_Name__c like \'%'+ name +'%\'' + ') '+ 'AND';
            
        }
        
        if(phone!=Null && phone!='')
        {
        
           runQuery = true;
           Pattern p = Pattern.compile('[-() ]');
           String tempPhone = p.matcher(Phone).replaceAll('');
           
            if(tempPhone.length() == 10)
            {
            
               tempPhone =  '('+tempPhone.substring(0, 3) + ') '+tempPhone.substring(3, 6) + '-' + tempPhone.substring(6, 10);
            }
            
            cond +='( useraccount__r.Phone  like \''+ tempPhone +'\'' +' OR ';
            cond +=' useraccount__r.PersonMobilePhone  like \''+ tempPhone  +'\'' +' OR ';
            cond +=' useraccount__r.PersonMobilePhone  like \'%'+ tempPhone +'%\'' +' OR ';
            cond +=' useraccount__r.Phone like \'%'+ tempPhone +'%\'' + ') '+ 'AND';
        
        }
        
        if(streetNumber != '' && streetNumber != Null)
        {
            runQuery = true;
            cond +=' Address__r.Street__c like \'%'+ streetNumber +'%\' ' + 'AND';
        }
        
        if(streetName != '' && streetName != Null)
        {
            runQuery = true;
            cond +=' (Address__r.Street__c like \'%'+ streetName +'%\' ' + 'OR ';
            cond +='  Address__r.Street__c = :streetName)  ' + 'AND';
        }
        
        if(city != '' && city != Null)
        {
            runQuery = true;
            cond +=' (Address__r.City__c like \'%'+ city +'%\' ' + ' OR ';
            cond +='  Address__r.City__c  = :city)  '  +'AND';
        }
        
        if(state != '' && state != Null && State != 'None')
        {
            runQuery = true;
            cond +='  (Address__r.State__c like \'%'+ state +'%\' ' + ' OR ';
            cond +='  Address__r.State__c = :state)  ' +'AND';
        }
        
        if(zipCode != '' && zipCode != Null)
        {
            runQuery = true;
            cond +=' (Address__r.Zip_Code__c like \'%'+ zipCode +'%\' ' + ' OR ';
            cond +='  Address__r.Zip_Code__c = :zipCode) ' +'AND';
        }
        
        if(confirmationNumber != '' && confirmationNumber != Null)
        {
            runQuery = true;
            cond +=' (Confirmation_Number__c like \'%'+ confirmationNumber+'%\' ' + ' OR ';
            cond +='  Confirmation_Number__c = :confirmationNumber) ' +'AND';
        }
        
        cond  = cond.removeEnd('AND');
        //   String filterQuery = Query + cond+' ORDER BY CreatedDate DESC limit 1000';
        Query += cond+ ' ORDER BY CreatedDate DESC limit :list_size offset :counter ';
        
        try{
            
            if(runQuery == true)
            {
                
                System.debug('Query+++++++++++++++++++++++++++++++ ' + Query );
                userAddressList = Database.Query(Query);
                
                String limits = cond + ' limit 1000';
                List<User_Address__c> countAgg = Database.Query('select Id from User_Address__c  '+limits);
                total_size = (countAgg != null && countAgg.size() > 0) ? countAgg.size() : 0;
                searchFlag = True;
                showSearchBlk = true;
            }
        }
        
        Catch(QueryException e)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getmessage()));
        }
        
        
        return null;
    }
    
    // It will validate the selected User Address, if verbal consent is yes/phone only, then will redirect to Bright pattern
    // inbound script else it will redirect the agent to Verbal Consent page.
    Public PageReference ValidateSearchAccount()
    {
        User_Address__c searchAccount = [SELECT Id,UserAccount__c,UserAccount__r.Name,UserAccount__r.type,UserAccount__r.personmobilephone,
                                         UserAccount__r.PersonHomePhone,UserAccount__r.PersonOtherPhone,UserAccount__r.PersonEmail,
                                         Scan_Code__c,Respond_Date__c,UserAccount__r.Verbal_consent__c,
                                         Address__r.City__c,Address__r.Street__c,Address__r.Country__c,Address__r.County__c,
                                         Address__r.State__c,Address__r.Zip_Code__c,Address__r.Invalid__c
                                         FROM User_Address__c WHERE Id = :searchAccountId Limit 1];
        if(searchAccount.Address__r.Invalid__c == True){
                //Prepopulate the popup.
                address.Country__c = searchAccount.Address__r.Country__c;
                address.Street__c = searchAccount.Address__r.Street__c;
                address.State__c = searchAccount.Address__r.State__c;
                address.City__c = searchAccount.Address__r.City__c;
                address.Zip_Code__c = searchAccount.Address__r.Zip_Code__c;
                address.County__c = searchAccount.Address__r.County__c;
                userAccoundId = searchAccount.UserAccount__c;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'The Selected Address is Invalid/Dummy Address. Please click on Update and enter valid Address.'));
            return null;
        }
        else{
            PageReference reference=new PageReference('/apex/BrightPatternpopup?id='+searchAccount.UserAccount__c+'&Didid='+Didid+'&Campaign='+campaign+'&stepid='+stepId+'&userAddressId='+searchAccount.id);
            reference.setRedirect(true);     
            return reference;
        }
    }
    
    // It will redirect the agent to Account Creation page.
    Public PageReference GotoAccCreatePage()
    {
        PageReference reference;
        if(addressId != Null)
            reference=new PageReference('/apex/BrightPatternCreatePopup?Didid='+didid+'&stepid='+stepId+'&Campaign='+campaign+'&address='+addressId);
        else
            reference=new PageReference('/apex/BrightPatternCreatePopup?Didid='+didid+'&stepid='+stepId+'&Campaign='+campaign); 
        reference.setRedirect(true);     
        return reference;
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
    
    public void closePopup(){
        isConfirm = false;
    }
    
    // This function would validate the entered address is valid one or not.
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
            system.debug('res.getStatuscode()'+res.getStatuscode());
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
    
    
    // It will create new valid address.
    public pageReference saveAddress(){
        //Assign values from responseAddressWrapper class
        
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
        
        List<Address__c> existingAddress = [SELECT id,Name from Address__c WHERE (Unique_Key__c = :uniqueKey1 or Unique_Key__c = :uniqueKey2) Limit 1];
        
        try{
            
            String dupAddressId = label.Dummy_Address_Id;
            Address__c newAddress = new Address__C();
            newAddress.Invalid__c = false;
            if(existingAddress.size() > 0)
            {
                newAddress.id = existingAddress[0].id;
                if(existingAddress[0].id == dupAddressId )
                {
                    newAddress.invalid__c = True;
                }
            }
            
            newAddress.name = responseAddressWrap.Line1;
            newAddress.Street__c = responseAddressWrap.Line1 != '' ? responseAddressWrap.Line1 : responseAddressWrap.Line2 != ''?responseAddressWrap.Line2:'';
            newAddress.Zip_Code__c = responseAddressWrap.Zip5;
            newAddress.City__c = responseAddressWrap.City;
            newAddress.Country__c = address.country__c;
            newAddress.State__c = responseAddressWrap.State;
            newAddress.Zip_Plus_Four__c = responseAddressWrap.Zip4;
            
            
            if(branchList.size() > 0)
                newAddress.branch__c = branchList[0].id;
            Upsert newAddress;
            
            
            system.debug('address update+++'+address.Id);
            User_Address__c userAddressupdate = new User_Address__c();
            userAddressupdate.Id = (Id)searchAccountId;
            userAddressupdate.Address__c = newAddress.Id;
            userAddressupdate.InteractionStepId__c = stepId;
            update userAddressupdate;
            displayUpdate = '';
            PageReference reference=new PageReference('/apex/BrightPatternpopup?id='+userAccoundId+'&Didid='+Didid+'&Campaign='+campaign+'&stepid='+stepId+'&userAddressId='+userAddressupdate.id);
            reference.setRedirect(true);     
            return reference;
            
        }
        catch(Exception e){
            
        }
        return null;
        
    }
    
    
    /*  If user submits [Create Address As It is] button, It will search the address already in system or not,
       if it is available, then it will associate the user address with available one, else it will create a address 
       newly and associate with selected user Address */
       
       
    public pageReference createAddress(){
        //Assign values from responseAddressWrapper class
        String branch ='';
        List<Branch__c> branchList = new List<Branch__c>();
        if(address.City__c != Null && address.State__c != Null)
            branch = address.City__c+'-'+address.State__c;
        
        if(branch != '')
        {
            
            branchList = [SELECT Id, Name FROM Branch__c WHERE Name = :branch limit 1];
        }
        
        String uniqueKey1 = address.Street__c+':'+address.Zip_Code__c;
        List<Address__c> existingAddress = [SELECT id,Name from Address__c WHERE (Unique_Key__c = :uniqueKey1) Limit 1];
        
        try{
            
            
            String addressId;
            String dupAddressId = label.Dummy_Address_Id;   
            if(existingAddress.size() > 0)
            {
                addressId = existingAddress[0].id;
                Address__c newAddress = new Address__c();
                newAddress.id = addressId;
                newAddress.invalid__c = False;
                
                if(existingAddress[0].id == dupAddressId )
                {
                    newAddress.invalid__c = True;
                }
                update newAddress;
                
            }
            
            if(!(existingAddress.size() > 0))
            {
                Address__c newAddress = new Address__C();
                newAddress.name = address.Street__c;
                newAddress.Street__c = address.Street__c;
                newAddress.Zip_Code__c = address.Zip_Code__c;
                newAddress.City__c = address.City__c;
                newAddress.Country__c = address.country__c;
                newAddress.county__c = address.County__c;
                newAddress.State__c = address.State__c;
                newAddress.Home_Type__c = address.Home_Type__c;
                // newAddress.Zip_Plus_Four__c = responseAddressWrap.Zip4;
                newAddress.CreatedFromBP__c = True;
                newAddress.Invalid__c = false;
                if(branchList.size() > 0)
                    newAddress.branch__c = branchList[0].id;
                insert newAddress;
                addressId = newAddress.id;
            }
            
            system.debug('address update+++'+address.Id);
            User_Address__c userAddressupdate = new User_Address__c();
            userAddressupdate.Id = (Id)searchAccountId;
            userAddressupdate.Address__c = addressId;
            userAddressupdate.InteractionStepId__c = stepId;
            update userAddressupdate;
            displayUpdate = '';
            
            PageReference reference=new PageReference('/apex/BrightPatternpopup?id='+userAccoundId+'&Didid='+Didid+'&Campaign='+campaign+'&stepid='+stepId+'&userAddressId='+userAddressupdate.id);
            reference.setRedirect(true);     
            return reference;
        }
        catch(Exception e){
            
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