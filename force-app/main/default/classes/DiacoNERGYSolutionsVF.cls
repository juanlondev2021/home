public class DiacoNERGYSolutionsVF {
    private final Home_Services__c hs;
    public Account account {get; set;}
    
    public Double timezoneOffset {get;set;}
    public String nbsp {get;set;}
    
    public Line_Item__c moduleLineItem {get;set;}
    public Line_Item__c firstInverterLineItem {get;set;}
    public Line_Item__c secondInverterLineItem {get;set;}
    
    public DiacoNERGYSolutionsVF(ApexPages.StandardController stdController){
        this.hs = (Home_Services__c)stdController.getRecord();
        this.timezoneOffset = UserInfo.getTimeZone().getOffset(DateTime.now()) / (1000 * 3600 * 24.0);
        this.nbsp = '\u00A0';
    }
    public List<PaymentMethod__c> getPaymentMethods(){
        List<PaymentMethod__c> PaymentMethods = new List<PaymentMethod__c>();
        System.debug(hs.Id);
        if(hs.Id!=null){
            PaymentMethods = [select Id, Name, AccountNumberChecking__c, Amount__c, Bank_Account_Name__c,
                              BankAccountNumber__c, BankName__c, BankAccountType__c, CardExpirationMonth__c,  
                              Card_Expiration_Year__c, CardNumber__c, CardType__c, CSV__c, 
                              FinanceCompany__c, FinancedAmount__c, NameOnCard__c, Payment_Destination__c, 
                              Payment_Frequency__c, PaymentMethodType__c, RoutingNumber__c from PaymentMethod__c where HomeService__c =:this.hs.Id];
            System.debug(PaymentMethods);
        }
        return PaymentMethods;
    }
    

    public List<Line_Item__c> getProducts(){
        
        List<Line_Item__c> products = new List<Line_Item__c>();
        
        if(hs.Id!=null){
            products = [
                SELECT
                Name,
                Quantity__c,
                Total_Price__c,
                Sales_Price__c,
                Home_Service__c,
                Product__r.Product_Type__c,
                Product__r.Subcategory__c,
                Product__r.Manufacture__c,
                Product__r.Part_Number__c,
                Product__r.Max_power_rating_watts__c,
                Product__r.Nameplate_rating_kW_AC__c
                FROM
                Line_Item__c
                WHERE 
                (
                    Home_Service__c = :this.hs.Id
                    AND
                    Product__r.Product_Type__c = 'Solar'
                )
            ];
            
            if (products != null && products.size() > 0) {
                for (Integer i = 0; i < products.size(); i++) {
                    if (moduleLineItem == null && products[i].Product__r.Subcategory__c == 'Module') {
                        moduleLineItem = products[i];
						continue;                        
                    }
                    
                    if (firstInverterLineItem == null && products[i].Product__r.Subcategory__c == 'Battery Inverter') {
                        firstInverterLineItem = products[i];
                        continue;
                    }
                    
                    if (firstInverterLineItem != null && secondInverterLineItem == null && products[i].Product__r.Subcategory__c == 'Battery Inverter') {
                        secondInverterLineItem = products[i];
                        continue;
                    }
                }
            }
        }
        
        return products;
        
    }
}