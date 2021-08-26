/**************************************************************************
Developed by: MST
Description : This test class created for BatchBillingCreation_AC. 
It would check billing records would create for different inventories or not.
***************************************************************************/

@isTest
public class BatchBillingCreation_AC_Test {
    /*
    
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    @TestSetup static void createtestrecords()
    {
        ID personRecTypID = SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        ID businessRecTypID = SObjectType.Account.getRecordTypeInfosByName().get('Business Accounts').getRecordTypeId(); 
        ID oppRecTypID = SObjectType.Opportunity.getRecordTypeInfosByName().get('nuHome Hot Lead').getRecordTypeId(); 
        ID dtsRecTypID = SObjectType.Inventory__c.getRecordTypeInfosByName().get('nuHome Door Tag Script').getRecordTypeId(); 
        ID nuCardSPECRecTypID = SObjectType.Inventory__c.getRecordTypeInfosByName().get('nuHome nuCard SPEC').getRecordTypeId(); 
        ID nuCardCPLRecTypID = SObjectType.Inventory__c.getRecordTypeInfosByName().get('nuHome nuCard CPL').getRecordTypeId(); 
        ID OBCampaignRecTypID = SObjectType.Inventory__c.getRecordTypeInfosByName().get('nuHome OB Campaign').getRecordTypeId(); 
        ID HotLeadRecTypID = SObjectType.Inventory__c.getRecordTypeInfosByName().get('nuHome Hot Lead').getRecordTypeId(); 
        ID nuCardSUBRecTypID = SObjectType.Inventory__c.getRecordTypeInfosByName().get('nuHome nuCard SUB').getRecordTypeId(); 
        
        
        // Person Account Record Creation.
        
        Account personTestAccount = new Account();
        personTestAccount.RecordTypeId = personRecTypID;
        personTestAccount.Respond_Date__c = system.today();
        personTestAccount.Phone = '1234567891';
        personTestAccount.PersonMobilePhone = '1234567892';
        personTestAccount.LastName = 'TestPerson';
        personTestAccount.Primary_Shipping_Street__c = 'testStreet';
        personTestAccount.Primary_Shipping_City__c = 'testCity';
        personTestAccount.Primary_Shipping_State__c = 'CA';
        personTestAccount.Primary_Shipping_Zip_Code__c = '621007';
        personTestAccount.Sales_Price__c = 1800;
        personTestAccount.respond_date__C = Date.today() - 5;
        insert personTestAccount;
        
        
        Region__c regionIns = New Region__c( Name = 'Central' );
        Insert regionIns;
        
        Branch__c newBranch = new Branch__c(Name = 'AZ-Test Branch',Carrier_ID__c='Test',Region_MD__c = regionIns.Id,Branch_stage__c = 'Delivering');
        insert newBranch;
        // UserAddress Creation.
        
        Address__c address = new Address__c();
        address.city__c = 'Test';
        address.county__c= 'Test';
        address.street__c= 'Test';
        address.zip_code__c= 'Test';
        address.Region_Code__c = 'Test';
        address.Zip_Plus_Four__c = 'Test';
        address.state__c= 'AZ';
        address.country__c= 'US';
        address.Branch__c = newBranch.id;  
        address.Home_Type__c = 'CT';    
        address.MSA__c = 'Tucson AZ'; 
        
        insert address;
        
        User_Address__c inserUserAdd = new User_Address__c();
        inserUserAdd.useraccount__c = personTestAccount.id;
        inserUserAdd.address__c= address.id;
        
        insert inserUserAdd;
        
        // Business Account Creation.
        Account businessTestAccount = new Account();
        businessTestAccount.FirstName = 'TestBusiness';
        businessTestAccount.LastName = 'TestBusiness';
        businessTestAccount.Phone = '1234567891';
        businessTestAccount.Recordtypeid = businessRecTypID ;
        insert businessTestAccount;
        
        //Opportunity Creation.
        
        Opportunity testOpp = new Opportunity();
        testOpp.AccountId = businessTestAccount.Id ;
        testOpp.Name = 'testOpportunity';
        testOpp.Type = 'New Business';
        testOpp.StageName = 'Qualified';
        testOpp.CloseDate = system.today()+7;
        insert testOpp;
        
        // Hot Lead Opportunity Creation.
        
        Opportunity testHLOpp = new Opportunity();
        testHLOpp.AccountId = businessTestAccount.Id ;
        testHLOpp.RecordTypeId = oppRecTypID;
        testHLOpp.Name = 'testOpportunity';
        testHLOpp.Type = 'New Business';
        testHLOpp.StageName = 'Qualified';
        // testHLOpp.Pricebook2Id = '01sg00000009AQ1';
        testHLOpp.CloseDate = system.today()+7;
        insert testHLOpp;
        
        // DTS Inventory creation.
        
        List<Inventory__c> inventoryList = New List<Inventory__c>();
        
        Inventory__c testDTSInventory = new Inventory__c();
        testDTSInventory.RecordTypeId = dtsRecTypID;
        testDTSInventory.ANI__c = '1234567890';
        testDTSInventory.Survey_Question__c = 'Awnings outside for shade?' ;
        testDTSInventory.Survey_Response__c = 'Yes';
        testDTSInventory.UnMatching_Invetnory__c = False;
        testDTSInventory.Account__c = personTestAccount.Id;
        testDTSInventory.idCPL_Billing_Opportunity__c = testOpp.Id;
        testDTSInventory.Product_Price__c = personTestAccount.Sales_Price__c;
        testDTSInventory.billing_stage__c = 'Billable';
        testDTSInventory.User_address__c = inserUserAdd.id;
        inventoryList.add(testDTSInventory);
        //insert testDTSInventory;
        
        // Hot Lead Inventory Creation.
        
        Inventory__c testHLInventory = new Inventory__c();
        system.debug('####### HotLeadRecTypID');
        testHLInventory.RecordTypeId = HotLeadRecTypID;
        testHLInventory.ANI__c = '1234567890';
        testHLInventory.Survey_Question__c = 'Awnings outside for shade?' ;
        testHLInventory.Survey_Response__c = 'Yes';
        testHLInventory.UnMatching_Invetnory__c = False;
        testHLInventory.Account__c = personTestAccount.Id;
        testHLInventory.idCPL_Billing_Opportunity__c = testOpp.Id;
        testHLInventory.Product_Price__c = personTestAccount.Sales_Price__c;
        testHLInventory.isProcessed__c = False;
        testHLInventory.billing_stage__c = 'Billable';
        testHLInventory.User_address__c = inserUserAdd.id;
        testHLInventory.Operational_Stage_Hot_Leads__c = 'Active Tier 1';
        inventoryList.add(testHLInventory); 
        //insert testHLInventory;
        
        // CPL creation.
        
        Inventory__c testCPLInventory = new Inventory__c();
        testCPLInventory.RecordTypeId = nuCardCPLRecTypID;
        testCPLInventory.ANI__c = '1234567890';
        //testInventory.Survey_Question__c = 'Awnings outside for shade?' ;
        // testInventory.Survey_Response__c = 'Y';
        testCPLInventory.UnMatching_Invetnory__c = False;
        testCPLInventory.Account__c = personTestAccount.Id;
        testCPLInventory.idCPL_Billing_Opportunity__c = testOpp.Id;
        testCPLInventory.Product_Price__c = personTestAccount.Sales_Price__c;
        testCPLInventory.billing_stage__c = 'Billable';
        testCPLInventory.User_address__c = inserUserAdd.id;
        inventoryList.add(testCPLInventory);    
        //insert testCPLInventory;
        
        // inventory
        
        Inventory__c testInventory = new Inventory__c();
        testInventory.RecordTypeId = nuCardCPLRecTypID;
        testInventory.Phone_Mobile__c = '1234567890';
        //testInventory.Survey_Question__c = 'Awnings outside for shade?' ;
        // testInventory.Survey_Response__c = 'Y';
        testInventory.UnMatching_Invetnory__c = False;
        testInventory.Account__c = personTestAccount.Id;
        testInventory.idCPL_Billing_Opportunity__c = testOpp.Id;
        testInventory.Product_Price__c = personTestAccount.Sales_Price__c;
        testInventory.billing_stage__c = 'Billable';
        testInventory.User_address__c = inserUserAdd.id;
        inventoryList.add(testInventory);  
        //   insert testInventory;
        
        // Sub creation.
        
        Inventory__c testSubInventory = new Inventory__c();
        testSubInventory.RecordTypeId = nuCardSUBRecTypID;
        testSubInventory.ANI__c = '1234567890';
        testSubInventory.Survey_Question__c = 'Awnings outside for shade?' ;
        testSubInventory.Survey_Response__c = 'Y';
        testSubInventory.UnMatching_Invetnory__c = False;
        testSubInventory.Account__c = personTestAccount.Id;
        testSubInventory.idCPL_Billing_Opportunity__c = testOpp.Id;
        testSubInventory.Product_Price__c = personTestAccount.Sales_Price__c;
        testSubInventory.billing_stage__c = 'Billable';
        testSubInventory.User_address__c = inserUserAdd.id;
        inventoryList.add(testSubInventory);   
        //insert testSubInventory;
        
        
        // SPEC Creation
        
        Inventory__c testSPecInventory = new Inventory__c();
        testSPecInventory.RecordTypeId = nuCardSPECRecTypID;
        testSPecInventory.ANI__c = '1234567890';
        //testInventory.Survey_Question__c = 'Awnings outside for shade?' ;
        // testInventory.Survey_Response__c = 'Y';
        testSPecInventory.UnMatching_Invetnory__c = False;
        testSPecInventory.Account__c = personTestAccount.Id;
        testSPecInventory.idCPL_Billing_Opportunity__c = testOpp.Id;
        testSPecInventory.Product_Price__c = personTestAccount.Sales_Price__c;
        testSPecInventory.billing_stage__c = 'Billable';
        testSPecInventory.User_address__c = inserUserAdd.id;
        inventoryList.add(testSPecInventory);     
        //insert testSPecInventory;
        
        // OB Campaign Inventory.
        
        Inventory__c testOBInventory = new Inventory__c();
        testOBInventory.RecordTypeId = OBCampaignRecTypID;
        testOBInventory.ANI__c = '1234567890';
        //testInventory.Survey_Question__c = 'Awnings outside for shade?' ;
        // testInventory.Survey_Response__c = 'Y';
        testOBInventory.UnMatching_Invetnory__c = False;
        testOBInventory.Account__c = personTestAccount.Id;
        testOBInventory.idCPL_Billing_Opportunity__c = testOpp.Id;
        testOBInventory.Product_Price__c = personTestAccount.Sales_Price__c;
        testOBInventory.OB_Call_Center_Appointment_Date__c = system.today()+3;
        testOBInventory.billing_stage__c = 'Billable';
        testOBInventory.User_address__c = inserUserAdd.id;
        inventoryList.add(testOBInventory); 
        //insert testOBInventory;
        
        AcctSeed__GL_Account__c obCampaign = new AcctSeed__GL_Account__c();
        obCampaign.Name = '4210-CPL-Telemarketing';
        obCampaign.AcctSeed__Sub_Type_1__c = 'Assets';
        insert obCampaign;
        
        AcctSeed__GL_Account__c obSpec = new AcctSeed__GL_Account__c();
        obSpec.Name = '4220-CPL-NonTelemarket';
        obSpec.AcctSeed__Sub_Type_1__c = 'Assets';
        insert obSpec;
        
        AcctSeed__GL_Account__c obSub = new AcctSeed__GL_Account__c();
        obSub.Name = '4100-Recurring Subscription Revenue';
        obSub.AcctSeed__Sub_Type_1__c = 'Assets';
        insert obSub;
        
        AcctSeed__GL_Account__c obHot = new AcctSeed__GL_Account__c();
        obHot.Name = '4200-Direct Leads';
        obHot.AcctSeed__Sub_Type_1__c = 'Assets';
        insert obHot;
        
        AcctSeed__GL_Account__c DTS = new AcctSeed__GL_Account__c();
        DTS.Name = '4200-Direct Leads';
        DTS.AcctSeed__Sub_Type_1__c = 'Assets';
        insert DTS;
        
        AcctSeed__Accounting_Period__c newRec = new AcctSeed__Accounting_Period__c();
        newRec.AcctSeed__End_Date__c = Date.Today() + 5;
        newRec.AcctSeed__Start_Date__c= Date.Today() -5;
        newRec.AcctSeed__Status__c = 'Open';
        //   insert newRec;
        
    }
    
    // Schedule all the OB Campaign inventory records.
    static testmethod void OBBatchScheduling()
    {
        
        // Schedule the test job
        String jobId = System.schedule('ScheduleOBCInventoriesBatch_AC',
                                       CRON_EXP, 
                                       new ScheduleOBCInventoriesBatch_AC());
        
        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
                          NextFireTime
                          FROM CronTrigger WHERE id = :jobId];
        
        // Verify the expressions are the same
        System.assertEquals(CRON_EXP, 
                            ct.CronExpression);
        
        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
        
        // Verify the next time the job will run
        System.assertEquals('2022-03-15 00:00:00', 
                            String.valueOf(ct.NextFireTime));
        
        
        Test.startTest();
        BatchBillingCreation_AC batchBilling = new BatchBillingCreation_AC('nuHome OB Campaign');
        Database.executeBatch(batchBilling, 200);
        Test.stopTest();
        
    }
    
    // Schedule all the SPEC inventory records.
    static testmethod void SpecBatchScheduling()
    {
        
        // Schedule the test job
        String jobId = System.schedule('ScheduleSpecInventoriesBatch_AC',
                                       CRON_EXP, 
                                       new ScheduleSpecInventoriesBatch_AC());
        
        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
                          NextFireTime
                          FROM CronTrigger WHERE id = :jobId];
        
        // Verify the expressions are the same
        System.assertEquals(CRON_EXP, 
                            ct.CronExpression);
        
        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
        
        // Verify the next time the job will run
        System.assertEquals('2022-03-15 00:00:00', 
                            String.valueOf(ct.NextFireTime));
        
        Test.startTest();
        BatchBillingCreation_AC batchBilling = new BatchBillingCreation_AC('nuHome nuCard SPEC');
        Database.executeBatch(batchBilling, 200);
        Test.stopTest();
        
    }
    
    // Schedule all the SUB inventory records.
    static testmethod void SubBatchScheduling()
    {
        
        // Schedule the test job
        String jobId = System.schedule('ScheduleSubInventoriesBatch_AC',
                                       CRON_EXP, 
                                       new ScheduleSubInventoriesBatch_AC());
        
        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
                          NextFireTime
                          FROM CronTrigger WHERE id = :jobId];
        
        // Verify the expressions are the same
        System.assertEquals(CRON_EXP, 
                            ct.CronExpression);
        
        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
        
        // Verify the next time the job will run
        System.assertEquals('2022-03-15 00:00:00', 
                            String.valueOf(ct.NextFireTime));
        
        
        Test.startTest();
        BatchBillingCreation_AC batchBilling = new BatchBillingCreation_AC('nuHome nuCard SUB');
        Database.executeBatch(batchBilling, 20);
        Test.stopTest();
    }
    // Schedule all the Hot Leads inventory records.
    static testmethod void HLBatchScheduling()
    {
        
        // Schedule the test job
        String jobId = System.schedule('ScheduleOBCInventoriesBatch_AC',
                                       CRON_EXP, 
                                       new ScheduleHLInventoriesBatch_AC());
        
        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
                          NextFireTime
                          FROM CronTrigger WHERE id = :jobId];
        
        // Verify the expressions are the same
        System.assertEquals(CRON_EXP, 
                            ct.CronExpression);
        
        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
        
        // Verify the next time the job will run
        System.assertEquals('2022-03-15 00:00:00', 
                            String.valueOf(ct.NextFireTime));
        
        
        Test.startTest();
        BatchBillingCreation_AC batchBilling = new BatchBillingCreation_AC('nuHome Hot Lead');
        Database.executeBatch(batchBilling, 200);
        Test.stopTest();
    }
    // Schedule all the DTS inventory records.
    static testmethod void DTSBatchScheduling()
    {
        
        // Schedule the test job
        String jobId = System.schedule('ScheduleDTSInventories_AC',
                                       CRON_EXP, 
                                       new ScheduleDTSInventories_AC());
        
        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
                          NextFireTime
                          FROM CronTrigger WHERE id = :jobId];
        
        // Verify the expressions are the same
        System.assertEquals(CRON_EXP, 
                            ct.CronExpression);
        
        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
        
        // Verify the next time the job will run
        System.assertEquals('2022-03-15 00:00:00', 
                            String.valueOf(ct.NextFireTime));
        
        Test.startTest();
        BatchBillingCreation_AC batchBilling = new BatchBillingCreation_AC('nuHome Door Tag Script');
        Database.executeBatch(batchBilling, 200);
        
        
        BatchUpdatingPriceonInv_AC inventoryupdate = new BatchUpdatingPriceonInv_AC();
        Database.executeBatch(inventoryupdate, 20);
        Test.stopTest();
    }
    
    // Schedule all the CPL inventory records.
    static testmethod void CPLBatchScheduling()
    {
        
        // Schedule the test job
        String jobId = System.schedule('ScheduleCPLInventories_AC',
                                       CRON_EXP, 
                                       new ScheduleCPLInventories_AC());
        
        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
                          NextFireTime
                          FROM CronTrigger WHERE id = :jobId];
        
        // Verify the expressions are the same
        System.assertEquals(CRON_EXP, 
                            ct.CronExpression);
        
        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
        
        // Verify the next time the job will run
        System.assertEquals('2022-03-15 00:00:00', 
                            String.valueOf(ct.NextFireTime));
        
        Test.startTest();
        BatchBillingCreation_AC batchBilling = new BatchBillingCreation_AC('nuHome nuCard CPL');
        Database.executeBatch(batchBilling, 200);
        Test.stopTest();
    }
    
    static testmethod void updateBatchScheduling()
    {
        
        // Schedule the test job
        String jobId = System.schedule('updatePriceBatch_AC',
                                       CRON_EXP, 
                                       new updatePriceBatch_AC());
        
        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
                          NextFireTime
                          FROM CronTrigger WHERE id = :jobId];
        
        // Verify the expressions are the same
        System.assertEquals(CRON_EXP, 
                            ct.CronExpression);
        
        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
        
        // Verify the next time the job will run
        System.assertEquals('2022-03-15 00:00:00', 
                            String.valueOf(ct.NextFireTime));
        
        
    } */

}