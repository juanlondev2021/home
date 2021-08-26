/**
 * @File Name          : RenderContractController.cls
 * @Description        : 
 * @Author             : William Aldana
 * @Group              : 
 * @Last Modified By   : William Aldana
 * @Last Modified On   : 07-22-2020
 * @Modification Log   : 
 * @test Class: diacoRenderContractControllerTest(John Hernandez)
 * Ver       Date            Author      		    Modification
 * 1.0       5/19/2020       William Aldana         Initial Version
 * 1.1		 7/01/2020		 Fabian Pineda			Added support for fetching the Nergy account's data and Home Service's Installation Company's Application and Design Contacts.
 * 1.2       21/07/2020      William Aldana         added amount to the payment method querys/
**/
public class RenderContractController {
    public Home_Services__c homeService{get; set;}
    public List<Line_Item__c> toLineItems{get; set;}
    public List<Line_Item__c> toLineItems2{get; set;}
    public List<PaymentMethod__c> paymentMethodsProd{get; set;}
    public List<PaymentMethod__c> paymentMethodsServ{get; set;}
    List<PaymentMethod__c> PaymentMethods {get; set;}
    public Boolean trueVal {get; set;}
    public Account installationCompany{get; set;}
    public Contact installationCompanyApplicationContact{get; set;}
    public Contact installationCompanyDesignContact{get; set;}
    public Account nergy{get; set;}
    public Contact nergyApplicationContact{get; set;}
    public String signatureTitle{get; set;}
    public String signatureName{get; set;}
    public String dealerSignatureTitle{get; set;}
    public String dealerSignatureName{get; set;}
    
    public RenderContractController(ApexPages.StandardController controller){
        this.homeService = (Home_Services__c)controller.getRecord();
        toLineItems = new List<Line_Item__c>();
        paymentMethodsProd = new List<PaymentMethod__c>();
        paymentMethodsServ = new List<PaymentMethod__c>();
        PaymentMethods = new List<PaymentMethod__c>();
        List<Line_Item__c> tlines = ListLI(1);
        if(!tlines.isEmpty()){
            toLineItems = tlines;
            for(Line_Item__c li : toLineItems){
                if(li.Total_Sales_Price_p__c == null){
                    li.Total_Sales_Price_p__c = li.Sales_Price__c;
                }
            }
        }
        List<Line_Item__c> tlines2 = ListLI(2);
        if(!tlines2.isEmpty()){
            toLineItems2 = tlines2;
            for(Line_Item__c li : toLineItems2){
                if(li.Total_Sales_Price_p__c == null){
                    li.Total_Sales_Price_p__c = li.Sales_Price__c;
                }
            }
        } 

        paymentMethodsProd = [SELECT AccountNumberChecking__c,BankAccountNumber__c,BankAccountType__c,BankName__c,CardExpirationMonth__c,CardNumber__c,CardType__c,Card_Expiration_Year__c,CSV__c,FinanceCompany__c,FinancedAmount__c,Id,NameOnCard__c,PaymentMethodType__c,RoutingNumber__c,Bank_Account_Name__c, Amount__c FROM PaymentMethod__c where HomeService__c =: this.homeService.id and Payment_Destination__c = 'Products'];
        paymentMethodsServ = [SELECT AccountNumberChecking__c,BankAccountNumber__c,BankAccountType__c,BankName__c,CardExpirationMonth__c,CardNumber__c,CardType__c,Card_Expiration_Year__c,CSV__c,FinanceCompany__c,FinancedAmount__c,Id,NameOnCard__c,PaymentMethodType__c,RoutingNumber__c,Bank_Account_Name__c, Amount__c FROM PaymentMethod__c where HomeService__c =: this.homeService.id and Payment_Destination__c = 'Services'];
        PaymentMethods = [select Id, Name, AccountNumberChecking__c, Amount__c, Bank_Account_Name__c,
        BankAccountNumber__c, BankName__c, BankAccountType__c, CardExpirationMonth__c,  
        Card_Expiration_Year__c, CardNumber__c, CardType__c, CSV__c, 
        FinanceCompany__c, FinancedAmount__c, NameOnCard__c, Payment_Destination__c, 
        Payment_Frequency__c, PaymentMethodType__c, RoutingNumber__c from PaymentMethod__c where HomeService__c =:this.homeService.id and Payment_Destination__c='Products'];
        trueVal = true;
        
        // installationCompany, installationCompanyApplicationContact
        // and installationCompanyDesignContact section
        // Do note that this section assumes only one Application and one Design contact exists at most.

        Home_Services__c hs = [SELECT Installation_Company__c FROM Home_Services__c WHERE Id = :this.homeService.Id LIMIT 1];
        List<Account> installationCompany = null;
        List<Contact> installationCompanyApplicationContact = null;
        List<Contact> installationCompanyDesignContact = null; 
        
        if (hs != null && hs.Installation_Company__c != null) {
			installationCompany = [
                SELECT
                Name,
                AZROC_License__c,
                Doing_Business_As__c,
                Street__c,
                City__c,
                State__c,
                Zip__c
                FROM
                Account
                WHERE
                (
                    Id = :hs.Installation_Company__c
                )
                LIMIT 1
            ];
            
            if (installationCompany != null && installationCompany.size() > 0) {
				installationCompanyApplicationContact = [SELECT Name, Phone, Email FROM Contact WHERE (AccountId = :installationCompany[0].Id AND type__c = 'Application') LIMIT 1];
                installationCompanyDesignContact = [SELECT Name, Phone, Email FROM Contact WHERE (AccountId = :installationCompany[0].Id AND type__c = 'Design') LIMIT 1];
            }
        }
        
        this.installationCompany = (installationCompany != null && installationCompany.size() > 0) ? installationCompany[0] : null;
        this.installationCompanyApplicationContact = (installationCompanyApplicationContact != null && installationCompanyApplicationContact.size() > 0) ? installationCompanyApplicationContact[0] : null;
        this.installationCompanyDesignContact = (installationCompanyDesignContact != null && installationCompanyDesignContact.size() > 0) ? installationCompanyDesignContact[0] : null;
        
        // Fetching the special "Nergy" (Installation-Company) Account and its Application Contact
        
        List<Contact> nergyApplicationContact = null;
        List<Account> nergy = [
            SELECT 
            Name,
            AZROC_License__c,
            Doing_Business_As__c,
            Street__c,
            City__c,
            State__c,
            Zip__c
            FROM
            Account
            WHERE
            (
                Name = 'NERGY LLC'
                AND
                Installation_Company__c= true
            )
            LIMIT 1
        ];
        
        if (nergy != null && nergy.size() > 0) {
            nergyApplicationContact = [SELECT Name, Phone, Email FROM Contact WHERE (AccountId = :nergy[0].Id AND type__c = 'Application') LIMIT 1];
        }
        
        this.nergy = (nergy != null && nergy.size() > 0) ? nergy[0] : null;
        this.nergyApplicationContact = (nergyApplicationContact != null && nergyApplicationContact.size() > 0) ? nergyApplicationContact[0] : null;
    }
    
    public List<Line_Item__c> ListLI(Integer opt){
        if(opt == 1){
            return [select Id, Name,  Home_Service__c, Part_Number__c, Product__c, Product__r.Service__c,Quantity__c, Sales_Price__c, 
                    Total_Cost__c, Total_Sales_Price_p__c, Bill_Start_Date__c, Billing_Frequency__c, Monthly_Investment__c, Bill_SD__c, Service_Check__c
                    from Line_Item__c 
                    where Product__r.Service__c = false and Home_Service__c = :this.homeService.Id];
        }else{
            return [select Id,  Name, Home_Service__c,  Part_Number__c, Product__c,Product__r.Service__c,Quantity__c, Sales_Price__c, Total_Cost__c, 
                    Total_Sales_Price_p__c,Bill_Start_Date__c,Billing_Frequency__c,Monthly_Investment__c,Bill_SD__c, Service_Check__c
                    from Line_Item__c 
                    where Product__r.Service__c = true and Home_Service__c = :this.homeService.Id];
        }
    }
    


   public  String getSignatureLink() {
       
       String link='Not found'; //Default value
       String recordId;
       try{
           recordId=this.installationCompany.Id;
       }catch(Exception e){
           recordId=null;
       }
              
        Map<String, sObject> ret = new Map<String, sObject>();
        ret.put('ContentDocumentLink', null);
        ret.put('ContentDocument', null);
        ret.put('ContentVersion', null);
        
        List<ContentDocumentLink> cdl;
        List<Id> cdlIds = new List<Id>();
        
        List<ContentDocument> cd;
        List<ContentVersion> cv;
        
        if (recordId != null && recordId.trim().length() > 0) {
            cdl = [SELECT ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE (LinkedEntityId = :recordId AND IsDeleted = false)];
            
            if (cdl != null && cdl.size() > 0) {
                for (Integer i = 0; i < cdl.size(); i++) {
                    cdlIds.add(cdl[i].ContentDocumentId);
                }
                
                cd = [SELECT LatestPublishedVersionId FROM ContentDocument WHERE (Id IN :cdlIds AND IsDeleted = false AND Title = 'Account Signature') LIMIT 1];
                
                if (cd != null && cd.size() > 0) {
                    for (Integer i = 0; i < cdl.size(); i++) {
                        if (cdl[i].ContentDocumentId == cd[0].Id) {
                            ret.put('ContentDocumentLink', cdl[i]);
                            break;
                        }
                    }
                    
                    ret.put('ContentDocument', cd[0]);
                    
                    cv = [SELECT Dealer_Certification_Title__c, Dealer_Certification_Name__c FROM ContentVersion WHERE (Id = :cd[0].LatestPublishedVersionId AND IsDeleted = false AND IsLatest = true) LIMIT 1];
                    
                    if (cv != null && cv.size() > 0) {
                        ret.put('ContentVersion', cv[0]);
                    }
                }
                signatureName = cv[0].Dealer_Certification_Title__c;
                signatureTitle = cv[0].Dealer_Certification_Name__c;
                link=ret.get('ContentVersion').Id==null?'Not found': '/sfc/servlet.shepherd/version/download/' + ret.get('ContentVersion').Id;
                return link;
            }
        }
        return link;
    }  
    
    
    public String getDealerSignatureLink() {
        String ret = 'Not found';
        
        List<ContentDocumentLink> cdl = [SELECT ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE (LinkedEntityId = :this.nergy.Id AND IsDeleted = false)];
        List<Id> cdlIds = new List<Id>();
        
        List<ContentDocument> cd;
        List<ContentVersion> cv;
        
        if (cdl != null && cdl.size() > 0) {
            for (Integer i = 0; i < cdl.size(); i++) {
                cdlIds.add(cdl[i].ContentDocumentId);
            }
            
            cd = [SELECT LatestPublishedVersionId FROM ContentDocument WHERE (Id IN :cdlIds AND IsDeleted = false AND Title = 'Account Signature') LIMIT 1];
            
            if (cd != null && cd.size() > 0) {
                cv = [SELECT Dealer_Certification_Title__c, Dealer_Certification_Name__c FROM ContentVersion WHERE (Id = :cd[0].LatestPublishedVersionId AND IsDeleted = false AND IsLatest = true) LIMIT 1];
                
                if (cv != null && cv.size() > 0) {
                    ret = cv[0].Id == null ? 'Not found' : '/sfc/servlet.shepherd/version/download/' + cv[0].Id;
                    this.dealerSignatureTitle = cv[0].Dealer_Certification_Title__c;
                    this.dealerSignatureName = cv[0].Dealer_Certification_Name__c;
                }
            }
        }
        
        return ret;
    }
    
    public dpcle__Loan_Aplication__c getLoanInfo(){
        List<dpcle__RelatedObject__c> ro=[select Id,dpcle__Loan_Application__c from dpcle__RelatedObject__c where dpcle__Source_Object_Id__c =:this.homeService.Id and dpcle__Loan_Application__c!=null order by createdDate desc limit 1];
        system.debug(ro);
        dpcle__Loan_Aplication__c loanInfo = new dpcle__Loan_Aplication__c();
        if(ro.size()>0){
            loanInfo = [select dpcle__First_Payment_Date__c, dpcle__LA_SaleAmount__c from dpcle__Loan_Aplication__c where Id =:ro[0].dpcle__Loan_Application__c];
        }
        system.debug('LA: '+loanInfo);
        return loanInfo;
    }
    
    public Date getContractEnd(){
        Date todays = Date.today();
        todays = todays.addYears(1);
        
        return todays.addDays(-1);
    }
    
    public List<Finance_Package__c> getFinanceInfo(){
        return [select Monthly_Renewal_PURCHASE__c                                             
                                             from Finance_Package__c where Name=:this.homeService.Id];
    }
}