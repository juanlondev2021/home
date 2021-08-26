/**
* Diaco
* @author 			Jorge Martinez href=<jorgeality29@gmail.com>
* Project:			Contracts
* Description:		class responsible for handling DiacoContract Lightning component.
*
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		22/02/2019		Jorge Martinez (JM)		Initial implementation of the class.
* @version  1.0     04/11/2020      Fabian Pineda (FP)      Added new "getRecordInfo" method.
**/

public class DiacoCmpContractController {
/**
* 
* This method is responsible for getting all personal information about the first customer.
* 
* This method is used in:
*  the  diacoContractFirstCustomer.cmp helper
*  
* 
* @param RecordId is the home service Id controller
* @return account updated
*/ 
    @AuraEnabled
    public static Line_Item__c deleteLineItem(String recordId){
        Line_Item__c l=new Line_Item__c();
        l.id=recordId;
        delete l;
        return l;
    }
    @AuraEnabled
    public static Id generateContract(String recordId,String name){
        PageReference pageRef = new PageReference('/apex/'+name);
        pageRef.getParameters().put('id', recordId);
        
        Blob pdfBlob; 
        if(Test.isRunningTest()) { 
            pdfBlob = blob.valueOf('Unit.Test');
        } else {
            pdfBlob = pageRef.getContentAsPDF();
        }
        String contractName=name+'_'+recordId;
        delete [SELECT Id,Title from ContentDocument WHERE Title = :contractName];
        
        ContentVersion cv = new ContentVersion();
        cv.ContentLocation = 'S';
        cv.PathOnClient = '.pdf';
        cv.Origin = 'H';
        //cv.OwnerId = at.OwnerId;
        cv.Title = contractName;
        cv.VersionData = pdfBlob;
        insert cv;
        
        string contentDocumentId;
        ContentVersion[] contentV= [SELECT ContentDocumentId FROM ContentVersion WHERE Title = :contractName];
        if(contentV.size() > 0) {
            contentDocumentId = contentV[0].ContentDocumentId; 
        }
        
        /*ContentDocumentLink link = new ContentDocumentLink();
        link.LinkedEntityId = recordId;
        link.ContentDocumentId = contentDocumentId;
        link.ShareType = 'V';
        insert link;*/
        
        return contentDocumentId;
        
    }
    @AuraEnabled
    public static Account getDataCustomerOne(String RecordId){
        Home_Services__c home =  [select Account__c from Home_Services__c where id = :RecordId];
        Account account = [select Id, FirstName, LastName, Customer_1_DOB__c, Customer_1_SSN_E__c,Customer_1_Drivers_License_Expiration__c, Customer_1_Drivers_License__c,
                           Drivers_license_Issuing_state_1__c,Score_Customer_1__c,Customer_1_Drivers_License_Issue_Date__c, Customer_1_Employer__c, Customer_1_Employer_Phone__c, Customer_1_Income__c,
                           Customer_1_Length_of_Employment__c, Customer_1_Employment_Position__c, Phone, PersonMobilePhone, PersonEmail
                           from Account 
                           where Id = :home.Account__c ];
        return account;
    }
    
    @AuraEnabled
    public static Home_Services__c getDataHomeServicePricing(String RecordId){
        Home_Services__c home =  [select Id, Total_Cash_Selling_Price__c, Sales_Tax__c, Total_Cash_Price__c, Down_Payment__c,
                                  Trade_in_Allowance__c, Total_Down_Payment__c, Balance_Due__c, Total_Monthly_Investment__c
                                  from Home_Services__c 
                                  where id = :RecordId];
        return home;
    }
    @AuraEnabled
    public static Home_Services__c getDataHomeService(String RecordId){
        Home_Services__c home =  [select Id, Account__c,Communication_By__c,Monthly_Security_Services__c, Hardness_gpg__c, Ph__c, Iron_Algae__c, Iron_ppm__c, Hyd_Supl_ppm__c, No_Reg__c, Other__c, Special_Instructions__c 
                                  from Home_Services__c where id = :RecordId];
        return home;
    }
    @AuraEnabled
    public static Account getDataHomeServiceAgreement(String RecordId){
        Home_Services__c home =  [select Account__c from Home_Services__c where id = :RecordId];
        Account account = [select Id, FirstName, LastName, Phone, PersonEmail, Homeowner_2_First_Name__c, Homeowner_2_Last_Name__c, Homeowner_2_Phone_Number__c,
                           Homeowner_2_Email__c, State__c, City__c, Street__c, Zip__c, Billing_Information_From__c, Billing_First_Name__c, Billing_Last_Name__c, 
                           Billing_Phone__c, Billing_Fax__c, Billing_Company__c, Primary_Billing_State__c, Primary_Billing_City__c, Primary_Billing_Street__c, 
                           Primary_Billing_Zip_Code__c, Billing_Email__c, PersonMobilePhone, Fax,
                           Billing_Information_From_Service__c,Billing_First_Name_Service__c, Billing_Last_Name_Service__c, 
                           Billing_Phone_Service__c, Billing_Email_Service__c, Billing_Fax_Service__c, Billing_Company_Service__c,
                           Primary_Billing_State_Service__c, Primary_Billing_City_Service__c,Primary_Billing_Street_Service__c,
                           Primary_Billing_Zip_Code_Service__c, Billing_Address_Same_As_Service_Address__c, Billing_Address_Same_As_Product__c 
                           from Account 
                           where Id = :home.Account__c ];
        return account;
    }
    @AuraEnabled
    public static String getRecordType(String RecordId){
        System.debug(recordId);
        Home_Services__c home =  [select RecordType.Name from Home_Services__c where id = :RecordId];
        string RecordTypeName = products(home.RecordType.Name);
        return RecordTypeName;
    }
    
    /**
* this method is responsible for getting all personal information about the second customer.
* 
* This method is used in:
*  The  diacoContractSecondCustomer.cmp helper
* 
* @param RecordId is the home service Id controller
* @return account updated
*/ 
    @AuraEnabled
    public static Account getDataCustomerTwo(String RecordId){
        Home_Services__c home =  [select Account__c from Home_Services__c where id = :RecordId];
        Account account = [select Id, Customer_2_DOB__c,Customer_2_Drivers_License_Issue__c, Customer_2_Drivers_License__c,Customer_2_Drivers_License_Expiration__c,
                           Drivers_license_Issuing_state_2__c, Homeowner_2_First_Name__c,Score_Customer_2__c,Homeowner_2_Last_Name__c, Customer_2_SSN__c, Homeowner_2_Phone_Number__c,
                           Homeowner_2_Mobile__c, Homeowner_2_Email__c, Customer_2_Employer__c, Customer_2_Employer_Phone__c, Customer_2_Income__c, Customer_2_Length_of_Employment__c,
                           Customer_2_Employment_Position__c
                           from Account 
                           where Id = :home.Account__c ];
        return account;
    }
    
    /**
* This method is responsible for getting all State from account SObject.
* 
* This method is used in:
*  the  diacoContractFirstCustomer.cmp helper
*  the  diacoContractSecondCustomer.cmp helper
* 
* @return all states as a json(string)
*/ 
    @AuraEnabled
    public static List<String> getStates(){
        Schema.sObjectType objType = Account.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        list<Schema.PicklistEntry> values = fieldMap.get('State__c').getDescribe().getPickListValues();
        List<String> states = new List<String>();
        for (Schema.PicklistEntry v : values){
            states.add(v.getLabel());
        }
        return states;
    }
    /**
* This method is responsible for saving Account Information.
* 
* This method is used in:
*  the  diacoContractFirstCustomer.cmp helper
* 	the  diacoContractSecondCustomer.cmp helper
* 
* @return the Account Updated/saved
*/ 
    @AuraEnabled
    public static Account saveAccount(Account account){
        upsert account;
        return account;
    }
    /**
* 
* This method is responsible of getting information about account's Address and Mortgage Payment
* 
* this method is used in:
* 	the  diacoContractLocationAndPayments.cmp helper
* 
* @return address Account and Mortgage Payment
* 
*/ 
    @AuraEnabled
    public static Account getDataLocationAndPayments(String RecordId){
        Home_Services__c home =  [select Account__c from Home_Services__c where id = :RecordId];
        Account account = [select Id, State__c, City__c, Street__c, Zip__c, Mortgage_Payment__c
                           from Account 
                           where Id = :home.Account__c ];
        return account;
    }
    /**
* 
* This method is responsible of getting information about installation date of the home service
* 
* this method is used in:
* 	the  diacoContractInstallationDate.cmp helper
* 
* @return a home service object
* 
*/ 
    @AuraEnabled
    public static Home_Services__c getInstallationDate(String RecordId){
        return [select Id, Sales_Rep__c, Requested_Install_Date__c,Requested_service_Date__c
                from Home_Services__c 
                where id = :RecordId];
    }
    
    
    
    /**
* This method is responsible for saving homes service Information.
* 
* This method is used in:
*  the  diacoContractInstallationDate.cmp helper
* 
* @return the home service Updated/saved
*/ 
    @AuraEnabled
    public static Home_Services__c saveHomeService(Home_Services__c Home_Services){
        upsert Home_Services;
        return Home_Services;
    }
    
    @AuraEnabled
    public static Home_Services__c saveHomeService2(Home_Services__c Home_Services){
        upsert Home_Services;
        return Home_Services;
    }
    @AuraEnabled
    public static Home_Services__c saveHomeService3(Home_Services__c Home_Services){
        upsert Home_Services;
        return getPaymentMethods(Home_Services.Id);
    }
    
    
    //
    /**
* This method is responsible for getting all sales rep.
* 
* This method is used in:
*  the  diacoContractInstallationDate.cmp helper
* 
* @return list of users
*/ 
    @AuraEnabled
    public static List<User> getSalesReps(){
        return [select Id, Name from User];
    }
    /**
* This method is responsible for getting the name of the sales rep.
* 
* This method is used in:
*  the  diacoContractInstallationDate.cmp helper
* 
* @return a user name
*/ 
    @AuraEnabled
    public static String getSalesRepsName(String salesRepId){
        User use = [select Id, Name from User where Id = :salesRepId];
        return use.Name;
    }
    /**
* This method is responsible for getting the name of the home service's record type.
* 
* This method is used in:
*  the  diacoContractproduct.cmp helper
* 
* @return home service's record type
*/ 
    public static String products(String RecordTypeName){
        //'Water','Home Automation','Solar','Window'
        String [] Hse = new String[]{'Water','Home','Solar','Window','Pest','Remodel'};
            system.debug('name record : ' +RecordTypeName);
        List<String> res = RecordTypeName.split(' ');
        String sd ='';
        for(String s : res ){
            for(String x : Hse){
                if(s == x){
                    if(x == 'Home'){
                        sd = 'Home Automation';
                        break;
                    }
                    sd = x;
                    break;
                }  
            }
        }
        system.debug('sd : ' +sd);
        return sd;
    }
    
    /*
* this method is responsible for getting the product type. if it is a service or not
* 
* @return a product list
* 
*/
    public static List<Product__c> ListServices(String productType, Integer stype){
        if(stype == 1)
        {
            return [select Id, Name, Part_Number__c, Cost__c, Sales_Price__c, Description__c, Service__c from Product__c where Product_Type__c = :productType and Service__c = false and active__c = true];   
        }
        else
        {
            return [select Id, Name, Part_Number__c, Cost__c, Sales_Price__c, Description__c, Service__c from Product__c where Product_Type__c = :productType and Service__c = true and active__c = true];   
        }
        
    }
    @AuraEnabled
    public static List<Product__c> ListProducService(String RecordId, Integer sType){
        //get homeService's recordType.
        Home_Services__c home =  [select RecordType.Name from Home_Services__c where id = :RecordId];
        //getting the recordType's name
        String productType = products(home.RecordType.Name);
        //getting the product by type
        List<Product__c> Products = ListServices(productType, sType);
        return Products;
    }
    
    /**
* method responsible to assign a line item to each service product
*/
    public static list<Line_Item__c> LineItemsServiceList(List<Product__c> Products, String homeServiceId){
        list<Line_Item__c> ServiceLineItems = new list<Line_Item__c>();
        //for each product in the list let's create a line item
        for(Product__c prod : Products){
            ServiceLineItems.add(
                new Line_Item__c(
                    Name = prod.Name, 
                    Product__c = prod.Id, 
                    Product__r=prod,
                    Home_Service__c = homeServiceId, 
                    Active__c = true,
                    Unit_Price__c=prod.Sales_Price__c,
                    Total_Sales_Price_p__c = prod.Sales_Price__c,
                    Quantity__c = 1
                )
            );
        }
        return ServiceLineItems;
    }
    public static list<Line_Item__c> LineItemsServiceList2(List<Product__c> Products, String homeServiceId){
        list<Line_Item__c> ServiceLineItems = new list<Line_Item__c>();
        //for each product in the list let's create a line item
        for(Product__c prod : Products){
            ServiceLineItems.add(
                new Line_Item__c(
                    Name = prod.Name, 
                    Product__c = prod.Id,
                    Product__r=prod,
                    Home_Service__c = homeServiceId, 
                    Active__c = true,
                    Unit_Price__c=prod.Sales_Price__c,
                    Monthly_Investment__c = prod.Sales_Price__c,
                    Quantity__c = 1
                )
            );
        }
        return ServiceLineItems;
    }
    /**
* method responsible for getting a line item list
*/
    @AuraEnabled
    public static list<Line_Item__c> ProductListToSelect(String  RecordId, Integer ProdType){
        //get homeService's recordType.
        Home_Services__c home =  [select RecordType.Name from Home_Services__c where id = :RecordId];
        //getting the recordType's name
        String productType = products(home.RecordType.Name);
        //getting the product by type
        List<Product__c> Products = ListServices(productType, ProdType);
        //assigning product to lineItems.
        list<Line_Item__c> LineItemProduct  = new list<Line_Item__c>();
        if(ProdType == 1){
            LineItemProduct  = LineItemsServiceList(Products, RecordId);
        }else{
            LineItemProduct  = LineItemsServiceList2(Products, RecordId);
        }
        //returning lineItems obtained
        return LineItemProduct;
    }
    /*
* method reponsible for gettin a product by Id
*/
    @AuraEnabled
    public static Product__c getProduct(string recordId){
        return [select Id, Cost__c, Sales_Price__c from Product__c where Id = :recordId ];
    }
    
    @AuraEnabled
    public static list<Line_Item__c> SaveRecordsLineItems(list<Line_Item__c> recordsJson){
        list<Line_Item__c> toDelete = new list<Line_Item__c>();
        list<Line_Item__c> toSave = new list<Line_Item__c>();
        
        for(Line_Item__c recordJson : recordsJson){
            if(recordJson.Active__c){
                toSave.add(recordJson); 
            }else{
                toDelete.add(recordJson); 
            }
        }
        if(!toDelete.isEmpty()){
            delete toDelete; 
        }
        if(!toSave.isEmpty()){
            upsert toSave;
        }
        
        return toSave;    
    }
    
    @AuraEnabled
    public static list<Line_Item__c> SavelineItemServices(list<Line_Item__c> records){
        upsert records;
        return records;
    }   
    
    @AuraEnabled
    public static list<Line_Item__c> changeDate(list<Line_Item__c> records){
        list<Line_Item__c> Tosave = new list<Line_Item__c>();
        list<Line_Item__c> Todelete = new list<Line_Item__c>();
        for(Line_Item__c record : records){
            if(record.Active__c){
                if(record.Bill_Start_Date__c == null){
                    record.Bill_Start_Date__c = Date.today().addDays(-1).addYears(1);
                }   
                Tosave.add(record);
            }else{
                Todelete.add(record); 
            }
        }
        
        if(!Todelete.isEmpty()){
            delete Todelete; 
        }
        if(!Tosave.isEmpty()){
            upsert Tosave;
        }
        return Tosave;
    }   
    
    
    @AuraEnabled
    public static list<Line_Item__c> getlineItems(String recordId, Integer option){
        if(option == 1){
            return [select Id, Name, Product__c, Product__r.Service__c,Product__r.Cost__c, Quantity__c, Home_Service__c,Total_Sales_Price_p__c,Unit_Price__c,Active__c 
                    from Line_Item__c 
                    where Product__r.Service__c = false and Home_Service__c = :recordId];
        }else{
            return [select Id, Name, Product__c, Product__r.Service__c,Product__r.Cost__c, Quantity__c, Home_Service__c,Total_Sales_Price_p__c,Unit_Price__c, Active__c, 
                    Monthly_Investment__c, Billing_Frequency__c, Bill_Start_Date__c 
                    from Line_Item__c 
                    where Product__r.Service__c = true and Home_Service__c = :recordId];
        }
        
    }
    
    /**
* This method is responsible for getting the Home services information to solar recordtype.
* 
* This method is used in:
*  the  products(RecordId) method of this class
* 
* @return home service's account
*/ 
    @AuraEnabled
    public static Home_Services__c getDataHomeOwner(String RecordId){
        Home_Services__c home =  [select Account__c, Account__r.LastName, Account__r.Phone,
                                  hoaPhoneNumber__c, Account__r.Street__c, Account__r.City__c, 
                                  Account__r.State__c, Account__r.Zip__c,
                                  Account__r.PersonEmail, Utility_Company__c, hoaName__c,
                                  Account__r.FirstName, Account__r.Homeowner_2_First_Name__c,
                                  Account__r.Homeowner_2_Last_Name__c
                                  from Home_Services__c where id = :RecordId];
        return home;
    }
    
    /**
* This method is responsible for saving Account Information.
* 
* This method is used in:
*  the  diacoContractHomeOwnerSolar.cmp helper
* 
* @return the Home services and Home_Services__c Updated/saved
*/ 
    @AuraEnabled
    public static Home_Services__c saveHomeOwner(Home_Services__c HomeService, Account account){
        upsert HomeService;
        upsert account;
        system.debug(account);
        return HomeService;
    }
    
    
    /**
* This method is responsible for getting all payment methods fields.
* 
* This method is used in:
*  the  diacoContractPaymentMethod.cmp helper
* 
* @return the Home services payment methods fields
*/
    @AuraEnabled
    public static Home_Services__c getPaymentMethods(String RecordId){
        Home_Services__c home =  [select Id, 
                                  /*Payment solar*/
                                  Balance_Due__c, FirstPayment__c, SecondPayment__c, ThirdPayment__c,
                                  /*products pay methods*/
                                  Method_Of_Payment__c,
                                  /*credit card field to fill*/
                                  Credit_Card_Type_System__c,Name_On_Card_System__c,Card_Number__c,last4numbers__c, Credit_Card_CSV__c,Expiration_Month__c, Expiration_Year__c,
                                  /*credit card field to show*/
                                  Card_Type__c, Name_on_Card__c, Account_Number__c, Card_Last_4__c, CSV__c, Card_Expiration_Month__c, Card_Expiration_Year__c,
                                  /*checking field to fill*/
                                  Bank_Account_Type_System__c, Bank_Account_Number__c, Bank_Account_Name_System__c, Bank_Name_System__c, Bank_Routing_Number__c, Check_Number__c,
                                  /*checking field to show*/
                                  Bank_Account_Type__c, Bank_Account_Number_Encrypted__c, Bank_Account_Name__c, Bank_Name__c, Routing_Number__c, Account_Number_Checking__c,
                                  /*finance field to fill and show*/
                                  Finance_Company__c, Financed_Amount__c,
                                  /*services pay methods*/
                                  Method_Of_Payment_Service_System__c,
                                  /*credit card field to fill*/
                                  Account_Number_Credit_Card_Service_Syste__c, Card_Expiration_Month_Service_System__c, Card_Expiration_Year_Service_System__c, Card_Last_4_Service_System__c,
                                  Card_Type_Service_System__c, Name_On_Card_Service_System__c, CSV_Service_System__c,
                                  /*checking field to fill*/
                                  Account_Number_Checking_Servicio_System__c, Bank_Account_Name_Service_System__c, Bank_Account_Type_Service_System__c, Bank_Account_Number_Servicio_System__c,
                                  Bank_Name_Service_System__c, Routing_Number_Service_System__c,
                                  /*credit card field to show*/
                                  Account_Number_Credit_Card_Service__c, Card_Expiration_Month_Service__c, Card_Expiration_Year_Service__c, Card_Last_4_Service__c, Card_Type_Service__c,
                                  Name_On_Card_Service__c, CSV_Service__c,
                                  /*checking field to show*/
                                  Account_Number_Checking_Service__c, Bank_Account_Name_Service__c, Bank_Account_Type_Service__c, Bank_Account_Number_Service__c, Bank_Name_Service__c, 
                                  Routing_Number_New__c,
                                  envelopeId__c, EnvelopeAgreeId__c
                                  from Home_Services__c where id = :RecordId];
        return home;
    }
    /**
* This method is responsible for sendcontract to docusign.
*
* 
* @return contract Id 
*/
    @AuraEnabled
    public static string sendToDocusign(String RecordId, Integer opt){
        docuSignConf__c conf = new docuSignConf__c();
        String envelopeId, userId, password, accountId, productType;
        List<docuSignConf__c> docusignconf = [select accountId__c, integratorsKey__c, password__c, userId__c, userIdSolar__c, account__c, passwordSolar__c,
                                              PassWord_Pest_Control__c, User_Id_Pest_Control__c
                                              from docuSignConf__c];
        SendToDocuSignController stdc =  new SendToDocuSignController();
        Home_Services__c homeService = [select Id,Name, Account__c, RecordType.Name from Home_Services__c where Id = :RecordId];
        productType = products(homeService.RecordType.Name);
        conf = docusignconf[0];
        accountId = conf.accountId__c;
        if(productType == 'Water'){
            userId = conf.userId__c;
            password = conf.password__c;
        }else if(productType == 'Solar'){
            userId = conf.userIdSolar__c;
            password = conf.passwordSolar__c;
        }else if(productType == 'Pest'){
            userId = conf.User_Id_Pest_Control__c;
            password = conf.PassWord_Pest_Control__c;
        }
        
        String integratorsKey = conf.integratorsKey__c;
        envelopeId = stdc.SendNow(productType, accountId, userId, password, integratorsKey, homeService, opt);
        return envelopeId ;
    }
    @AuraEnabled
    public static void updateDates(String RecordId){
        ContractsController cc =  new ContractsController();
        Home_Services__c homeService = [select Id, RecordType.Name from Home_Services__c where Id = :RecordId];
        String productType = products(homeService.RecordType.Name);
        List<Product__c> listService = cc.ListServices(productType, 2);
        List<Line_Item__c> listLine = cc.ListLIs(homeService.Id, listService);
        if(!listLine.isEmpty()){
            for(Line_Item__c pro : listLine){
                pro.Bill_Start_Date__c = Date.today().addYears(1).addDays(-1);
            }
            update listLine;
        }
    }
    @AuraEnabled
    public static String getCustomerAlarm(String RecordId){
        return [select Id from DiacoAlarm__Diaco_Customer_Alarm__c where Home_Service__c = :RecordId LIMIT 1].Id;
    }
    /**
* 
* This method is responsible for getting home service id.
* 
* This method is used in:
*  the  diacoContractFromEvent.cmp helper
*  
* 
* @param RecordId is the Event Id controller
* @return HomeService Id
*/ 
    @AuraEnabled
    public static String getRecordId(String RecordId){
        return [select WhatId from Event where Id =: RecordId].WhatId;
    }
    
    /**
    * 
    * This method is responsible for getting record types.
    * 
    * This method is used in:
    *  the  diacoCntToSellers.cmp helper
    *  
    * 
    * @return record type list
    */ 
    @AuraEnabled
    public static List<RecordType> getRecordTypes(){
        /*return [Select Id, Name 
                FROM RecordType 
                WHERE Name LIKE '%Sales%' AND  sObjectType = 'Home_Services__c'];
        */
        return [Select Id, Name 
                FROM RecordType 
                WHERE Name LIKE '%Sales%' AND (Name LIKE '%Water%' OR Name LIKE '%Solar%' /*OR Name LIKE '%Home%'*/ OR Name LIKE '%Pest%' /*OR Name LIKE '%Window%'*/ ) AND  sObjectType = 'Home_Services__c'];
        
    }
    
    /**
    * 
    * This method is responsible for getting Home services.
    * 
    * This method is used in:
    *  the  diacoCntToSellers.cmp helper
    *  
    * 
    * @param RecordId is the account Id controller
    * @return HomeServices list
    */ 
    @AuraEnabled
    public static List<Home_Services__C> getHsFromAccount(String recordId){
        return [select Id, Name, RecordType.Name 
                from Home_Services__C 
                where Account__c = :recordId];
    }
    /**
    * This method is responsible for saving homes service Information.
    * 
    * This method is used in:
    *  the  diacoCntToSellers.cmp helper
    * 
    * 
    * @param Home_Services is the Home Service to save
    * @return the home service list
    */ 
    @AuraEnabled
    public static Home_Services__c saveHomeServiceInfo(Home_Services__c Home_Services){
        Home_Services.ApptSetter__c = [select Id, Name from Personnel__c where SF_User__c = :UserInfo.getUserId() LIMIT 1].Id;
        upsert Home_Services;
        return [select Id, Name, RecordType.Name 
                from Home_Services__C 
                where Id = :Home_Services.Id];
    }
    
    /**
    * 
    * This method is responsible for getting Account Home services.
    * 
    * This method is used in:
    *  the  diacoCntToSellers.cmp helper
    *  
    * 
    * @param RecordId is the Event or home service id controller
    * @return HomeServices list
    */ 
    @AuraEnabled
    public static String getHsAccountFromAnotherObject(String recordId){
        
        String AccountId = '';
        List<Event> events = [Select Id, Name__c, WhatId from Event where Id = :recordId];
        if(!events.isEmpty()){
            List<Home_Services__c> Home_Service = [Select Id, Name, Account__c from Home_Services__c where Id = :events[0].WhatId];
            AccountId = Home_Service[0].Account__c;
        }else{
            List<Home_Services__c> Home_Services = [Select Id, Name, Account__c from Home_Services__c where Id = :recordId ];
            AccountId = Home_Services[0].Account__c;
        }
        
        return AccountId;
    }
    
    @AuraEnabled
    public static String getHSContract(String recordId){
        Event event =[Select Id, Home_Service__c, WhatId from Event where Id = :recordId];
        String result = '';
        if(event.Home_Service__c !=null){
            result = event.Home_Service__c;
        }else if(event.WhatId.getSObjectType().getDescribe().getName() == 'Home_Service__c'){
            result = event.WhatId;
        }
        
        return result;
    }

    /**
     * For a given input Home_Services__c or Event record ID, returns a Home_Services__c's ID and its record type.
     * 
     * If the input ID is a Home_Services__c ID, then this ID is returned. If the input ID is an Event ID, then
     * the ID of the Home_Services__c associated with the Event is returned. In both cases, the record type of
     * the Home_Services__c is also returned.
     * 
     * The first element in the returned array is always a Home_Services__c ID or null.
     * The second element in the returned array is always a Home_Services__c record type or null.
     * 
     * For well over a year, the Aura Component Bundle "diacoContract" has used this controller's getRecordType
     * method assuming its input record ID is always a Home_Services__c ID. This method was created to add support
     * for Event IDs to said component.
     */
    @AuraEnabled
    public static List<String> getRecordInfo(String recordId) {
        List<String> output = new List<String>{null, null};

        if (recordId != null && recordId.trim().length() > 0) {
            Id rId = (Id) recordId;
            String oType = rId.getSobjectType().getDescribe().getLocalName();

            if (oType == 'Home_Services__c') {
                output[0] = recordId;
                output[1] = getRecordType(recordId);
            } else if (oType == 'Event') {
                List<Event> e = [SELECT Home_Service__c FROM Event WHERE Id = :recordId LIMIT 1];

                if (e != null && e.size() > 0 && e[0].Home_Service__c != null) {
                    output[0] = e[0].Home_Service__c;
                    output[1] = getRecordType(e[0].Home_Service__c);
                }
            }
        }

        //System.debug(output);
        return output;
    }
}