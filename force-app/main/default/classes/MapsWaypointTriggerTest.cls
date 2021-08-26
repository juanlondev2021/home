@isTest
private class MapsWaypointTriggerTest {
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
        for (Integer i = 0; i < 200; i++) {
            Delivery_Object__c delivery = new Delivery_Object__c();        
            delivery.Person_Account__c = accountId;
            delivery.Driver__c = driverId;
            delivery.name = '1';
            delivery.Parent_Gift_Card_Order__c = giftCardOrderId;
            delivery.User_Address__c = userAddressId;
            delivery.Cheetah_Driver_Code__c = '0';           
            deliveries.add(delivery);   
        }
        TriggerHandler.bypass('DeliveryObjectTrigger');
        insert deliveries;
        TriggerHandler.clearBypass('DeliveryObjectTrigger');
        maps__Route__c route = new maps__Route__c(
            name = 'test',
            maps__Date__c = Date.today() + 2
        );
        insert route;
        
        List<maps__Waypoint__c> waypoints = new List<maps__Waypoint__c>();
        for (Integer i = 0; i < 200; i++) {
            waypoints.add(
                new maps__Waypoint__c(
                    maps__LinkId__c = deliveries[i].Id,
                    maps__Route__c = route.Id
                )
            );
        }
        insert waypoints;
        for (maps__Waypoint__c a: waypoints){
            a.Maps_Delivery_Driver__c=true;
            a.Checkout__c=datetime.now();
            a.Hung_Status__c='Hung';
            a.Delivery_Driver_Longitude__c=1;
            a.Delivery_Driver_Latitude__c=1;
        }
        update waypoints;
        delete waypoints;
        
        Test.stopTest();
    }
}