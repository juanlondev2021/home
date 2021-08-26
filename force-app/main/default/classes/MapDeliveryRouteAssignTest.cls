@isTest
private class MapDeliveryRouteAssignTest {
    @TestSetup
    static void makeData() {
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
    static void test() {
        Test.startTest();
            Id accountId = [SELECT Id FROM Account lIMIT 1]?.Id;
            Id giftCardOrderId = [SELECT Id FROM Gift_Card_Orders__c LIMIT 1]?.Id;
            Id driverId =  [SELECT Id FROM Driver__c LIMIT 1]?.Id;
            Id userAddressId = [SELECT ID FROM User_Address__c LIMIT 1]?.Id;

            List<Delivery_Object__c> deliveries = new List<Delivery_Object__c>();
            for (Integer i = 0; i < 10; i++) {
                Delivery_Object__c delivery = new Delivery_Object__c();        
                delivery.Person_Account__c = accountId;
                delivery.Driver__c = driverId;
                delivery.name = '1';
                delivery.Parent_Gift_Card_Order__c = giftCardOrderId;
                delivery.User_Address__c = userAddressId;
                delivery.Cheetah_Driver_Code__c = '0';              
                deliveries.add(delivery);   
            }
            insert deliveries;
            List<MapDeliveryRouteAssign.param> requests = new List<MapDeliveryRouteAssign.param>();
            for (Integer i = 0; i < 10; i++) {
                MapDeliveryRouteAssign.param param = new MapDeliveryRouteAssign.param();
                param.linkId = deliveries[i].Id;
                if (i > 5 ) {
                    param.linkId = driverId;
                }
                requests.add(param);
            }
        
            MapDeliveryRouteAssign.assignDelivery(requests);
        Test.stopTest();
    }
}