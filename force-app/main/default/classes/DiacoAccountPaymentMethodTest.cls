@isTest
public class DiacoAccountPaymentMethodTest {
	@testSetup
    static void setup(){
        Account a = new Account(Name='test');
        insert a;
        PaymentMethod__c pay = new PaymentMethod__c(Name='Test pay',Account__c=a.Id,PaymentMethodType__c='ACH');
        insert pay;
    }
    @isTest
    static void testAll(){
        Account act = [select id from Account where Name='test'];
        Test.startTest();
        List<PaymentMethod__c> pays = DiacoAccountPaymentMethod.getPayMethods(act.Id);
        DiacoAccountPaymentMethod.deletePayMethod(pays[0].Id);
        Test.stopTest();
    }
}