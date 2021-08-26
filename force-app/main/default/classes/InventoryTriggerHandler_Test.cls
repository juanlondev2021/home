/***************************************************
* Created By: MSTSolutions
* Test class for inventorTriggerHandler
* *************************************************/
@isTest(seealldata=false)
private class InventoryTriggerHandler_Test {
    
    @testSetup static void loadTestData() {
        //Loading test datas.
        Id inventoryOBCRecordtypeId = Schema.SObjectType.Inventory__c.getRecordTypeInfosByName().get('nuHome OB Campaign').getRecordTypeId();
        Id personAccountRCTPEId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        List<zipcode__c> zipCodes = New List<zipcode__c>();
        List<Branch__c> branchList = New List<Branch__c>();
        List<Industry__c> industryList = New List<Industry__c>();
        List<Account> accountList = New List<Account>();
        List<OB_Campaign_Member__c> obcMemList = New List<OB_Campaign_Member__c>();
        //Creating Industries
        for(Integer i = 0; i< =10 ;i++){
            Industry__c indusTry = New Industry__c(Name = 'Awnings',Active__c = True, OBC_Active__c = True);
            industryList.add(indusTry);
        }
        Insert industryList;
        //Create account records
        for(Integer i = 0; i< =10 ;i++){
            Account accountTestRecord = new Account(FirstName = 'Test',
                                                    LastName = 'Account Record'+i,
                                                    RecordTypeId = personAccountRCTPEId,
                                                    Home_Type__c = 'SF',                                                    
                                                    PersonEmail = 'testAcc@ymail.com',
                                                    Primary_Shipping_State__c = 'AZ',
                                                    Primary_Shipping_County__c = 'Test County',
                                                    Primary_Shipping_Zip_Code__c = '27007',
                                                    Primary_Shipping_City__c = 'Test City'+i,
                                                    Primary_Shipping_Street__c = 'Test Street'+i,
                                                    Primary_Shipping_Country__c = 'US',
                                                    Sales_Price__c = 1000,
                                                    Recording_Date__c = Date.Today(),
                                                    Branch__c = 'AZ-Test Branch');
            
            accountList.add(accountTestRecord);
        }
        Insert accountList;
        
        //Creating Region Records
        Region__c regionIns = New Region__c(Name = 'Central');
        Insert regionIns;
        
        
        //Creating branch records
        Branch__C branch1 = new Branch__c(Name = 'AZ-Test Branch',Carrier_ID__c='Test',Branch_stage__c = 'Delivering',Region_MD__c = regionIns.Id);
        branchList.add(branch1);
        
        Branch__C branch2 = new Branch__c(Name = 'NC-Greensboro',Carrier_ID__c='NCG',Branch_stage__c = 'Delivering',Region_MD__c = regionIns.Id);
        branchList.add(branch2);
        insert branchList;
        //Creating zipcode records
        zipCodes.add(new zipcode__c(Name = '27006',ZipCode__c = '27006', branch__c = branch1.id,MSA__c = 'Winston-Salem, NC MSA',
                                    Region_Code__c = 'SE3',State__c = 'NC'));
        zipCodes.add(new zipcode__c(Name = '27007',ZipCode__c = '27007', branch__c = branch2.id, MSA__c = 'Winston-Salem, AZ MSA',
                                    Region_Code__c = 'SE4',State__c = 'AC'));
        insert zipcodes;
        //Creating address records
        Address__c address = new Address__c(Name = 'Address',City__c = 'Test',County__c = 'Test County',
                                            Country__c = 'US',State__c = 'AZ',Street__c = 'Test Street',Home_Type__c = 'SF',
                                            Zip_code__c = zipCodes[0].Name,Zip_Plus_Four__c = '11');
        
        Insert address;
        //Creating user address record
        User_Address__c userAddrWithPhone = new User_Address__c(Address__c = address.Id, UserAccount__c = accountList[0].Id,Phone__c = '9876543210',
                                                                User_Address_Type__c = 'Un-validated Homeowner',Active__c = true,Sales_Price__c = 1000,Recording_Date__c = Date.Today());
        
        Insert userAddrWithPhone;
        
        Opportunity testOpportunity = new Opportunity(
            StageName = 'Sourcing Demand',
            CloseDate = Date.today(),
            AccountId = accountList[0].Id,
            Name = 'Test Opportunity Triggers'
        );
        
        insert testOpportunity;
        
        Opportunity testOpportunity2 = new Opportunity(
            StageName = 'Sourcing Demand',
            CloseDate = Date.today(),
            AccountId = accountList[0].Id,
            Name = 'Test Opportunity Triggers'
        );
        
        insert testOpportunity2;

        Pricebook2 pb22 = new Pricebook2(Name='Pricebook nuHome');
        insert pb22;
        
        Product2 pro2 = new Product2(Name='nuHome',isActive=true);
        insert pro2;
        
        PricebookEntry pbe2 =new PricebookEntry(unitprice=0.01,Product2Id=pro2.Id,Pricebook2Id=Test.getStandardPricebookId(),
                                                isActive=true,UseStandardPrice = false);
        insert pbe2;
        
        List<OpportunityLineItem> oppLineItemList = New List<OpportunityLineItem>();
        
        OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Quantity=2, OpportunityId=testOpportunity.Id,UnitPrice=0.01,PriceBookEntryId=pbe2.Id);
        oppLineItemList.add(OPplineitem2);
        
        OpportunityLineItem OPplineitem3 = new OpportunityLineItem (Quantity=2, OpportunityId=testOpportunity.Id,UnitPrice=0.01,PriceBookEntryId=pbe2.Id);
        oppLineItemList.add(OPplineitem3);
        
        OpportunityLineItem OPplineitem = new OpportunityLineItem (Quantity=2, OpportunityId=testOpportunity2.Id,UnitPrice=0.01,PriceBookEntryId=pbe2.Id);
        oppLineItemList.add(OPplineitem);
        
        insert oppLineItemList;
        
        Boberdoo_Project_Value__c boberdoo = New Boberdoo_Project_Value__c();
        boberdoo.Name = 'nuHome Test';
        boberdoo.Boberdoo_Project_Value__c = 'nuHome Test';
        boberdoo.Picklist_Values__c = 'nuHome Test';
        boberdoo.Industry__c = 'Awnings';
        Insert boberdoo;
        
        //Creating OBC Member records        
        for(Integer i = 0; i< =10 ;i++){
            OB_Campaign_Member__c obcMem = New OB_Campaign_Member__c(AccountName__c = accountList[0].Id,User_Address__c = userAddrWithPhone.Id,Industry__c = industryList[0].id);
            obcMemList.add(obcMem);
        }
        
        Insert obcMemList;
        
    }
    
    static testmethod void updateOBCMem(){
        Id hotLeadRecTypeId = Schema.SObjectType.Inventory__c.getRecordTypeInfosByName().get('nuHome Hot Lead').getRecordTypeId();
        Id inventoryOBCRecordtypeId = Schema.SObjectType.Inventory__c.getRecordTypeInfosByName().get('nuHome OB Campaign').getRecordTypeId();
        List<Opportunity> oppList = [SELECT Id FROM Opportunity];
        //Fetching test user address records
        List<User_Address__c> userAddressList = [SELECT Id,Address__c,UserAccount__c,Phone__c,User_Address_Type__c,Active__c,Sales_Price__c,Recording_Date__c FROM User_Address__c];
        List<Inventory__c> invList = New List<Inventory__c>();
        //Fetching test account records
        List<Account> accountList = [SELECT Id,FirstName,RecordTypeId,LastName,Home_Type__c,PersonEmail,Primary_Shipping_State__c,Primary_Shipping_County__c,Branch__c FROM Account];
          
        //Creating inventory records that will run through the handler class.
        Inventory__c inv = New Inventory__c();
        inv.RecordTypeId = inventoryOBCRecordtypeId;
        inv.Call_Disposition__c = 'Appointment Set';
        inv.Industry__c = 'Awnings';
        inv.User_Address__c = userAddressList[0].Id;
        inv.Account__c = accountList[0].Id;
        inv.idCPL_Billing_Opportunity__c = oppList[0].Id;
        invList.add(inv);
        
        Inventory__c inv1 = New Inventory__c();
        inv1.RecordTypeId = inventoryOBCRecordtypeId;
        inv1.Call_Disposition__c = 'Appointment Set';
        inv1.Industry__c = 'Awnings';
        inv1.User_Address__c = userAddressList[0].Id;
        inv1.Account__c = accountList[0].Id;
        inv1.idCPL_Billing_Opportunity__c = oppList[0].Id;
        invList.add(inv1);
        
        Inventory__c inv2 = New Inventory__c();
        inv2.RecordTypeId = hotLeadRecTypeId;
        inv2.Call_Disposition__c = 'Appointment Set';
        inv2.Industry__c = 'Awnings';
        inv2.User_Address__c = userAddressList[0].Id;
        inv2.Account__c = accountList[0].Id;
        inv2.Boberdoo_Project_Values__c ='';
        inv2.idCPL_Billing_Opportunity__c = oppList[0].Id;
        invList.add(inv2);
        Insert invList;
        
    }
}