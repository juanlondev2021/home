/************************************************************************************************* 
* Class Name : DeliveryObjectTriggerHandlerTest
* Created By : Sailappa Vignesh P G
* Created Date : 2/18/2016
* Description : This class will cover the code coverage for 'CreateDeliveryObject' batch class. 
**************************************************************************************************/
@isTest(seeAllData = false) 
public class CreateDeliveryObjectTest { 
    /*Description : This method will load the test data for test cases.*/
    @testSetup static void loadTestData() {
        TestClassUtil.createZipcodeForBranch();
        TestClassUtil.createAccount(2);
        TestClassUtil.createCheetahGiftCardOrder();
        TestClassUtil.createDriver();  
        TestClassUtil.createProductAndHungStatus();
        //TestClassUtil.createPersonAddress();
        TestClassUtil.createBranch();
        TestClassUtil.createAddress(2);
        TestClassUtil.createUserAddress(2);
        TestClassUtil.createDeliveryParameter(1);
   } 
    /*Description : This method will check the Hung Status of the Delivery Object record and will create additional Delivery Object record and this method is to the 'Cant Find' status */
    public static testmethod void testCantFindStatus(){        
        Gift_Card_Orders__c giftCardOrder = [SELECT ID FROM Gift_Card_Orders__c LIMIT 1];
        Driver__c driver =  [SELECT ID FROM Driver__c LIMIT 1];
        //User_Address__c userAddress = [SELECT ID FROM User_Address__c LIMIT 1];
        Branch__c branch = [SELECT ID FROM Branch__c LIMIT 1];
        List<Delivery_Object__c> deliveryObjectLst = new List<Delivery_Object__c>();
        for(User_Address__c currUserAddress : [SELECT Id,UserAccount__c FROM User_Address__c]){
            Delivery_Object__c deliveryObject = new Delivery_Object__c();
            deliveryObject.Person_Account__c = currUserAddress.UserAccount__c;
            deliveryObject.User_Address__c = currUserAddress.Id;
            deliveryObject.Driver__c = driver.id;
            deliveryObject.name = '1';
            deliveryObject.Branch_Object__c = branch.id;
            deliveryObject.Parent_Gift_Card_Order__c = giftCardOrder.id;
          //  deliveryObject.User_Address__c = userAddress.id;
            deliveryObject.Hung_Status__c = 'Cant Find';            
            deliveryObjectLst.add(deliveryObject);
        }
        insert deliveryObjectLst;
        for(Delivery_Object__c currDeliveryObject : deliveryObjectLst){
            currDeliveryObject.Delivery_Date__c = System.now() - 1;    
        }
        update deliveryObjectLst;
        Test.startTest();
        CreateDeliveryObject DeliveryObjectBatch = new CreateDeliveryObject();
        Database.executeBatch(DeliveryObjectBatch); 
        Test.stopTest();
        //System.assertEquals(200, [SELECT ID FROM Delivery_Object__c].Size());
        System.assert(Limits.getDMLRows() * 100 / Limits.getLimitDMLRows() < 50);
        System.assert(Limits.getDMLStatements() * 100 / Limits.getLimitDMLStatements() < 50);
        System.assert(Limits.getAggregateQueries() * 100 / Limits.getLimitAggregateQueries() < 50);
        System.assert(Limits.getQueries() * 100 / Limits.getLimitQueries() < 50);
        System.assert(Limits.getQueryRows() * 100 / Limits.getLimitQueryRows() < 50);
    }
       /*Description : This method will check the Hung Status of the Delivery Object record and will create additional Delivery Object record and this method is to the 'Gated' status */
    public static testmethod void testGatedStatus(){        
        Gift_Card_Orders__c giftCardOrder = [SELECT ID FROM Gift_Card_Orders__c LIMIT 1];
        Driver__c driver =  [SELECT ID FROM Driver__c LIMIT 1];
        //User_Address__c userAddress = [SELECT ID FROM User_Address__c LIMIT 1];
        Branch__c branch = [SELECT ID FROM Branch__c LIMIT 1];
        List<Delivery_Object__c> deliveryObjectLst = new List<Delivery_Object__c>();
        for(User_Address__c currUserAddress : [SELECT Id,UserAccount__c FROM User_Address__c]){
            Delivery_Object__c deliveryObject = new Delivery_Object__c();
            deliveryObject.Person_Account__c = currUserAddress.UserAccount__c;
            deliveryObject.User_Address__c = currUserAddress.Id;
            deliveryObject.Driver__c = driver.id;
            deliveryObject.name = '1';
            deliveryObject.Branch_Object__c = branch.id;
            deliveryObject.Parent_Gift_Card_Order__c = giftCardOrder.id;
            deliveryObject.Hung_Status__c = 'Gated';  
            //deliveryObject.User_Address__c = userAddress.id;
            deliveryObjectLst.add(deliveryObject);
            
        }
        insert deliveryObjectLst;
        for(Delivery_Object__c currDeliveryObject : deliveryObjectLst){
            currDeliveryObject.Delivery_Date__c = System.now() - 7;    
        }
        update deliveryObjectLst;
        Test.startTest();
        CreateDeliveryObject DeliveryObjectBatch = new CreateDeliveryObject();
        Database.executeBatch(DeliveryObjectBatch);        
        Test.stopTest();
       // System.assertEquals(200, [SELECT ID FROM Delivery_Object__c].Size());
        System.assert(Limits.getDMLRows() * 100 / Limits.getLimitDMLRows() < 50);
        System.assert(Limits.getDMLStatements() * 100 / Limits.getLimitDMLStatements() < 50);
        System.assert(Limits.getAggregateQueries() * 100 / Limits.getLimitAggregateQueries() < 50);
        System.assert(Limits.getQueries() * 100 / Limits.getLimitQueries() < 50);
        System.assert(Limits.getQueryRows() * 100 / Limits.getLimitQueryRows() < 50);
    }
    /*Description : This method will check the Hung Status of the Delivery Object record and will create additional Delivery Object record and this method is to the 'Too Far' status */
    public static testmethod void testTooFarStatus(){        
        Gift_Card_Orders__c giftCardOrder = [SELECT ID FROM Gift_Card_Orders__c LIMIT 1];
        Driver__c driver =  [SELECT ID FROM Driver__c LIMIT 1];
        //User_Address__c userAddress = [SELECT ID FROM User_Address__c LIMIT 1];
        Branch__c branch = [SELECT ID FROM Branch__c LIMIT 1];
        List<Delivery_Object__c> deliveryObjectLst = new List<Delivery_Object__c>();
        for(User_Address__c currUserAddress : [SELECT Id,UserAccount__c FROM User_Address__c]){
            Delivery_Object__c deliveryObject = new Delivery_Object__c();
            deliveryObject.Person_Account__c = currUserAddress.UserAccount__c;
            deliveryObject.User_Address__c = currUserAddress.Id;
            deliveryObject.Driver__c = driver.id;
            deliveryObject.name = '1';
            deliveryObject.Branch_Object__c = branch.id;
            deliveryObject.Parent_Gift_Card_Order__c = giftCardOrder.id;
            deliveryObject.Hung_Status__c = 'Too Far';   
            //deliveryObject.User_Address__c = userAddress.id;
            deliveryObjectLst.add(deliveryObject);
            
        }
        insert deliveryObjectLst;
        for(Delivery_Object__c currDeliveryObject : deliveryObjectLst){
            currDeliveryObject.Delivery_Date__c = System.now() - 1;    
        }
        update deliveryObjectLst;
        Test.startTest();
        CreateDeliveryObject DeliveryObjectBatch = new CreateDeliveryObject();
        Database.executeBatch(DeliveryObjectBatch);
        Test.stopTest();
        //System.assertEquals(200, [SELECT ID FROM Delivery_Object__c].Size());
        System.assert(Limits.getDMLRows() * 100 / Limits.getLimitDMLRows() < 50);
        System.assert(Limits.getDMLStatements() * 100 / Limits.getLimitDMLStatements() < 50);
        System.assert(Limits.getAggregateQueries() * 100 / Limits.getLimitAggregateQueries() < 50);
        System.assert(Limits.getQueries() * 100 / Limits.getLimitQueries() < 50);
        System.assert(Limits.getQueryRows() * 100 / Limits.getLimitQueryRows() < 50);
    }
    /*Description : This method will check the Hung Status of the Delivery Object record and will create additional Delivery Object record and this method is to the 'Under Construction' status */
    public static testmethod void testUnderConstructionStatus(){        
        Gift_Card_Orders__c giftCardOrder = [SELECT ID FROM Gift_Card_Orders__c LIMIT 1];
        Driver__c driver =  [SELECT ID FROM Driver__c LIMIT 1];
        Branch__c branch = [SELECT ID FROM Branch__c LIMIT 1];
        //User_Address__c userAddress = [SELECT ID FROM User_Address__c LIMIT 1];
        List<Delivery_Object__c> deliveryObjectLst = new List<Delivery_Object__c>();
        for(User_Address__c currUserAddress : [SELECT Id,UserAccount__c FROM User_Address__c]){
            Delivery_Object__c deliveryObject = new Delivery_Object__c();
            deliveryObject.Person_Account__c = currUserAddress.UserAccount__c;
            deliveryObject.User_Address__c = currUserAddress.Id;
            deliveryObject.Driver__c = driver.id;
            deliveryObject.name = '1';
            deliveryObject.Branch_Object__c = branch.id;
            deliveryObject.Parent_Gift_Card_Order__c = giftCardOrder.id;
            deliveryObject.Hung_Status__c = 'Under Construction';   
            //deliveryObject.User_Address__c = userAddress.id;
            deliveryObjectLst.add(deliveryObject);
            
        }
        insert deliveryObjectLst;
        for(Delivery_Object__c currDeliveryObject : deliveryObjectLst){
            currDeliveryObject.Delivery_Date__c = System.now() - 30;    
        }
        update deliveryObjectLst;
        Test.startTest();
        CreateDeliveryObject DeliveryObjectBatch = new CreateDeliveryObject();
        Database.executeBatch(DeliveryObjectBatch);
        Test.stopTest();
       // System.assertEquals(200, [SELECT ID FROM Delivery_Object__c].Size());
        System.assert(Limits.getDMLRows() * 100 / Limits.getLimitDMLRows() < 50);
        System.assert(Limits.getDMLStatements() * 100 / Limits.getLimitDMLStatements() < 50);
        System.assert(Limits.getAggregateQueries() * 100 / Limits.getLimitAggregateQueries() < 50);
        System.assert(Limits.getQueries() * 100 / Limits.getLimitQueries() < 50); 
        System.assert(Limits.getQueryRows() * 100 / Limits.getLimitQueryRows() < 50);
    }
    /*Description : This method will check the Hung Status of the Delivery Object record and will create additional Delivery Object record and this method is to the 'Cancelled' status */
    public static testmethod void testCancelledStatus(){        
        Gift_Card_Orders__c giftCardOrder = [SELECT ID FROM Gift_Card_Orders__c LIMIT 1];
        Driver__c driver =  [SELECT ID FROM Driver__c LIMIT 1];
        //User_Address__c userAddress = [SELECT ID FROM User_Address__c LIMIT 1];
        Branch__c branch = [SELECT ID FROM Branch__c LIMIT 1];
        List<Delivery_Object__c> deliveryObjectLst = new List<Delivery_Object__c>();
        for(User_Address__c currUserAddress : [SELECT Id,UserAccount__c FROM User_Address__c]){
            Delivery_Object__c deliveryObject = new Delivery_Object__c();
            deliveryObject.Person_Account__c = currUserAddress.UserAccount__c;
            deliveryObject.User_Address__c = currUserAddress.Id;
            deliveryObject.Driver__c = driver.id;
            deliveryObject.name = '1';
            deliveryObject.Branch_Object__c = branch.id;
            deliveryObject.Parent_Gift_Card_Order__c = giftCardOrder.id;
            deliveryObject.Hung_Status__c = 'Cancelled';   
            //deliveryObject.User_Address__c = userAddress.id;
            deliveryObjectLst.add(deliveryObject);
            
        }
        insert deliveryObjectLst;
        for(Delivery_Object__c currDeliveryObject : deliveryObjectLst){
            currDeliveryObject.Delivery_Date__c = System.now() - 1;    
        }
        update deliveryObjectLst;
        Test.startTest();
        CreateDeliveryObject DeliveryObjectBatch = new CreateDeliveryObject();
        Database.executeBatch(DeliveryObjectBatch);
        Test.stopTest();
       // System.assertEquals(200, [SELECT ID FROM Delivery_Object__c].Size());
        System.assert(Limits.getDMLRows() * 100 / Limits.getLimitDMLRows() < 50);
        System.assert(Limits.getDMLStatements() * 100 / Limits.getLimitDMLStatements() < 50);
        System.assert(Limits.getAggregateQueries() * 100 / Limits.getLimitAggregateQueries() < 50);
        System.assert(Limits.getQueries() * 100 / Limits.getLimitQueries() < 50);
        System.assert(Limits.getQueryRows() * 100 / Limits.getLimitQueryRows() < 50);
    } 
}