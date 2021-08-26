@isTest
public class DiacoLineItemsControllerTest {
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
        i.RecordTypeId = '012410000013IFMAA2';
        insert i;

        Product__c pr = new Product__c();
        pr.Name = 'test';
        pr.Product_Type__c = 'Water';
        pr.active__c = true;
        insert pr;

        Product__c prS = new Product__c();
        prS.Name = 'test';
        prS.Product_Type__c = 'Water';
        prS.active__c = true;
        prS.Service__c = True;
        insert prS;
        
        Line_Item__c li = new Line_Item__c();
        li.Name = 'Test';
        li.Product__c = pr.Id;
        li.Home_Service__c = hs.Id;
        insert li;

        List<Line_Item__c> lis = new List<Line_Item__c>();
        lis.add(li);
        
        list<String> selected = new List<String>();
        selected.add(pr.Id);
        
        list<String> selectedS = new List<String>();
        selectedS.add(prS.Id);

        test.startTest();
        DiacoLineItemsController.shouldDisplayInstallerPointColumn(hs.Id);
        DiacoLineItemsController.getLineItems(hs.Id);
        DiacoLineItemsController.getLineItemsServices(hs.Id);
        DiacoLineItemsController.updateLineItems(lis);
        DiacoLineItemsController.getProducts(hs.Id);
        DiacoLineItemsController.getServices(hs.Id);
        DiacoLineItemsController.addProductsToHS(hs.Id, selected);
        DiacoLineItemsController.addServicesToHS(hs.Id, selectedS, 'Monthly');
        DiacoLineItemsController.deleteLineItem(li.Id);
        DiacoLineItemsController.updatePaymentItemsServices(li.Id,'Monthly');
        test.stopTest();

    }
}