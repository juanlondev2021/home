@isTest
private class DiacoMapsDriverControllerTest {
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
    
    @isTest
    static void test() {
        
        // create Delivery
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
        
        test.startTest();
        	insert deliveryObjectLst;
            maps__Route__c route1 = new maps__Route__c(Name='Test',maps__Date__c=Date.today());
            insert route1;
            maps__Waypoint__c route = new maps__Waypoint__c(Name='Test',maps__Route__c=route1.id,Delivery_Object__c=deliveryObjectLst[0].id);
            insert route;
        	DiacoMapsDriverController.WrappedResponse response = DiacoMapsDriverController.getData(deliveryObjectLst[0].Id,false);
        	DiacoMapsDriverController.updateRoute(true, response.Waypoint.maps__Route__c);
        	response = DiacoMapsDriverController.getData(deliveryObjectLst[0].Id,true);
        	DiacoMapsDriverController.setDelivery(response.delivery,response.Waypoint);
        	response = DiacoMapsDriverController.getData(deliveryObjectLst[0].Id,false);
        	DiacoMapsDriverController.updateRoute(false, response.Waypoint.maps__Route__c);
        	response = DiacoMapsDriverController.getData(deliveryObjectLst[1].Id,true);
        	//response = DiacoMapsDriverController.getData(deliveryObjectLst[0].Id,false);
        	
        test.stopTest();
    }
}