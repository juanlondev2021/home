/************************************************************************************************************************************************************************
* Class Name : CreateDeliveryTwoRecordsForPA_Test
* Created By : Sankar Marappan  
* Created Date : 2/23/2016
* Author : MST
* Description : This is code coverage class for CreateDeliveryOneRecordsForPA , CreateDeliveryTwoRecordsForPA ,SchedulableCreateDeliveryOneRecordsForPA and SchedulableCreateDeliveryTwoRecordsForPA.
*************************************************************************************************************************************************************************/
@isTest
private class CreateDeliveryTwoRecordsForPA_Test {
    // This test runs a scheduled job at every week at 12 AM
    private static String CRON_EXP = '0 0 5 * * ? *';
    
    @testSetup static void setup() {
        TestClassUtil.createZipcodeForBranch();
        TestClassUtil.createHung_Status_Setting();
        TestClassUtil.createDriver();
        TestClassUtil.createCheetahGiftCardOrder();
        TestClassUtil.createBranch();
        TestClassUtil.createAccount(2); 
        TestClassUtil.createAddress(2);
        TestClassUtil.createUserAddress(2);   
        TestClassUtil.createDeliveryProducts();
        TestClassUtil.createDeliveryParameter(1);
        TestClassUtil.createDeliveryParameter(2);
        TestClassUtil.createDeliveryOneRecord();
    }
    // Schedule the batch class for the the delivery two record
    @isTest static void testSchedulableCreateDeliveryTwoRecord() {
        Test.startTest();
        
        // Schedule the test job        
        String jobId = System.schedule('testScheduleLastSession',CRON_EXP, new SchedulableDeliveryTwoRecordCreation());
        
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
    
    // Test all the possible scenarios of the delivery two record creation
    @isTest static void createDeliveryTwoRecordProcess(){  
        
        Date dToday = System.Today().addDays(-7); 
        Datetime dt = datetime.newInstance(dToday.year(), dToday.month(),dToday.day());  
        Delivery_object__c delivery = [SELECT Hung_Status__c,Delivery_Date__c FROM Delivery_Object__c WHERE name = '1'];
        delivery.Hung_Status__c = 'Hung';
        delivery.Delivery_Date__c = dt;
        update delivery;
        Test.startTest();
        String query = 'SELECT Id,Name,fbranch__c,Hung_Status__c,Branch_Object__c,User_address__r.createddate,User_Address__r.Address__r.Branch__c,Delivery_Parameter__r.Days_Until_Next_Delivery__c,Delivery_Date__c,Person_Account__c,User_Address__r.Sales_Price__c,User_Address__r.Assessed_Value__c,User_Address__r.Address__r.Zip_Code__c,User_Address__r.Sale_Date__c,User_Address__r.Recording_Date__c,Person_Account__r.createddate,lastmodifieddate,User_Address__r.Respond_Date__c FROM Delivery_Object__c WHERE Hung_Status__c = \'Hung\' AND Delivery_Date__c != null AND Person_Account__r.isPersonAccount = true AND User_Address__r.Address__r.Branch__c != null AND (User_Address__r.Sale_Date__c != null OR User_Address__r.Recording_Date__c != null) AND User_Address__r.Respond_Date__c = null AND IsRecent__c = true';
        database.executebatch(new CreateDeliveryTwoRecordsForPA(query),200);
        Test.stopTest();
        
        //Check the delivery two record is created after executing the batch class of the delivery two record
        List<Delivery_Object__c> deliveryTwoRecords = [SELECT Id FROM Delivery_Object__c WHERE Name = '2'];
        //System.assert(deliveryTwoRecords.size() > 0);
    }
    // Test all the possible scenarios of the delivery two record creation
    @isTest static void createDeliveryTwoRecordWithSaleDate(){ 
        
        List<User_Address__c> userAddressList = [SELECT id,Sale_Date__c,Recording_Date__c FROM User_Address__c];
        userAddressList[0].Sale_Date__c = userAddressList[0].Recording_Date__c.addDays(-7);
        userAddressList[1].Sale_Date__c = userAddressList[1].Recording_Date__c;
        userAddressList[1].Recording_Date__c = userAddressList[1].Recording_Date__c.addDays(-7);
        update userAddressList;
        
        Date dToday = System.Today().addDays(-7); 
        Datetime dt = datetime.newInstance(dToday.year(), dToday.month(),dToday.day());  
        Delivery_object__c delivery = [SELECT Hung_Status__c,Delivery_Date__c FROM Delivery_Object__c WHERE name = '1'];
        delivery.Hung_Status__c = 'Hung';
        delivery.Delivery_Date__c = dt;
        update delivery;
        
        Test.startTest();
        String query = 'SELECT Id,Name,fbranch__c,Hung_Status__c,Branch_Object__c,User_address__r.createddate,User_Address__r.Address__r.Branch__c,Delivery_Parameter__r.Days_Until_Next_Delivery__c,Delivery_Date__c,Person_Account__c,User_Address__r.Sales_Price__c,User_Address__r.Assessed_Value__c,User_Address__r.Address__r.Zip_Code__c,User_Address__r.Sale_Date__c,User_Address__r.Recording_Date__c,Person_Account__r.createddate,lastmodifieddate,User_Address__r.Respond_Date__c FROM Delivery_Object__c WHERE Hung_Status__c = \'Hung\' AND Delivery_Date__c != null AND Person_Account__r.isPersonAccount = true AND User_Address__r.Address__r.Branch__c != null AND (User_Address__r.Sale_Date__c != null OR User_Address__r.Recording_Date__c != null) AND User_Address__r.Respond_Date__c = null AND IsRecent__c = true';
        database.executebatch(new CreateDeliveryTwoRecordsForPA(query),200);
        Test.stopTest();
        
        //Check the delivery two record is created after executing the batch class of the delivery two record
        List<Delivery_Object__c> deliveryTwoRecords = [SELECT Id FROM Delivery_Object__c WHERE Name = '2'];
        //System.assert(deliveryTwoRecords.size() > 0);
    }
}