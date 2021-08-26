@isTest
public class DiacoWindowLineItemControllerTest {
    @isTest static void testAll(){
        List<Route__c> route = new List<Route__c>();
        route.add(new Route__c(
            Name = 'Route 1'
        ));
        route.add(new Route__c(
            Name = 'unknown'
        ));
        insert route;
        
        Region__c region = new Region__c();
        region.Name      = 'Test';
        insert region;
        
        Branch__c branch     = new Branch__c();
        branch.Name          = 'Test';
        branch.Region_MD__c  = region.Id;
        branch.Carrier_ID__c = 'test';
        insert branch;
        
        List<ZipCode__c> zips = new List<ZipCode__c>();
        zips.add( new ZipCode__c(
            name      = '1111',
            Route__c  = route[0].Id,
            Branch__c = branch.Id
        ));
        zips.add( new ZipCode__c(
            name      = 'unknown',
            Route__c  = route[1].Id,
            Branch__c = branch.Id
        ));
        insert zips;
        
        City__c ci = new City__c();
        ci.Name       = 'City';
        insert ci;
        
        City__c ci2 = new City__c();
        ci2.Name       = 'Unknown';
        insert ci2;
        
        County__c c = new County__c();
        c.County_Name__c = 'City';
        insert c;
        
        County__c c2 = new County__c();
        c2.County_Name__c = 'Unknown';
        insert c2;
        
        webForm__c w = new webForm__c();
        w.Name = 'Unknown';
        insert w;
        
        Account Acc = new Account();
        Acc.FirstName = 'Test acc';
        Acc.LastName  = 'last test';
        Acc.RecordTypeId ='012410000012NOKAA2';
        Acc.Street__c='test';
        Acc.City__c   =  'City';
        Acc.County__c = 'test';
        Acc.State__c='AZ';
        Acc.Zip__c='test';
        Acc.Web_Form__c = w.id;
        Acc.Route__c = route[0].id;
        insert Acc;
        
        /*Account Acc = new Account();
        Acc.FirstName = 'Account ';
        Acc.LastName = 'Test';
        
        Acc.Street__c='test';
        Acc.City__c='test';
        Acc.State__c='AZ';
        Acc.Zip__c='test';
        insert Acc;*/
        
        Personnel__c per = new Personnel__c();
        per.Name = 'test';
        per.First_Name__c = 'test';
        per.Last_Name__c = 'test';
        per.Kunnect_ID__c = 'none';
        insert per;
        
        Home_Services__c hs = new  Home_Services__c();
        hs.Account__c = Acc.Id;
       // hs.RecordTypeId = '012410000013G9SAAU';
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
        
        Product__c pr = new Product__c();
        pr.Name = 'test';
        pr.Product_Type__c = 'Window';
        pr.active__c = true;
        pr.Service__c = false;
        pr.Product_Type__c = 'KITCHEN CABINETS';
        pr.Remodel_Category__c = 'KITCHEN CABINETS';
        insert pr;
        
        Line_Item__c li = new Line_Item__c();
        li.Name = 'test';
        li.Home_Service__c = hs.Id;
        li.Product__c = pr.Id;
        li.Active__c = true;
        li.Quantity__c = 1;
        li.Unit_Price__c = 10;
        insert li;
        
        List<Line_Item__c> lis = new List<Line_Item__c>();
        lis.add(li);
        
        List<SObject> ps = new List<SObject>();
        ps.add(pr);
            
        test.startTest();
        
        // DiacoWindowLineItemController.getCustomSetting();
        DiacoWindowLineItemController.slice(ps, 0, 1);
        DiacoWindowLineItemController.getPicklistProductType();
        DiacoWindowLineItemController.getInfoFromHS(hs.Id);
        DiacoWindowLineItemController.updateHSLineItem(hs.Id);
        DiacoWindowLineItemController.updateLineItem(lis);
        DiacoWindowLineItemController.getWindowsLineItems(hs.Id);
        DiacoWindowLineItemController.getWindowsLineItemsCategory(hs.Id,'KITCHEN CABINETS');
        DiacoWindowLineItemController.getProducts(hs.Id,'KITCHEN CABINETS');
        
        DiacoWindowLineItemController.addProductsToHS(hs.Id, ps,'KITCHEN CABINETS',1);
        
        DiacoWindowLineItemController.deleteLineItem(li.id);
        
        
        
        test.stopTest();
    }

}