public class DiacoPaymentMethod {

    @AuraEnabled
    public static List<PaymentMethod__c> getPayMethods(String recordId) {
        return [SELECT Id, PaymentMethodType__c, BankName__c, 
                        BankAccountNumber__c, HomeService__c,
                        Does_it_have_chargent_order__c, Payment_Destination__c,
                        Amount__c,HomeService__r.Billing_Frequency__c
                FROM PaymentMethod__c 
                WHERE HomeService__c=:recordId];
    }

    @AuraEnabled
    public static Home_Services__c getBillingInformation(String recordId){
        return [SELECT Id, Account__c, Account__r.Billing_Information_From__c, Account__r.Billing_First_Name__c, 
        Account__r.Billing_Last_Name__c, Account__r.Billing_Phone__c, Account__r.Billing_Fax__c, 
        Account__r.Billing_Company__c, Account__r.Primary_Billing_State__c, Account__r.Primary_Billing_City__c, 
        Account__r.Primary_Billing_Street__c, Account__r.Primary_Billing_Zip_Code__c, Account__r.Billing_Email__c,
        Account__r.PersonMobilePhone, Account__r.Fax,Account__r.Billing_Information_From_Service__c,
        Account__r.Billing_First_Name_Service__c, Account__r.Billing_Last_Name_Service__c,Account__r.Billing_Phone_Service__c, Account__r.Billing_Email_Service__c, Account__r.Billing_Fax_Service__c, Account__r.Billing_Company_Service__c,
        Account__r.Primary_Billing_State_Service__c, Account__r.Primary_Billing_City_Service__c,
        Account__r.Primary_Billing_Street_Service__c, Bill_Start_Date__c,Account__r.Primary_Billing_Zip_Code_Service__c, Account__r.Billing_Address_Same_As_Service_Address__c, Account__r.Billing_Address_Same_As_Product__c 
        FROM Home_Services__c 
        WHERE Id = :recordId LIMIT 1];
    }

    @AuraEnabled
    public static Home_Services__c getTotalHS(String recordId){
        return [SELECT Id, Balance_Due__c, Total_Monthly_Investment__c
                FROM Home_Services__c 
                WHERE Id = :recordId ];
    }
    
    @AuraEnabled
    public static void deletePaymentMethod(String recordId) {
        DiacoDelete.deleteRecord(recordId, 'PaymentMethod__c');
    }
}