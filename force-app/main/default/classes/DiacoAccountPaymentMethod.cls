public class DiacoAccountPaymentMethod {
	@AuraEnabled
    public static List<PaymentMethod__c> getPayMethods(String recordId){
        return [Select Id, PaymentMethodType__c, BankName__c, BankAccountNumber__c, RoutingNumber__c, 
                Bank_Account_Name__c, CardExpirationMonth__c,Card_Expiration_Year__c, CardType__c,
                CardNumber__c, CSV__c, NameOnCard__c
        		from PaymentMethod__c where Account__c=:recordId];
    }
    
    @AuraEnabled
    public static void deletePayMethod(String recordId){
        PaymentMethod__c del = new PaymentMethod__c(Id=recordId);
        delete del;
    }
}