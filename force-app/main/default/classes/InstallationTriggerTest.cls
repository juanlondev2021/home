@isTest
private class InstallationTriggerTest {
    @TestSetup
    static void makeData(){
        Id accRecordTypeId  = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Id hsRecordTypeId  = Schema.SObjectType.Home_Services__c.getRecordTypeInfosByName().get('Home Automation Sales').getRecordTypeId();
    
        Account acc = new Account();
        acc.Recordtypeid = accRecordTypeId;
        acc.FirstName       = 'Test acc';
        acc.LastName        = 'last test';
        acc.City__c         =  'City';
        acc.County__c       = 'test';
        insert acc;

        Product__c product = new Product__c(
            Active__c            = true,
            Cost__c              = 12.32,
            Installation_Cost__c = 12.23,
            Product_Type__c      = 'Home Automation'            
        );
        insert product;

        Home_Services__c hs = new Home_Services__c(
            Account__c      = acc.Id,
            Recordtypeid    = hsRecordTypeId
        );
        insert hs;

        Line_Item__c lItem = new Line_Item__c(
            Product__c = product.Id,
            Home_Service__c = hs.Id
        );
        insert lItem;
    }

    @IsTest
    static void test(){
        List<Home_Services__c> hs = [SELECT Appt_Sale_Status__c FROM Home_Services__c];        
        List<Installation__c> insts = new List<Installation__c>();
        
        Test.startTest();
        hs[0].Appt_Sale_Status__c = 'Sale Approved';
        update hs[0];
        
        Installation__c n = [SELECT Home_Service__c, Installation_Status__c FROM Installation__c WHERE Home_Service__c = :hs[0].Id LIMIT 1];
        n.Installation_Status__c = 'Installed';
        update n;
        delete n;
        hs[0].Installation__c = null;
        update hs[0];
        
        for (Integer i = 0; i < 10; i++) {
            insts.add(new Installation__c(
                Home_Service__c = hs[0].Id,
                Sub_Categories__c = ''
            ));   
        }
        insert insts;
        Test.stopTest();
        
    }
}