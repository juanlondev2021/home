@isTest
private class AccountTriggerTest {
    
    @TestSetup
    static void makeData() {
        TestClassUtil.createZipcodeForBranch();
        TestClassUtil.createAccount(20);
        TestClassUtil.createCheetahGiftCardOrder();
        TestClassUtil.createDriver();  
        TestClassUtil.createProductAndHungStatus();
        TestClassUtil.createBranch();
        TestClassUtil.createAddress(2);
        TestClassUtil.createUserAddress(2);
        TestClassUtil.createDeliveryParameter(1);

        List<Account> accounts = [SELECT Id FROM Account];        
        Gift_Card_Orders__c giftCardOrder = [SELECT ID FROM Gift_Card_Orders__c LIMIT 1];
        Driver__c driver =  [SELECT ID FROM Driver__c LIMIT 1];
        Branch__c branch = [SELECT ID FROM Branch__c LIMIT 1];
        List<Delivery_Object__c> deliveryObjectLst = new List<Delivery_Object__c>();

        for(User_Address__c current : [SELECT Id,UserAccount__c FROM User_Address__c]){
            Delivery_Object__c deliveryObject = new Delivery_Object__c();
            deliveryObject.Person_Account__c = current.UserAccount__c;
            deliveryObject.User_Address__c = current.Id;
            deliveryObject.Driver__c = driver.id;
            deliveryObject.name = '1';
            deliveryObject.Branch_Object__c = branch.id;
            deliveryObject.Parent_Gift_Card_Order__c = giftCardOrder.id;
            deliveryObject.Hung_Status__c = 'NULL';            
            deliveryObjectLst.add(deliveryObject);
        }
        insert deliveryObjectLst;
    }

    @IsTest
    static void test() {
        list<User_Address__c> userAddressList = new list<User_Address__c>();
        list<Opportunity> opportunities = new list<Opportunity>();

        List<Account> accounts = [SELECT Id FROM Account];        
        integer accountsLength = accounts.size();
        for (Integer i = 0; i < accountsLength; i++) {
            Account acct = accounts[i];
            acct.phone = '1111111111';
            acct.Street__c = '4613 W BEVERLY RD';
            acct.Geocode_Accuracy__c = 'Address';
            acct.Verbal_Consent__c = 'No';
            acct.canvasser_Disposition__c = 'Renter';           
            opportunities.add(
                new Opportunity(
                    Name = 'Test Opp',AccountId = acct.Id,
                    Type = 'Trade',stageName = 'Needs Analysis',
                    closeDate = system.Today()));
        }
        Test.startTest();
            insert opportunities;
            update accounts;
        Test.stopTest();
    }
    
    @IsTest
    static void mapChangeLocation() {
        List<Account> accounts = [SELECT Id FROM Account];        
        integer accountsLength = accounts.size();
        for (Integer i = 0; i < accountsLength; i++) {
            Account acct = accounts[i];
            acct.BillingLongitude = 1;
            acct.BillingLatitude = 1;
        }
        Test.startTest();
            update accounts;
        Test.stopTest();
    }
    
    @IsTest
    static void accountEvalTest() {
        List<Account> accounts = [
        SELECT 
            Id,
            RecordTypeId,
            Street__c,
            City__c,
            State__c,
            County__c,
            BillingLatitude,
            BillingLongitude,
            Geocode_Accuracy__c 
        FROM Account ];   
        
        Account acct = accounts[0];
        Account oldAcct = accounts[1];
        Test.startTest();
            acct.Street__c  = 'test';
            acct.City__c    = 'cartagena';
            acct.State__c   = 'AZ';
            acct.Zip__c     = '67376';
            acct.County__c  = 'test';
            acct.BillingLatitude = 1;
            acct.BillingLongitude = 1;
            acct.Geocode_Accuracy__c = 'Address';
            System.assertEquals(AccountEval.addressNoNull(new account()),false);
            System.assertEquals(AccountEval.locationNoNull(acct),true);
            System.assertEquals(AccountEval.addressChange(acct,oldAcct), true);
            System.assertEquals(AccountEval.locationChange(acct,oldAcct), true);
            System.assertEquals(AccountEval.geoCodeChange(acct,oldAcct), true);
            oldAcct.Street__c  = 'test';
            oldAcct.City__c    = 'cartagena';
            oldAcct.State__c   = 'AZ';
            oldAcct.Zip__c     = '67376';
            oldAcct.County__c  = 'test';
            System.assertEquals(AccountEval.mapLayerChangeLocation(acct,oldAcct), true);
        Test.stopTest();
    }
}