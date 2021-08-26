@istest
private class DiacoGetGeoLocationTest {
    @TestSetup
    static void makeData(){
        TestClassUtil.createZipcodeForBranch();
        TestClassUtil.createAccount(2);
        TestClassUtil.createCheetahGiftCardOrder();
        TestClassUtil.createDriver();  
        TestClassUtil.createProductAndHungStatus();
        TestClassUtil.createBranch();
        TestClassUtil.createAddress(2);
        TestClassUtil.createUserAddress(2);
        TestClassUtil.createDeliveryParameter(1);
    }

    @IsTest
    static void test(){
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
            deliveryObject.Hung_Status__c = 'Cant Find';            
            deliveryObjectLst.add(deliveryObject);
        }        
        insert deliveryObjectLst;    
        Test.startTest();
            DiacoGetGeoLocation.contractInit(deliveryObjectLst[0].Id);
            DiacoGetGeoLocation.contractInit(accounts[0].Id);
        Test.stopTest();
        
    }
}