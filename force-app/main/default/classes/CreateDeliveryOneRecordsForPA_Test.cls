/************************************************************************************************************************************************************************
* Class Name : CreateDeliveryOneRecordsForPA_Test
* Created By : Priyanka Shanmugam  
* Created Date : 2/23/2016
* Author : MST
* Description : This is code coverage class for CreateDeliveryOneRecordsForPA , CreateDeliveryTwoRecordsForPA ,SchedulableCreateDeliveryOneRecordsForPA and SchedulableCreateDeliveryTwoRecordsForPA.
*************************************************************************************************************************************************************************/
@isTest
private class CreateDeliveryOneRecordsForPA_Test {
    // This test runs a scheduled job at every week at 12 AM
    private static String CRON_EXP = '0 0 5 * * ? *';
    
    @testSetup static void setup() {
        TestClassUtil.createZipcodeForBranch();
        TestClassUtil.createDriver();
        TestClassUtil.createCheetahGiftCardOrder();
        TestClassUtil.createBranch();
        TestClassUtil.createAccount(2);
        TestClassUtil.createAddress(2);
        TestClassUtil.createUserAddress(2);  
        TestClassUtil.createDeliveryProducts();    
        TestClassUtil.createDeliveryParameter(1);
        TestClassUtil.createDeliveryParameter(2);
    }
    
    // Schedule the batch class for the the delivery one record
    @isTest static void testSchedulableCreateDeliveryOneRecord() {
        Test.startTest();
        
        // Schedule the test job        
        String jobId = System.schedule('testScheduleLastSession',CRON_EXP, new SchedulableDeliveryOneRecordCreation());
        
        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        
        // Verify the expressions are the same
        System.assertEquals(CRON_EXP, ct.CronExpression);
        
        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
        
        // Verify the next time the job will run
        // System.assertEquals('2015-09-03 00:00:00',String.valueOf(ct.NextFireTime));
        
        Test.stopTest();
        
    }    
    // Execute the batch job for the delivery one record
    @isTest static void testCreateDeliveryOneRecord(){
        Test.startTest();
        String query = 'SELECT Id,Address__r.Branch__c,Address__r.Zip_code__c,CreatedDate,UserAccount__r.CreatedDate,Sales_Price__c,Recording_Date__c,Sale_Date__c,Assessed_Value__c FROM User_Address__c WHERE User_Address_Type__c = \'Primary Owner\' AND Active__c = true AND UserAccount__r.IsPersonAccount = true AND Address__r.Branch__c != null AND (Sale_Date__c != null OR Recording_Date__c != null) AND(Address__r.Home_Type__c = \'SF\' OR Address__r.Home_Type__c = \'Sfr\') AND id NOT IN (SELECT User_Address__c FROM Delivery_object__c)';
        List<User_Address__c> userAddress = Database.query(query);
        system.debug('***************************'+userAddress.size());
        Database.Executebatch(new CreateDeliveryOneRecordsForPA(query),200);
        Test.stopTest();
        
        //Check the delivery one record is created after executing the batch class of the delivery one record.
        List<Delivery_Object__c> deliveryOneRecords = [SELECT Id FROM Delivery_Object__c WHERE Name = '1'];
        System.assert(deliveryOneRecords.size() > 0);       
    }
    // Execute the batch job for the delivery one record
    @isTest static void testCreateDeliveryWithSaleDate(){
        List<User_Address__c> userAddressList = [SELECT id,Sale_Date__c,Recording_Date__c FROM User_Address__c];
        userAddressList[0].Sale_Date__c = userAddressList[0].Recording_Date__c.addDays(-7);
        
        userAddressList[1].Sale_Date__c = userAddressList[1].Recording_Date__c;
        userAddressList[1].Recording_Date__c = userAddressList[1].Recording_Date__c.addDays(-7);
        update userAddressList;
        Test.startTest();
        String query = 'SELECT Id,Address__r.Branch__c,Address__r.Zip_code__c,CreatedDate,UserAccount__r.CreatedDate,Sales_Price__c,Recording_Date__c,Sale_Date__c,Assessed_Value__c FROM User_Address__c WHERE User_Address_Type__c = \'Primary Owner\' AND Active__c = true AND UserAccount__r.IsPersonAccount = true AND Address__r.Branch__c != null AND (Sale_Date__c != null OR Recording_Date__c != null) AND(Address__r.Home_Type__c = \'SF\' OR Address__r.Home_Type__c = \'Sfr\') AND id NOT IN (SELECT User_Address__c FROM Delivery_object__c)';
        Database.Executebatch(new CreateDeliveryOneRecordsForPA(query),200);
        Test.stopTest();
        
        //Check the delivery one record is created after executing the batch class of the delivery one record.
        List<Delivery_Object__c> deliveryOneRecords = [SELECT Id FROM Delivery_Object__c WHERE Name = '1'];
        System.assert(deliveryOneRecords.size() > 0);       
    }
}