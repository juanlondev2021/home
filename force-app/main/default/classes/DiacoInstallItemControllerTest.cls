@isTest
public class DiacoInstallItemControllerTest {
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
        
        Installation__c i = new Installation__c();
        i.Name = 'Test';
        i.Home_Service__c = hs.Id;
        insert i;
         
        Install_Item__c ii = new Install_Item__c();
        ii.Name = 'Test';
        ii.Installation__c = i.Id;
        insert ii;
        
        Invoice__c iv = new Invoice__c();
        iv.Name = 'Test';
        iv.Install_Item__c = ii.Id;
        insert iv;
        
        test.startTest();
         
        List<Invoice__c> ivs = new List<Invoice__c>();
        ivs.add(iv);
         
        DiacoInstallItemController.getInstallItems(i.Id);
        DiacoInstallItemController.getInvoices(ii.Id);
        DiacoInstallItemController.updateInvoices(ivs);
        DiacoInstallItemController.deleteInvoices(iv.Id);
       	DiacoInstallItemController.deleteInstallItem(ii.Id);

        test.stopTest();
     }

}