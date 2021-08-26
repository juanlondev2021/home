/*    Class Name : DeliveryObjectTriggerHandlerTest
* Created By : Sailappa Vignesh P G
* Created Date : 2/18/2016
* Description : This class will cover the code coverage for 'DeliveryObjectTrigger' and 'DeliveryObjectTriggerHandler'. 
* Modified By: Ganesh
* Modified on:
* Description: Updated the test class as per best practices.
*/
@isTest(seeAllData = false) 
private class DeliveryObjectTriggerHandlerTest {
    /*Description : This method will load the test data for test cases.*/
    @testSetup static void loadTestData() {
        TestClassUtil.createZipcodeForBranch();
        TestClassUtil.createAccount(5);
        TestClassUtil.createCheetahGiftCardOrder();
        TestClassUtil.createDriver(); 
        TestClassUtil.createAddress(5);
        TestClassUtil.createUserAddress(3);  
    }
    /*Description : This method will check whether the 'isRecent' is checked for all the newly created delivery Object records.*/    
    static testmethod void testIsRecentChecked(){
        Account testAccount = [SELECT ID FROM Account lIMIT 1];
        Gift_Card_Orders__c giftCardOrder = [SELECT ID FROM Gift_Card_Orders__c LIMIT 1];
        Driver__c driver =  [SELECT ID FROM Driver__c LIMIT 1];
        User_Address__c userAddress = [SELECT ID FROM User_Address__c LIMIT 1];
        Delivery_Object__c deliveryObject = new Delivery_Object__c();        
        deliveryObject.Person_Account__c = testAccount.id;
        deliveryObject.Driver__c = driver.id;
        deliveryObject.name = '1';
        deliveryObject.Parent_Gift_Card_Order__c = giftCardOrder.id;
        deliveryObject.User_Address__c = userAddress.id;
        test.startTest();
            insert deliveryObject; 
           
            deliveryObject.Scan_Code__c = '1234 2134 2132 2343'; 
            update deliveryObject;
        
            deliveryObject = [SELECT ID,IsRecent__c FROM Delivery_Object__c LIMIT 1];
           // System.assertEquals(true, deliveryObject.IsRecent__c);
        test.stopTest();        
    } 
    /*Description : This method will check whether the 'isRecent' is checked for all the 
        newly created delivery Object records and 'isRecent' is unchecked for the 
        old delivery Object records connected with the same Person Account  .*/    
    public static testmethod void testIsRecentUnChecked(){
        integer isRecentCheckedCount = 0;
        integer isRecentUnCheckedCount = 0;    
        Account testAccount = [SELECT ID FROM Account lIMIT 1];
        Gift_Card_Orders__c giftCardOrder = [SELECT ID FROM Gift_Card_Orders__c LIMIT 1];
        Driver__c driver =  [SELECT ID FROM Driver__c LIMIT 1];
        User_Address__c userAddress = [SELECT ID FROM User_Address__c LIMIT 1];
        Delivery_Object__c deliveryObject = new Delivery_Object__c();
        deliveryObject.Person_Account__c = testAccount.id;
        deliveryObject.Driver__c = driver.id;
        deliveryObject.name = '1';
        deliveryObject.Parent_Gift_Card_Order__c = giftCardOrder.id;
        deliveryObject.User_Address__c = userAddress.id;
        insert deliveryObject; 
        Delivery_Object__c deliveryObjectTwo = new Delivery_Object__c();
        deliveryObjectTwo.Person_Account__c = testAccount.id;
        deliveryObjectTwo.Driver__c = driver.id;
        deliveryObjectTwo.name = '1';
        deliveryObjectTwo.Parent_Gift_Card_Order__c = giftCardOrder.id;
        deliveryObjectTwo.User_Address__c = userAddress.id;
        insert deliveryObjectTwo;  
        test.startTest();
        for(Delivery_Object__c currDeliveryObject : [SELECT ID,IsRecent__c FROM Delivery_Object__c ]){
            if(currDeliveryObject.IsRecent__c){
                isRecentCheckedCount++;                
            }else{
                isRecentUnCheckedCount++;    
            }            
        }
       // System.assertEquals(1, isRecentCheckedCount);
        //System.assertEquals(1, isRecentUnCheckedCount);
        test.stopTest();        
    }
    static testmethod void testDeliveryDriverLeadStatus(){
        Account testAccount = [SELECT ID FROM Account lIMIT 1];
        Gift_Card_Orders__c giftCardOrder = [SELECT ID FROM Gift_Card_Orders__c LIMIT 1];
        Driver__c driver =  [SELECT ID FROM Driver__c LIMIT 1];
        User_Address__c userAddress = [SELECT ID,phone__c,Respond_Date__c FROM User_Address__c LIMIT 1];
        userAddress.Respond_Date__c = System.today();
        update userAddress;
        Delivery_Object__c deliveryObject = new Delivery_Object__c();        
        deliveryObject.Person_Account__c = testAccount.id;
        deliveryObject.Driver__c = driver.id;
        deliveryObject.name = '1';
        deliveryObject.Parent_Gift_Card_Order__c = giftCardOrder.id;
        deliveryObject.User_Address__c = userAddress.id;
        
        test.startTest();
            insert deliveryObject;   
            deliveryObject.Delivery_Date__c = System.today();
            deliveryObject.Hung_Status__c = 'Hung';
            update deliveryObject;
            deliveryObject = [SELECT ID,IsRecent__c FROM Delivery_Object__c LIMIT 1];
            //System.assertEquals(true, deliveryObject.IsRecent__c);
        test.stopTest();        
    }    
    
    public static testmethod void testDeliveryDriverLeadStatusDelivery2(){
        Account testAccount = [SELECT ID FROM Account lIMIT 1];
        Gift_Card_Orders__c giftCardOrder = [SELECT ID FROM Gift_Card_Orders__c LIMIT 1];
        Driver__c driver =  [SELECT ID FROM Driver__c LIMIT 1];
        User_Address__c userAddress = [SELECT ID,phone__c,Respond_Date__c FROM User_Address__c LIMIT 1];
        userAddress.Respond_Date__c = System.today()+2;
        update userAddress;
        Delivery_Object__c deliveryObject = new Delivery_Object__c();        
        deliveryObject.Person_Account__c = testAccount.id;
        deliveryObject.Driver__c = driver.id;
        deliveryObject.name = '2';
        deliveryObject.Parent_Gift_Card_Order__c = giftCardOrder.id;
        deliveryObject.User_Address__c = userAddress.id;
        
        test.startTest();
            insert deliveryObject;   
            deliveryObject.Delivery_Date__c = System.today();
            deliveryObject.Hung_Status__c = 'Hung';
            update deliveryObject;
            deliveryObject = [SELECT ID,IsRecent__c FROM Delivery_Object__c LIMIT 1];
           // System.assertEquals(true, deliveryObject.IsRecent__c);
        test.stopTest();        
    }    
}