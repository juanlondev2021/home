public class diacoTabsInformationCompletion {
    
    @AuraEnabled
    public static Boolean checkSolarFirstCustomer(String RecordId) {
        Home_Services__c home =  [select Account__c from Home_Services__c where id = :RecordId];
        Account account = [select Id, FirstName, LastName,  Phone, PersonMobilePhone,
                            Street__c ,Zip__c,City__c,State__c,PersonEmail
                            from Account  where Id = :home.Account__c ];
        
        if(account !=null){
            if(
            account.FirstName!=null && account.LastName!=null &&
            account.Phone!=null && account.PersonMobilePhone!=null &&    
            account.Street__c!=null && account.Zip__c!=null &&
            account.City__c!=null && account.State__c!=null &&
            account.PersonEmail!=null 
            ){
                return true;
            }
        }
        return false;
        
    }
    
    @AuraEnabled
    public static Boolean checkSecondCustomer(String RecordId) {
        Home_Services__c home =  [select Account__c from Home_Services__c where id = :RecordId];
        Account account = [select Id, Homeowner_2_First_Name__c,Homeowner_2_Last_Name__c, Homeowner_2_Phone_Number__c,
                           Homeowner_2_Mobile__c, Homeowner_2_Email__c
                           from Account 
                           where Id = :home.Account__c ];
        
        if(account !=null){
            if(account.Homeowner_2_First_Name__c!=null && account.Homeowner_2_Last_Name__c!=null && (account.Homeowner_2_Phone_Number__c!=null || account.Homeowner_2_Mobile__c!=null)
               && account.Homeowner_2_Email__c!=null
            ){
                return true;
            }
        }
        return false;
        
    }
    
    //At least one product/Service added
    @AuraEnabled
    public static Boolean checkProductsOrServices(String recordId) {
        
        
        List<Line_Item__c> cos=[select Id, Name, Unit_Price__c, Total_Price__c, Quantity__c,Product__c,Home_Service__c
                                from Line_Item__c
                                where Home_Service__c = :recordId  and Service_Check__c = false
                                order by CreatedDate desc];
        
        List<Line_Item__c> ois=[select Id, Name, Billing_Frequency__c, Bill_Start_Date__c, Monthly_Investment__c 
                                from Line_Item__c
                                where Home_Service__c = :recordId  and Service_Check__c = true
                                order by CreatedDate desc];
        
        if(cos.size()>0 || ois.size()>0 ){
            return true;
        }
        return false;
        
    }
    
    //At least one payment method added
    @AuraEnabled
    public static Boolean checkPayments(String recordId) {
        
        List<PaymentMethod__c> payments = [Select Id, PaymentMethodType__c, HomeService__c, Payment_Destination__c, Amount__c
                                           from PaymentMethod__c where HomeService__c=:recordId];
        
        if(payments.size()>0){
            return true;
        }
        return false;
        
    }
    
    @AuraEnabled
    public static Boolean checkBillingInformation(String recordId) {
        Home_Services__c home =  [select Id, Account__c, Account__r.Primary_Billing_State__c
                                  from Home_Services__c 
                                  where Id = :recordId Limit 1];
        
        if(home.Account__r.Primary_Billing_State__c != null ){
            return true;
        }
        return false;
    }
    @AuraEnabled
    public static Boolean checkInstallationDate(String recordId) {
        Home_Services__c home = [select Id, Sales_Rep__c, Requested_Install_Date__c
                                 from Home_Services__c 
                                 where id = :recordId];
        if(home.Requested_Install_Date__c != null){
            return true;
        }
        return false;
    }
    
    @AuraEnabled
    public static Boolean checkServicePackage(String recordId) {
        Home_Services__c home =  [select Id,Communication_By__c,Monthly_Security_Services__c
                                  from Home_Services__c where id = :recordId];
        
        if(home.Communication_By__c != null || home.Monthly_Security_Services__c != null ){
            return true;
        }
        return false;
    }
    
    @AuraEnabled
    public static Boolean checkUtilityInformation(String recordId) {
        Home_Services__c homeService = [
            SELECT Utility_Company__c, Username__c,Password__c
            FROM Home_Services__c WHERE Id = :recordId LIMIT 1
        ];
        if(homeService.Utility_Company__c != null && homeService.Username__c != null && homeService.Password__c != null){
            return true;
        }
        return false;
    }
    
}