@IsTest
private class DeliveryObjtTriggerTest {
    @testSetup static void loadTestData() {
        TestClassUtil.createZipcodeForBranch();
        TestClassUtil.createAccount(5);
        TestClassUtil.createCheetahGiftCardOrder();
        TestClassUtil.createDriver(); 
        TestClassUtil.createAddress(5);
        TestClassUtil.createUserAddress(3);  

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
                delivery.Hung_Status__c = 'NULL';  
                if ( i > 5 ) {
                    delivery.Cheetah_Driver_Code__c = 'invalid 728337';
                }         
                deliveries.add(delivery);   
            }

            insert deliveries;
    }	

    static testmethod void testIsRecentChecked() {
        Delivery_Object__c[] deliveries = [SELECT Id,Street__c FROM Delivery_Object__c ];
        Test.startTest();
            integer deliverieSize = deliveries.size();
            for (Integer i = 0; i < deliverieSize; i++) {
                Delivery_Object__c delivery  = deliveries[i];
                delivery.Scan_Code__c = '1234 2134 2132 2343';
                delivery.Maps_latitude__c = 1;
                delivery.Maps_longitude__c = 2;
                delivery.Street__c = 'test';
                delivery.Geocode_Accuracy__c = 'Address';
                if ( i > 5 ) {
                    delivery.Scan_Code__c = '1234 2134 0000 0000';
                    delivery.Cheetah_Driver_Code__c = '45666';
                }
            } 
            update deliveries;
        Test.stopTest();        
    } 
	
    static testmethod void testDeliveryDriverLeadStatus() {
        Delivery_Object__c[] deliveries = [SELECT Id,Street__c FROM Delivery_Object__c ];
        Test.startTest();
            integer deliverieSize = deliveries.size();
            for (Integer i = 0; i < deliverieSize; i++) {
                Delivery_Object__c delivery  = deliveries[i];            
                delivery.Hung_Status__c = 'Hung';
                delivery.Delivery_Date__c = Datetime.now();
            }
            update deliveries;
        Test.stopTest();        
    }    
    
    static testmethod void testDeliveryDriverLeadStatusDelivery2() { 
        Delivery_Object__c[] deliveries = [SELECT Id,Street__c FROM Delivery_Object__c ];
        Test.startTest();
            integer deliverieSize = deliveries.size();
            for (Integer i = 0; i < deliverieSize; i++) {                
                Delivery_Object__c delivery = deliveries[i];
                delivery.name = '2';
                delivery.Delivery_Date__c = DateTime.now();
                delivery.Hung_Status__c = 'Hung';
            }
            update deliveries;
        Test.stopTest();        
    }
    
    @isTest
    static void deliveryEvalTest() {
        List<Delivery_Object__c> deliveries = [
        SELECT 
            Id,
            Hung_Status__c,
            Street__c,
            City__c,
            State__c,
            County__c,
            Maps_latitude__c,
            Maps_longitude__c,
            Geocode_Accuracy__c 
        FROM Delivery_Object__c ];        
        Delivery_Object__c delivery = deliveries[0];
        Delivery_Object__c oldelivery = deliveries[1];
        Test.startTest();
            System.assertEquals(DeliveryEval.addressNoNull(new Delivery_Object__c()),false);
            System.assertEquals(DeliveryEval.locationChange(delivery,oldelivery), false);
            delivery.Street__c  = 'test';
            delivery.City__c    = 'cartagena';
            delivery.State__c   = 'AZ';
            delivery.Zip__c     = '67376';
            delivery.County__c  = 'test';
            delivery.Maps_latitude__c = 1;
            delivery.Maps_longitude__c = 1;
            delivery.Geocode_Accuracy__c = 'Address';
            System.assertEquals(DeliveryEval.locationNoNull(delivery),true);
            System.assertEquals(DeliveryEval.addressChange(delivery,oldelivery), true);
            System.assertEquals(DeliveryEval.geoCodeChange(delivery,oldelivery), true);
            oldelivery.Street__c  = 'test';
            oldelivery.City__c    = 'cartagena';
            oldelivery.State__c   = 'AZ';
            oldelivery.Zip__c     = '67376';
            oldelivery.County__c  = 'test';
            System.assertEquals(DeliveryEval.mapLayerChangeLocation(delivery,oldelivery), true);
        Test.stopTest();
    }
}