@isTest
public class DiacoChangeOrdersControllerTest {
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
        
        Change_Order__c co = new Change_Order__c();
        co.Name = 'Test';
        co.Installation__c = i.Id;
        insert co;
        
        Product__c pr = new Product__c();
        pr.Name = 'test';
        pr.Product_Type__c = 'Water';
        pr.active__c=true;
        insert pr;
        
        Order_Item__c oi = new Order_Item__c();
        oi.Name = 'Test';
        oi.Change_Order__c = co.Id;
        oi.Product_HS__c = pr.Id;
        insert oi;
        
        List<Order_Item__c> ois = new List<Order_Item__c>();
        ois.add(oi);
        
        List<String> ps = new List<String>();
        ps.add(pr.id);
        
        /*List<Order_Item__c> ois = new List<Order_Item__c>();
        ois.add(oi);*/
        
        test.startTest();
        
        DiacoChangeOrdersController.getChangeOrders(i.Id);
        DiacoChangeOrdersController.getOrderItems(co.Id);
        DiacoChangeOrdersController.createNewCO(i.Id, 'Cool Name');
        
        DiacoChangeOrdersController.thereAreProductAndServices(co.Id);
        DiacoChangeOrdersController.getProducts(co.Id);
        DiacoChangeOrdersController.getOrderItemsServices(co.Id);
        
        DiacoChangeOrdersController.updateOrderItem(ois);
        DiacoChangeOrdersController.deleteOrderItem(oi.Id);
        
        DiacoChangeOrdersController.addProductsToCO(co.Id, ps);
        
        pr.Service__c = true;
        update pr;
        
        DiacoChangeOrdersController.addServicesToCO(co.Id, ps, '1000');
        
        DiacoChangeOrdersController.deleteChangeOrder(co.Id);
        
        //DiacoChangeOrdersController.updateOrderItem(ois);
        
        
        test.stopTest();
    }
}