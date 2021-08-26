@isTest
public class DiacoNERGYSolutionsVFTestClass {
    @isTest static void testAll(){
        
        String accountRT = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        Personnel__c person = new Personnel__c (
            First_Name__c = 'Test Personnel',
            Kunnect_ID__c = 'test'
            
        );
        insert person;
        
        Account acc = new Account(
            FirstName = 'Test acc',
            LastName = 'last test',
            RecordTypeId = accountRT,
            Street__c = 'test',
            City__c = 'test',
            Zip__c = '12345',
            State__c = 'AZ'
            
        );
        insert acc;
        
        Home_Services__c hs = new Home_Services__c(
            Name = 'test',
            Account__c = acc.Id,
            ApptSetter__c = person.Id,
            Home_services_Status__c = '',
            Event_Count__c = 0,
            Installation__c = null,
            Service__c = null
        );
        insert hs;
        
		Product__c moduleProduct = new Product__c(
            Name = 'Module',
            Product_Type__c = 'Solar',
            Subcategory__c = 'Module'
        );
        insert moduleProduct;
        
        Line_Item__c moduleLineItem = new Line_Item__c(
            Name = 'Module',
            Home_Service__c = hs.Id,
            Product__c = moduleProduct.Id
        );
        insert moduleLineItem;
        
        Product__c batteryInverterProduct1 = new Product__c(
            Name = 'Battery Inverter 1',
            Product_Type__c = 'Solar',
            Subcategory__c = 'Battery Inverter'
        );
        insert batteryInverterProduct1;
        
        Line_Item__c batteryInverterLineItem1 = new Line_Item__c(
            Name = 'Battery Inverter 1',
            Home_Service__c = hs.Id,
            Product__c = batteryInverterProduct1.Id
        );
        insert batteryInverterLineItem1;
        
        Product__c batteryInverterProduct2 = new Product__c(
            Name = 'Battery Inverter 2',
            Product_Type__c = 'Solar',
            Subcategory__c = 'Battery Inverter'
        );
        insert batteryInverterProduct2;
        
        Line_Item__c batteryInverterLineItem2 = new Line_Item__c(
            Name = 'Battery Inverter 2',
            Home_Service__c = hs.Id,
            Product__c = batteryInverterProduct2.Id
        );
        insert batteryInverterLineItem2;
        
        test.startTest();
        PageReference pageRef = Page.DiacoNERGYSolutionsVF;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', String.valueOf(hs.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(hs);
        DiacoNERGYSolutionsVF testAccPlan = new DiacoNERGYSolutionsVF(sc);
        testAccPlan.getPaymentMethods();
        testAccPlan.getProducts();
        test.stopTest();
        
        
    }
}