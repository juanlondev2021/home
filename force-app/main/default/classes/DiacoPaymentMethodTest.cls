@isTest
public class DiacoPaymentMethodTest {
    
    @isTest static void testAll(){
        Account Acc = new Account();
        Acc.FirstName = 'Account ';
        Acc.LastName = 'Test';
        Acc.RecordTypeId ='012410000012NOKAA2';
        Acc.Street__c='test';
        Acc.City__c='test';
        Acc.State__c='AZ';
        Acc.Zip__c='test';
        Acc.Phone = '000000000';
        insert Acc;
        Personnel__c per = new Personnel__c();
        per.Name = 'test';
        per.First_Name__c = 'test';
        per.Last_Name__c = 'test';
        per.Kunnect_ID__c = 'none';
        insert per;
     	Home_Services__c hs = new  Home_Services__c();
        hs.Account__c = Acc.Id;
        hs.RecordTypeId = '012410000013G9KAAU';
        hs.Name='test test test test';
        hs.ApptSetter__c = per.Id;
        insert hs;
        PaymentMethod__c pm = new PaymentMethod__c(
            Amount__c = 8900
        );
        upsert pm;
        
        test.startTest();
        DiacoPaymentMethod.getTotalHS(hs.Id);
        DiacoPaymentMethod.getPayMethods(hs.Id);
		DiacoPaymentMethod.getBillingInformation(hs.Id);  
        DiacoPaymentMethod.deletePaymentMethod(pm.Id);
        DiacoDelete.deleteRecord(hs.Id, 'Home_Services__c');
        test.stopTest();
    }

}