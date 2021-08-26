@isTest
public class DiacoAccountReferralCreateHSTest {
    @isTest static void testAll(){
        
        Account Acc = new Account();
        Acc.FirstName = 'Account ';
        Acc.LastName = 'Test';
        Acc.RecordTypeId ='012410000012NOKAA2';
        Acc.Street__c='test';
        Acc.City__c='test';
        Acc.State__c='AZ';
        Acc.Zip__c='test';
        insert Acc;
        
        Personnel__c per = new Personnel__c();
        per.Name = 'test';
        per.First_Name__c = 'test';
        per.Last_Name__c = 'test';
        per.Kunnect_ID__c = 'none';
        insert per;
        
        Home_Services__c hs = new  Home_Services__c();
        hs.Account__c = Acc.Id;
        hs.RecordTypeId = '012410000013G9OAAU';
        hs.Card_Number__c = '123456789';
        hs.CSV__c = '123';
        hs.Method_Of_Payment__c = 'Credit Card';		 
        hs.ApptSetter__c = per.Id;
        hs.Exp_Date__c = '7/24';
        hs.Name='test test test test';
        hs.Home_Services_Status__c='Schedule';
        hs.Sales_Event_Current_Status__c='Schedule';
        hs.Event_Count__c=1;
        //hs.Sales_Rep__c = u.Id;
        insert hs;
        
        referral__c r = new referral__c();
        r.Name='Test';
        r.account__c=acc.Id;
        r.Home_Service__c=hs.Id;
        insert r;
        
        test.startTest();
        
        DiacoAccountReferralCreateHS.getReferrals(acc.Id);
        DiacoAccountReferralCreateHS.getDataRecordType();
        DiacoAccountReferralCreateHS.saveHsOnReferral(r.Id,hs.Id);
        
        test.stopTest();
    }

}