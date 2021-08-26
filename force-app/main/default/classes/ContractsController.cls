/**
* Diaco
* @author 			Jorge Andres Martinez Peña href=<Jorgeality29@gmail.com>
* Project:			Contracts
* Description:		Class responsible of implement methods for handler user interface.
*					
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		23/07/2018		Jorge Martinez (JM)		Initial implementation  of the class.
**/

public class ContractsController {
    
    public Account acct{get; set;}
	public String installationDay{get; set;}
    public String installationHour{get; set;}
    public String Description{get; set;}
    public String IdUser{get; set;}
    public String productType{get; set;}
    public String IdEvent{get; set;}
    public String IdtoServiceLineItems{get; set;}
    public String IdtoLineItems{get; set;}
    public String customer1Day{get; set;}
    public String customer1Month{get; set;}
    public String customer1Year{get; set;}
    public String customer2Day{get; set;}
    public String customer2Month{get; set;}
    public String customer2Year{get; set;}
    public String customer1Day_Dli{get; set;}
    public String customer1Month_Dli{get; set;}
    public String customer1Year_Dli{get; set;}
    public String customer2Day_Dli{get; set;}
    public String customer2Month_Dli{get; set;}
    public String customer2Year_Dli{get; set;}
    public String[] months = new String[]{'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'};
	public String customer1Day_Dle{get; set;}
    public String customer1Month_Dle{get; set;}
    public String customer1Year_Dle{get; set;}
    public String customer2Day_Dle{get; set;}
    public String customer2Month_Dle{get; set;}
    public String customer2Year_Dle{get; set;}
    public String PayMethod{get; set;}
    public String ExpMonth{get; set;}
    public String ExpYear{get; set;}
    public String AccountNumber{get; set;}
    public String billing{get;set;}
    
    public String Water{get;set;}
    public Boolean waterb{get;set;}
    public Boolean Solarb{get;set;}
    public String Solar{get;set;}   
    public String envelopeId{get;set;}
    public String show{get;set;}
    public String show2{get;set;}
    public String classCss{get;set;}
    
    public String ConsultantName{get;set;}
    //PayMethod
    Public Home_Services__c homeService{get; set;}
    public Line_Item__c LineItem{get; set;}
    public List<Product__c> Products{get; set;}
    public List<Product__c> ServiceProducts{get; set;}
    public List<Line_Item__c> LineItems{get; set;}
    public List<Line_Item__c> toLineItems{get; set;}
    public List<Line_Item__c> ServiceLineItems{get; set;}
    public List<Line_Item__c> toServiceLineItems{get; set;}
    Public List<User> users{get; set;}
    Public List<Event> eventList{get; set;}
    
    public String CreditCard{get;set;}
    public String Checking{get;set;}
    public String Check{get;set;}
    public String Finance{get;set;}
    public String Lease{get;set;}
    public String ACH{get;set;}
    public String title{get;set;}
        
    public Installation__c installation{get;set;}
    
    
    
    public String creditCardType{get;set;}
    public String creditCardnumber{get;set;}
    public String creditCardCsv{get;set;}
    public String creditCardMonth{get;set;}
    public String creditCardYear{get;set;}
    
    public String BankName{get;set;}
    public String BankAccountType{get;set;}
    public String BankAccountName{get;set;}
    public String BankAccountNumber{get;set;}
    public String BankRoutingNumber{get;set;}
    public String CheckNumber{get;set;}
    
    /**
     * Constructor of de class
     * 
     * @param controller home service received by url. toLineItems
     */
    public ContractsController(){}
    public ContractsController(ApexPages.StandardController controller){       
        this.LineItem = new Line_Item__c();
        this.LineItems = new List<Line_Item__c>();
        ServiceLineItems = new List<Line_Item__c>();
        users = [select Id, Name from User]; 
        acct = new Account();
        toLineItems = new List<Line_Item__c>();
        toServiceLineItems = new List<Line_Item__c>();
        this.eventList = new List<Event>();
        Home_Services__c homeServices = (Home_Services__c)controller.getRecord();
        String id = ApexPages.currentPage().getParameters().get('id');
        Hs(homeServices.Id);
        if(homeService.envelopeId__c != null && homeService.envelopeId__c != ''){
            envelopeId = homeService.envelopeId__c;
            show2 = 'none';
            show = 'block';
        }else{
            envelopeId = 'this contract has not been sent yet!';
            show = 'none';
            show2 = 'block';
        }
        productType = products(homeService.RecordTypeId);
        Products =  ListServices(productType, 1);
        ServiceProducts = ListServices(productType, 2);
        LineItemsServiceList();
        Installation__c install  = IntallationObject();
        if(install != null ){
            installation = install;
        }else {
            installation =  new Installation__c();
        }
        Acct();
        
        if(this.acct.Customer_1_DOB__c != null){
            customer1Day = ''+this.acct.Customer_1_DOB__c.day();
            customer1Month = months[this.acct.Customer_1_DOB__c.month() -1];
            customer1Year = ''+this.acct.Customer_1_DOB__c.year();
        }
        if(this.acct.Customer_2_DOB__c != null){
            customer2Day = ''+this.acct.Customer_2_DOB__c.day();
            customer2Month = months[this.acct.Customer_2_DOB__c.month() -1];
            customer2Year = ''+this.acct.Customer_2_DOB__c.year();
        }
        
        if(this.acct.Customer_1_Drivers_License_Issue_Date__c != null){
            customer1Day_Dli = ''+this.acct.Customer_1_Drivers_License_Issue_Date__c.day();
            customer1Month_Dli = months[this.acct.Customer_1_Drivers_License_Issue_Date__c.month() -1];
            customer1Year_Dli = ''+this.acct.Customer_1_Drivers_License_Issue_Date__c.year();
        }
        if(this.acct.Customer_2_Drivers_License_Issue__c != null){
            customer2Day_Dli = ''+this.acct.Customer_2_Drivers_License_Issue__c.day();
            customer2Month_Dli = months[this.acct.Customer_2_Drivers_License_Issue__c.month() -1];
            customer2Year_Dli = ''+this.acct.Customer_2_Drivers_License_Issue__c.year();
        }
        
        if(this.acct.Customer_1_Drivers_License_Expiration__c != null){
            customer1Day_Dle = ''+this.acct.Customer_1_Drivers_License_Expiration__c.day();
            customer1Month_Dle = months[this.acct.Customer_1_Drivers_License_Expiration__c.month() -1];
            customer1Year_Dle = ''+this.acct.Customer_1_Drivers_License_Expiration__c.year();
        }
        if(this.acct.Customer_2_Drivers_License_Expiration__c != null){
            customer2Day_Dle = ''+this.acct.Customer_2_Drivers_License_Expiration__c.day();
            customer2Month_Dle = months[this.acct.Customer_2_Drivers_License_Expiration__c.month() -1];
            customer2Year_Dle = ''+this.acct.Customer_2_Drivers_License_Expiration__c.year();
        }
        
        if(ListLI(this.homeService.Id,1).size() > 0 ){
            toLineItems = ListLI(this.homeService.Id,1);
            for(Line_Item__c li : toLineItems){
                if(li.Total_Sales_Price_p__c == null){
                    li.Total_Sales_Price_p__c = li.Sales_Price__c;
                }
            }
        }
        if(ListLIs(this.homeService.Id, ServiceProducts).size() > 0 ){
            toServiceLineItems = ListLIs(this.homeService.Id, ServiceProducts);
            billing = toServiceLineItems[0].Billing_Frequency__c;
            for(Line_Item__c li : toServiceLineItems){
                if(li.Total_Sales_Price_p__c == null){
                    li.Total_Sales_Price_p__c = li.Sales_Price__c;
                }
            }
        }
        
        if(homeService.Requested_Install_Date__c != null){
            
            dateSaved(dateTimeFrom(homeService.Requested_Install_Date__c));
        }
        LineItemsList();
        //'Water','Home Automation','Solar','Window'
        
        if(productType == 'Water'){
            Water = 'block';
            Solar = 'none';
            waterb = true;
            Solarb = false;
            classCss = 'input-field col s12 m12 l12';
        }else if(productType == 'Solar'){
            Water = 'none';
            Solar = 'block';
            waterb = false;
            Solarb = true;
            classCss = 'input-field col s12 m6 l6';
        }
        
        title = 'none';
        CreditCard = 'none';
        Checking = 'none';
        Check = 'none';
        Finance = 'none';
        Lease = 'none';
        ACH = 'none';
        if(homeService.Method_Of_Payment__c != null || homeService.Method_Of_Payment__c != '' ){
            PayMethod = homeService.Method_Of_Payment__c;
            title = 'block';
            if(PayMethod == 'Checking'){
                Checking = 'block';
            }else if(PayMethod == 'Check'){
                Check = 'block';
            }else if(PayMethod == 'Finance'){
                Finance = 'block';
            }else if(PayMethod == 'Lease'){
                Lease = 'block';
            }else if(PayMethod == 'ACH'){
                ACH = 'block';
            }else if(PayMethod =='Credit Card'){
                CreditCard = 'block';
            }
            if(Solar  == 'block'){
                Check = 'block';
            }else if(Water == 'block'){
                Checking = 'block';
            } 
        }
        if(homeService.firstTime__c == false){
            acct.Billing_Address_Same_As_Service_Address__c  = true;
            acct.Primary_Billing_State__c = acct.State__c;
            acct.Primary_Billing_City__c = acct.City__c;
            acct.Primary_Billing_Street__c = acct.Street__c;
            acct.Primary_Billing_Zip_Code__c = acct.Zip__c;
            homeService.firstTime__c = true;
        }
        
    }
    
    public Installation__c IntallationObject(){
        //homeService installation.Requested_Install_Date__c
        List<Installation__c> installs = [select Id, Requested_Install_Date__c, Sales_Rep__c, Home_Service__c from Installation__c where Home_Service__c = :homeService.Id]; 
        if(installs.isEmpty()){
            return null;
        }else{
            return installs[0];
        }
    }
    
    public List<Product__c> ListServices(String productType, Integer stype){
        if(stype == 1)
        {
            return [select Id, Name, Part_Number__c, Cost__c, Sales_Price__c, Description__c, Service__c from Product__c where Product_Type__c = :productType and Service__c = false and active__c = true];   
        }
        else
        {
            return [select Id, Name, Part_Number__c, Cost__c, Sales_Price__c, Description__c, Service__c from Product__c where Product_Type__c = :productType and Service__c = true and active__c = true];   
        }
        
    }
    
    
    /**
     * method responsible to get all homeservice's events
     * 
     * @return a event list existings in the home service.
     */
   /* public List<Event> EvntList(){
        return [select Id, Subject, Description, StartDateTime, EndDateTime, OwnerId from Event where (WhatId = :this.homeService.Id and RecordTypeId = '012410000013G9AAAU')];
    }*/
    
    /**
     * method responsible to assign a line item to each installation product
     */
    public void LineItemsList(){
        for(Product__c prod : Products){
            LineItem.Name = prod.Name;
           	LineItem.Product__c = prod.Id;
            LineItem.Home_Service__c = homeService.Id;
            this.LineItems.add(LineItem);
            this.LineItem = new Line_Item__c();
        }
    }
    
    
    /**
     * method responsible to assign a line item to each service product
     */
    public void LineItemsServiceList(){
        Line_Item__c LineItem = new Line_Item__c();
        for(Product__c prod : ServiceProducts){
            LineItem.Name = prod.Name;
           	LineItem.Product__c = prod.Id;
            LineItem.Home_Service__c = homeService.Id;
            this.ServiceLineItems.add(LineItem);
            LineItem = new Line_Item__c();
        }
        system.debug('ServiceLineItems : ' + ServiceLineItems);
    }
    
    /**
     * method responsible to get the account linked to the Homeservice
     */
    public void Acct(){
        this.acct =[select Id, AcctFirstName__c,
                        AcctLastName__c,
                        Customer_1_SSN_E__c,
                        Customer_1_Drivers_License__c,
                        Phone, PersonEmail,Customer_1_DOB__c, Customer_2_DOB__c,
                        Customer_1_Employer__c, Customer_1_Employer_Phone__c,	Fax,
                        Customer_1_Income__c, Customer_1_Length_of_Employment__c, Billing_Email__c, Billing_Fax__c,
                        Customer_1_Employment_Position__c, Homeowner_2_First_Name__c,Billing_First_Name__c,Billing_Company__c, Billing_Phone__c,
                        Homeowner_2_Last_Name__c, Customer_2_SSN__c, Customer_2_Drivers_License__c, Billing_Information_From__c, Billing_Last_Name__c,
                        Homeowner_2_Phone_Number__c, PersonMobilePhone, Homeowner_2_Email__c, Customer_2_Employer__c, Customer_2_Employer_Phone__c,
                        Customer_2_Income__c, Customer_2_Length_of_Employment__c, Customer_2_Employment_Position__c, State__c, City__c, Street__c,Zip__c,
                        Mortgage_Payment__c, Billing_Address_Same_As_Service_Address__c, Primary_Billing_State__c, Primary_Billing_City__c, Primary_Billing_Street__c,
                    	Primary_Billing_Zip_Code__c, Drivers_license_Issuing_state_2__c, Drivers_license_Issuing_state_1__c,
                    	Customer_1_Drivers_License_Issue_Date__c, Customer_2_Drivers_License_Issue__c, Customer_2_Drivers_License_Expiration__c,
                    	Customer_1_Drivers_License_Expiration__c, Homeowner_2_Mobile__c
                   from Account
                   where Id = :this.homeService.Account__c];
    } 
    
    /**
     * method responsible to get the home service with which we are going to work.
     * 
     * @param idS id of the home service received by url.
     */
    
    public void Hs(String idS){
        this.homeService = [select Id, RecordTypeId	,Card_Type__c, Card_Number__c,Card_Expiration_Month__c, Card_Expiration_Year__c, Card_Last_4__c,
                            	   Name,Requested_Install_Date__c,Installation_Status__c, Appt_Instalation_Status__c,
                            	   Account__c,Lead_Source__c, checkAmount__c, checkNumber__c, Utility_Company__c,Expiration_Month__c, Expiration_Year__c,
                                   Sales_Rep__c,  Routing_Number__c, Exp_Date__c, Account_Number_Checking__c,Credit_Card_CSV__c,
                                   Total_Cash_Selling_Price__c, Finance_Company__c, Financed_Amount__c,hoaName__c,
                                   Sales_Tax__c, Total_Cash_Price__c, Account_Number__c, CSV__c, cardName__c,hoaPhoneNumber__c,
                                   Down_Payment__c, Total_Down_Payment__c, Method_Of_Payment__c, Name_on_Card__c,last4numbers__c,
                                   Trade_in_Allowance__c, Balance_Due__c,Ph__c, Hardness_gpg__c, Iron_Algae__c,Iron_ppm__c,
                            	   Hyd_Supl_ppm__c, No_Reg__c, Other__c, Special_Instructions__c, Total_Monthly_Investment__c, 
                            	   FirstPayment__c, SecondPayment__c, ThirdPayment__c,firstTime__c,Credit_Card_Type_System__c, envelopeId__c,
                            	   Bank_Account_Type__c, Bank_Account_Number__c, Bank_Routing_Number__c, Bank_Account_Name__c, Check_Number__c, Bank_Name__c,
                                   Bank_Account_Type_System__c, Bank_Account_Name_System__c,Bank_Name_System__c, Bank_Account_Number_Encrypted__c  
                            from Home_Services__c 
                            where Id = :idS];
    } 
    
    /**
     * method responsible to get all homeservice's lineItems
     * 
     * @return a lineItems list existings in the home service.
     */
    
    public List<Line_Item__c> ListLI(String hsI, Integer option){
        /**/
        List<Line_Item__c> lItems = new List<Line_Item__c>();
        if(option == 1){
            
            List<Line_Item__c> lines = [select Id, Name, Home_Service__c, Part_Number__c, Product__c, Quantity__c, Sales_Price__c, Total_Cost__c, 
                                        Total_Sales_Price_p__c, Bill_Start_Date__c, Billing_Frequency__c, Monthly_Investment__c, Bill_SD__c, Service_Check__c
                                        from Line_Item__c 
                                        where Line_Item__c.Home_Service__c = :hsI];
            for(Line_Item__c line : lines){
                for(Product__c prod : Products){
                    if(line.Product__c == prod.Id){
                        lItems.add(line);  
                    }
                }
            }
        }else{
            lItems =  [select Id, Name, Home_Service__c, Part_Number__c, Product__c, Quantity__c, Sales_Price__c, Total_Cost__c, 
                       Total_Sales_Price_p__c, Bill_Start_Date__c, Billing_Frequency__c, Monthly_Investment__c, Bill_SD__c, Service_Check__c
                       from Line_Item__c 
                       where Line_Item__c.Home_Service__c = :hsI];
        }
        return lItems;
    }
    
    /**
     * method responsible to assign a service product to a lineItem
     * 
     * @return a lineItems list with service product.
     */
    
    public List<Line_Item__c> ListLIs(String hsI, List<Product__c> ServiceProduct){
        List<Line_Item__c> listlir = new List<Line_Item__c>();
        for(Line_Item__c li : ListLI(hsI, 2)){
            for(Product__c p : ServiceProduct){
                if(li.Product__c == p.Id && p.Service__c == true){
                        listlir.add(li);
                }
            }
        }
        
        return listlir;
    }
	
    /**
     * method responsible to update the account of the homeservice
     *
     */

    
    public void upaccocunt(){
        update this.acct;
    }
    
    /**
     * method responsible to update the account of the homeservice
     *
     */
    
    public void print(){
        
        if(customer1Month != null && customer1Day != null && customer1Year != null ){
            this.acct.Customer_1_DOB__c = Mydatein(customer1Month+' '+customer1Day+', '+customer1Year);
        }
		if(customer2Month != null && customer2Day != null && customer2Year != null ){
            this.acct.Customer_2_DOB__c = Mydatein(customer2Month+' '+customer2Day+', '+customer2Year);
        } 
        
        
        if(customer1Month_Dli != null && customer1Day_Dli != null && customer1Year_Dli != null ){
            this.acct.Customer_1_Drivers_License_Issue_Date__c = Mydatein(customer1Month_Dli+' '+customer1Day_Dli+', '+customer1Year_Dli);
        }
		if(customer2Month_Dli != null && customer2Day_Dli != null && customer2Year_Dli != null ){
            this.acct.Customer_2_Drivers_License_Issue__c = Mydatein(customer2Month_Dli+' '+customer2Day_Dli+', '+customer2Year_Dli);
        }
        
        
        
        if(customer1Month_Dle != null && customer1Day_Dle != null && customer1Year_Dle != null ){
            this.acct.Customer_1_Drivers_License_Expiration__c = Mydatein(customer1Month_Dle+' '+customer1Day_Dle+', '+customer1Year_Dle);
        }
		if(customer2Month_Dle != null && customer2Day_Dle != null && customer2Year_Dle != null ){
            this.acct.Customer_2_Drivers_License_Expiration__c = Mydatein(customer2Month_Dle+' '+customer2Day_Dle+', '+customer2Year_Dle);
        }
        
        acct.Homeowner_2_First_Name__c = acct.Homeowner_2_First_Name__c;
        acct.Homeowner_2_Last_Name__c = acct.Homeowner_2_Last_Name__c;
        acct.Homeowner_2_Phone_Number__c = acct.Homeowner_2_Phone_Number__c;
        acct.Homeowner_2_Email__c = acct.Homeowner_2_Email__c;
        system.debug(acct);
        update this.acct;
        system.debug(acct);
        update homeService;
    }   
    
    /**
     * method responsible to receive two strings and return a datetime
     * 
     * @param DateIn date received
     * @param HourIn hour received
     * 
     * @return a dateTime
     *
     */
    
    public  DateTime Mydate(String DateIn, String HourIn){
        List<String> res = DateIn.split(' ');
        List<String> res2 = HourIn.split(' ');
        List<String> res3 = res2[0].split(':');
        Integer hour = integer.valueof(res3[0]);
        Integer month = 0;  
        
        for(Integer i = 0; i < this.months.size(); i++ ){
            if(res[0] == this.months[i]){
                 month = (1 + i);
                 break;
             }  
        }
        
        if(res2[1] == 'PM') {
            hour = integer.valueof(res3[0]) + 12;
        }
        DateTime myDateTime = DateTime.newInstance(integer.valueof(res[2]), month, integer.valueof(res[1].replace(',', '')), hour, integer.valueof(res3[1]), 0);
        return myDateTime;
    }
    
    /**
     * method responsible to receive a strings and return a date.
     * 
     * @param DateIn date received
     * 
     * @return a dateTime
     *
     */
    
    public  Date Mydatein(String DateIn){
        
        List<String> res = DateIn.split(' ');
        
        
        Integer month = 0;  
        
        for(Integer i = 0; i < this.months.size(); i++ ){
            if(res[0] == this.months[i]){
                 month = (1 + i);
                 break;
             }  
        }
        Date myDateTime = Date.newInstance(integer.valueof(res[2]), month, integer.valueof(res[1].replace(',', '')));
        return myDateTime;
    }
    
     /**
     * method responsible to save events
     */
    
    public void SaveEvent(){
        if(installationDay != null && installationDay != '' && installationHour != null && installationHour != '' && installationHour != '' && installationHour != null){
            DateTime StartHour = Mydate(installationDay, installationHour);
            homeService.Requested_Install_Date__c = StartHour;
            //system.debug(installation);
            upsert homeService;
            
        }
        
    }
    
    
    /**
     * method responsible to change the sales rep of the home service and update the homeservice
     * 
     */
    
    public void useUSer(){
       
        User user ;
        for(User p : users){
            if(p.Id == IdUser ){
                user = p;
            }
        }
        homeService.Sales_Rep__c = user.Id;
    }
    
    /**
     * method responsible to save lineitem with installation product
     * 
     */
    
    public void SaveLineItem(){
        this.LineItem.Home_Service__c = homeService.Id;
        insert this.LineItem;
        this.LineItem = new Line_Item__c();
        LineItems = ListLI(this.homeService.Id,1);
        Hs(homeService.Id);
    }
    
    /**
     * method responsible to return the product type.
     * 
     * @param name name of the home service
     * 
     * @return product type
     * 
     */
    
    public String products(String RecordTypeId){
        //'Water','Home Automation','Solar','Window'
        String [] Hse =new String[]{'Water','Home','Solar','Window'};
        system.debug('name record : ' +getNameFromRecordType(RecordTypeId) );
        List<String> res = getNameFromRecordType(RecordTypeId).split(' ');
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
        return sd;
    }
    
    /**
     * method responsible to save the line item with installation products.
     * 
     */
    
    
    public void Pprod(){
        toLineItems = new List<Line_Item__c>();
        for(Line_Item__c li : LineItems){
            if(li.Quantity__c > 0){
                toLineItems.add(li);
            }
        }
        if(toLineItems.size() > 0){
           insert  toLineItems;
           toLineItems = ListLI(this.homeService.Id,1);
            for(Line_Item__c li : toLineItems){
                if(li.Total_Sales_Price_p__c == null){
                    li.Total_Sales_Price_p__c = li.Sales_Price__c;  
                }
            }
           
        }
        LineItems = new List<Line_Item__c>();
        LineItemsList();
        
    }
    
    
     /**
     * method responsible to save the line item with Service products.
     * 
     */
    public void Pprod2(){
        toServiceLineItems = new List<Line_Item__c>();
        for(Line_Item__c li : ServiceLineItems){
            if(li.Service_Check__c == true){
                li.Quantity__c = 1;
                toServiceLineItems.add(li);
            }
        }
        if(toServiceLineItems.size() > 0){
           insert  toServiceLineItems;
           toServiceLineItems = ListLIs(this.homeService.Id, ServiceProducts);
            for(Line_Item__c li : toServiceLineItems){
                if(li.Total_Sales_Price_p__c == null){
                    li.Total_Sales_Price_p__c = li.Sales_Price__c; 
                    li.Monthly_Investment__c = li.Sales_Price__c;
                }
            }
           update  toServiceLineItems;
        }
        ServiceLineItems = new List<Line_Item__c>();
        LineItemsServiceList();
        
    }
    
    /**
     * method responsible to update the line item with installation products.
     * 
     */
    
    public void SaveLineItems(){
        if(toLineItems.size() > 0){
            update toLineItems;
            Hs(homeService.Id);
        }
        
    }
    
    /**
     * method responsible to update the line item with Service products.
     * 
     */
    
    public void SaveLineItemsservice(){
        
        if(toServiceLineItems.size() > 0){
            update toServiceLineItems;
        }
        Hs(homeService.Id);
        System.debug('total: '+homeService.Total_Monthly_Investment__c);
        
    }
    
    /**
     * method responsible to update the homeservice.
     * 
     */
    
    Public void SaveHomeService(){
        update homeService;
        Hs(homeService.Id);
    }
    
    /**
     * method responsible to delete a lineItem with a service producto from a list by id
     * 
     */
    
    public void DeleteLIS(){
        
        Line_Item__c item ;
        for(Line_Item__c p : toServiceLineItems){
            if(p.Id == IdtoServiceLineItems ){
                item = p;
            }
        }
        if(item != null){
            delete item;
            this.toServiceLineItems = ListLIs(this.homeService.Id, ServiceProducts);
            for(Line_Item__c li : toServiceLineItems){
                if(li.Total_Sales_Price_p__c == null){
                    li.Total_Sales_Price_p__c = li.Sales_Price__c;
                }
            }
        }
    } 
    
    /**
     * method responsible to delete a lineItem with a Installation producto from a list by id
     * 
     */
    
    public void DeleteLI(){
        
        Line_Item__c item ;
        for(Line_Item__c p : toLineItems){
            if(p.Id == IdtoLineItems ){
                item = p;
            }
        }
        if(item != null){
            delete item;
            this.toLineItems = ListLI(this.homeService.Id,1);
            for(Line_Item__c li : toServiceLineItems){
                if(li.Total_Sales_Price_p__c == null){
                    li.Total_Sales_Price_p__c = li.Sales_Price__c;
                }
            }
        }
    }  
    

    /**
     * method responsible to update the lineitem services (bill start date)
     * 
     */
    
    public void SaveHSService(){
        if(toServiceLineItems.size() > 0){
            for(Line_Item__c l : toServiceLineItems ){
                if(l.Bill_SD__c != null){
                    l.Bill_Start_Date__c = Mydatein(l.Bill_SD__c);
                }
            }
            update toServiceLineItems;
        } 
    }
    
    /**
     * method responsible to generate a list of selectOption with the months of the year 
     * 
     * 
     * @return a list with all months
     */
    
    public List<SelectOption> getmonthList() {
        List<SelectOption> options = new List<SelectOption>();
        for(String month : this.months){
            options.add(new SelectOption(month,month));
        }
        return options;
    }
    
    /**
     * method responsible to generate a list of selectOption with the days of the month 
     * 
     * 
     * @return a list with 31 days 
     */
    
    public List<SelectOption> getDayList() {
        List<SelectOption> options = new List<SelectOption>();
        for(Integer i = 1; i < 32; i++){
            options.add(new SelectOption(''+i,''+i));
        }
        return options;
    }
    
    /**
     * method responsible to generate a list of selectOption with a range of year. 
     * 
     * @return a list with year since 1940 until this year less one
     */
    
    public List<SelectOption> getYearList() {
        List<SelectOption> options = new List<SelectOption>();
        for(Integer i = Date.today().addYears(12).year() ; i >= 1940 ; i--){
            options.add(new SelectOption(''+i,''+i));
        } 
        return options;
    }
    
    
    /**
     * method responsible to generate the Bill_Start_Date__c date. 
     * 
     * 
     */
    public void test(){
        if(billing == null ){
            for(Line_Item__c d: toServiceLineItems){
                if(d.Bill_Start_Date__c == null && d.Billing_Frequency__c != null){
                    billing = d.Billing_Frequency__c;
                }
            }
        }else{
            for(Line_Item__c d: toServiceLineItems){
                if(d.Billing_Frequency__c != billing){
                    billing = d.Billing_Frequency__c;
                    break;
                }
            }
        }
        for(Line_Item__c d: toServiceLineItems){
                d.Billing_Frequency__c = billing;
                d.Bill_Start_Date__c = Date.today().addYears(1).addDays(-1);
        }
    }
    /**
     * method responsible to put Billing Address Same As Service Address an update the account. 
     * 
     * 
     *
    
    public void Baddress(){
        
        if(acct.Billing_Address_Same_As_Service_Address__c == true ){
            acct.Primary_Billing_State__c = acct.State__c;
            acct.Primary_Billing_City__c = acct.City__c;
            acct.Primary_Billing_Street__c = acct.Street__c;
            acct.Primary_Billing_Zip_Code__c = acct.Zip__c;
            
        }else{
            acct.Primary_Billing_State__c = '';
            acct.Primary_Billing_City__c = '';
            acct.Primary_Billing_Street__c = '';
            acct.Primary_Billing_Zip_Code__c = '';
        }
        update acct;
    }*/
    
    public List<SelectOption> getMethods() {
        
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('--None--','--None--'));
        options.add(new SelectOption('Credit Card','Credit Card'));
        options.add(new SelectOption('Checking','Checking'));
        options.add(new SelectOption('Finance','Finance'));
        return options;
    }
    public List<SelectOption> getCards() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--None--'));
        options.add(new SelectOption('Visa','Visa'));
        options.add(new SelectOption('Mastercard','Mastercard'));
        options.add(new SelectOption('Discover','Discover'));
        options.add(new SelectOption('American Express','American Express'));
        options.add(new SelectOption('MC Eurocard','MC Eurocard'));
        options.add(new SelectOption('UK Maestro','UK Maestro'));
        options.add(new SelectOption('JCB Card','JCB Card'));
        options.add(new SelectOption('Diners Club','Diners Club'));
        return options;
    }
    public List<SelectOption> getpayMethods() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('--None--','--None--'));
        options.add(new SelectOption('Credit Card','Credit Card'));
        options.add(new SelectOption('Finance','Finance'));
        options.add(new SelectOption('Lease','Lease'));
        options.add(new SelectOption('ACH','ACH'));
        options.add(new SelectOption('Check','Check'));
       
         
        return options;
    }
    
    public List<SelectOption> getAccountType() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--None--'));
        options.add(new SelectOption('Checking','Checking'));
        options.add(new SelectOption('Savings','Savings'));
        options.add(new SelectOption('Business Checking','Business Checking'));
        return options;
    }
    public List<SelectOption> getextra() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('--None--','--None--'));
        return options;
    }
    
    public void paymentMethod(){
        if(PayMethod != '--None--'){
            homeService.Method_Of_Payment__c = PayMethod; 
            if(creditCardType != null && creditCardType != ''){
                homeService.Credit_Card_Type_System__c = creditCardType;
            }
            if(creditCardnumber != null && creditCardnumber != ''){
                homeService.Card_Number__c = creditCardnumber;
                homeService.last4numbers__c = creditCardnumber.substring(creditCardnumber.length()-4,creditCardnumber.length());
            }
            if(creditCardCsv != null && creditCardCsv != ''){
                homeService.Credit_Card_CSV__c = creditCardCsv;
            }
            if(creditCardMonth != null && creditCardMonth != ''){
                homeService.Expiration_Month__c = creditCardMonth;
            }
            if(creditCardYear != null && creditCardYear != ''){
                homeService.Expiration_Year__c = creditCardYear;
                
            }
            
            if(BankName != null && BankName != ''){
                homeService.Bank_Name_System__c = BankName;
            }
            if(BankAccountType != null && BankAccountType != ''){
                homeService.Bank_Account_Type_System__c = BankAccountType;
            }
            if(BankAccountName != null && BankAccountName!= ''){
                homeService.Bank_Account_Name_System__c = BankAccountName;
            }
            if(BankAccountNumber != null && BankAccountNumber != ''){
                homeService.Bank_Account_Number__c = BankAccountNumber;
            }
            if(BankRoutingNumber != null && BankRoutingNumber != ''){
              homeService.Bank_Routing_Number__c = BankRoutingNumber; 
            }
            if(CheckNumber != null && CheckNumber != ''){
               homeService.Check_Number__c =  CheckNumber;
            }
            update homeService;
            System.debug(homeService);
        }
    }
    
   /* public void expDate(String expDate){
        List<String> parts = expDate.split('/');
		ExpMonth = parts[0];
        ExpYear = parts[1];
    }*/
    
    public void sendToDocusign(){
        SendToDocuSignController stdc = new SendToDocuSignController();
        docuSignConf__c conf = new docuSignConf__c();
        List<docuSignConf__c> docusignconf = [select accountId__c, integratorsKey__c, password__c, userId__c, userIdSolar__c, account__c, passwordSolar__c 
                        from docuSignConf__c];
        String contractId;
        conf = docusignconf[0];  
        String accountId = conf.accountId__c;
        String userId = '';
        String password = '';
        if(productType == 'Water'){
            userId = conf.userId__c;
            password = conf.password__c;
        }else if(productType == 'Solar'){
            userId = conf.userIdSolar__c;
            password = conf.passwordSolar__c;
        }
        
        String integratorsKey = conf.integratorsKey__c;
        contractId = stdc.SendNow(productType, accountId, userId, password, integratorsKey, homeService,1);
        envelopeId = contractId;
        show = 'block';
        show2 = 'none';
    }
    public List<String> dateTimeFrom(DateTime home){
        system.debug(home);
        return String.valueOf(home).split(' ');
    }
    public void dateSaved(List<String> timedate){
        List<String> installDay = dateTimeFrom(homeService.Requested_Install_Date__c)[0].split('-');
        List<String> installHour = dateTimeFrom(homeService.Requested_Install_Date__c)[1].split(':');
        system.debug('installHour : ' +  installHour);
        installationDay =  months[Integer.valueOf(installDay[1]) - 1] +' '+ installDay[2] + ', ' +installDay[0];   
        if(Integer.valueOf(installHour[0]) > 12){
            installationHour  = '0'+(Integer.valueOf(installHour[0]) - 12)+':'+installHour[1]+' PM';
        }else{
            installationHour  = installHour[0]+':'+installHour[1]+' AM';
        }
        
    }
    
    public String getNameFromRecordType(String RecordTypeId){
        return  [Select Name, Id From RecordType 
                  where sObjectType='Home_Services__c' and isActive=true and Id = :RecordTypeId].Name;
    }
    
    
    public void billingInformation(){
        system.debug('test : '+acct.Billing_Information_From__c);
        if(acct.Billing_Information_From__c == 'Client 1'){
            acct.Billing_First_Name__c = acct.AcctFirstName__c;
            acct.Billing_Last_Name__c = acct.AcctLastName__c;
            acct.Billing_Phone__c = acct.Phone;
            acct.Billing_Email__c = acct.PersonEmail;
            acct.Primary_Billing_State__c = acct.State__c;
            acct.Primary_Billing_City__c = acct.City__c;
            acct.Primary_Billing_Street__c = acct.Street__c;
            acct.Primary_Billing_Zip_Code__c = acct.Zip__c;
            acct.Billing_Fax__c = acct.Fax;
            acct.Billing_Company__c = '';
        }else if(acct.Billing_Information_From__c == 'Client 2'){
            acct.Billing_First_Name__c = acct.Homeowner_2_First_Name__c;
            acct.Billing_Last_Name__c = acct.Homeowner_2_Last_Name__c;
            acct.Billing_Phone__c = acct.Homeowner_2_Phone_Number__c;
            acct.Billing_Email__c = acct.Homeowner_2_Email__c;
            acct.Billing_Fax__c = acct.Fax;
            acct.Primary_Billing_State__c = acct.State__c;
            acct.Primary_Billing_City__c = acct.City__c;
            acct.Primary_Billing_Street__c = acct.Street__c;
            acct.Primary_Billing_Zip_Code__c = acct.Zip__c;
            acct.Billing_Company__c = '';
        }else{
            acct.Billing_First_Name__c = '';
            acct.Billing_Last_Name__c = '';
            acct.Billing_Phone__c = '';
            acct.Billing_Email__c = '';
            acct.Primary_Billing_State__c = '';
            acct.Primary_Billing_City__c = '';
            acct.Primary_Billing_Street__c = '';
            acct.Primary_Billing_Zip_Code__c = '';
            acct.Billing_Fax__c = '';
            acct.Billing_Company__c = '';
        }
    }
    
}