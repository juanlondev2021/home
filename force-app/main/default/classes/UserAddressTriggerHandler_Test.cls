/***************************************************************************************************
* Class Name : UserAddressTriggerHandler_Test
* Created By : Sailappa Vignesh
* Created Date : 4/01/2016
* Author : MST
* Description : This class will cover the code coverage for 'UserAddressTriggerHandler' class. 
* Modified By: Ganesh
* Modified on:
* Description: Updated the test class as per best practices.
*******************************************************************************************************/
@isTest(seeAllData = false) 
private class UserAddressTriggerHandler_Test { 
    /*Description : This method will load the test data for test cases.*/
    @testSetup static void loadTestData() {
        TestClassUtil.createZipcodeForBranch();
        TestClassUtil.createAddress(1);
        TestClassUtil.createPersonAddress(false,false);
        TestClassUtil.createCheetahGiftCardOrder();
        TestClassUtil.createDriver();  
        TestClassUtil.createProductAndHungStatus();        
        TestClassUtil.createBranch();
        TestClassUtil.createDeliveryParameter(1);
        TestClassUtil.createUserAddress(1);
        RecordType rt = [SELECT id,Name FROM RecordType WHERE SobjectType = 'Account' and Name = 'Person Account' LIMIT 1];
        User_Address__c userAddr = [SELECT ID, phone__c,Respond_Date__c,PersonMobilePhone__c FROM User_Address__c limit 1];
        Account newAcc = new Account(FirstName = 'Test',
                                     LastName = 'Account Record',
                                     RecordTypeId = rt.Id,
                                     Home_Type__c = 'SF',                                                    
                                     PersonEmail = 'testAcc@ymail.com',
                                     Primary_Shipping_State__c = 'AZ',
                                     Primary_Shipping_County__c = 'Test County',
                                     Primary_Shipping_Zip_Code__c = '27007',
                                     Primary_Shipping_City__c = 'Test City',
                                     Primary_Shipping_Street__c = 'Test Street',
                                     Primary_Shipping_Country__c = 'US',
                                     Sales_Price__c = 1000,
                                     Recording_Date__c = Date.Today(),
                                     Branch__c = 'AZ-Test Branch');
        insert newAcc;
        
        //Industry__c creation
        Industry__c newIndustry = new Industry__c();
        newIndustry.name ='test1';
        newIndustry.Active__c = true;
        newIndustry.OBC_Active__c = true;
        insert newIndustry;
        
    }
    
    public static testmethod void testHouseHoldRespondDate(){
        Test.startTest();
        
        List<User_Address__c> userAddressLst  = new List<User_Address__c>();
        Address__c addressrrec = [SELECT Id FROM Address__c limit 1];
        Account personAcc = [SELECT Id FROM Account limit 1];
        Industry__c industryrec = [SELECT Id,Active__c,OBC_Active__c FROM Industry__c limit 1];
        User_Address__c userAddr = [SELECT ID, phone__c,Respond_Date__c,PersonMobilePhone__c FROM User_Address__c limit 1];
        Gift_Card_Orders__c giftCardOrder = [SELECT ID,name FROM Gift_Card_Orders__c where Name = 'Cheetah Gift Card Order' LIMIT 1];
        Driver__c driver =  [SELECT ID FROM Driver__c LIMIT 1];        
        Branch__c branch = [SELECT ID FROM Branch__c LIMIT 1];
        Delivery_Object__c deliveryObject = new Delivery_Object__c();
        deliveryObject.User_Address__c = userAddr.id;
        deliveryObject.Person_Account__c = personAcc.id;
        deliveryObject.Driver__c = driver.id;
        deliveryObject.name = '1';
        deliveryObject.Branch_Object__c = branch.id;
        deliveryObject.Parent_Gift_Card_Order__c = giftCardOrder.id;            
        deliveryObject.Hung_Status__c = 'Hung';  
        deliveryObject.Delivery_Date__c = system.today() -10;
        
        insert deliveryObject;
        
        
        
        //Create user address with secondary owner and phone 
        User_Address__c userAddrWithPhone = new User_Address__c(Address__c = addressrrec.Id, UserAccount__c = personAcc.Id,
                                                                Phone__c = '8878888676',User_Address_Type__c = 'Secondary Owner',Active__c = true,
                                                                Sales_Price__c = 1000,Recording_Date__c = Date.Today(),
                                                                PersonMobilePhone__c = '8878888676',Respond_date__c = Date.Today());
        userAddressLst.add(userAddrWithPhone);
        //Create user address with secondary owner and phone 
        User_Address__c userAddrWithoutPhone = new User_Address__c(Address__c = addressrrec.Id, UserAccount__c = personAcc.Id,
                                                                   User_Address_Type__c = 'Secondary Owner',Active__c = true,
                                                                   Sales_Price__c = 1000,Recording_Date__c = Date.Today());
        userAddressLst.add(userAddrWithoutPhone);
        User_Address__c userAddrWithoutPhone2 = new User_Address__c(Address__c = addressrrec.Id, UserAccount__c = personAcc.Id,
                                                                    User_Address_Type__c = 'Secondary Owner',Active__c = true,
                                                                    Sales_Price__c = 1000,Recording_Date__c = Date.Today());
        userAddressLst.add(userAddrWithoutPhone2);
        insert userAddressLst;
        
        //Opportunity creation
        Opportunity newOpp = new Opportunity();
        newOpp.Name = 'Test Opp';
        newOpp.AccountId = personAcc.Id;
        newOpp.Type = 'Trade';
        newOpp.stageName = 'Needs Analysis';
        newOpp.closeDate = system.Today();
        insert newOpp;
        system.assertNotEquals(null, newOpp.id);
        
        //OB_Campaign_Call_Center__c creation
        OB_Campaign_Call_Center__c newCC = new OB_Campaign_Call_Center__c();
        newCC.Name = 'NuHome';
        insert newCC;
        system.assertNotEquals(null, newCc.id);
        
        //OB_Campaign__c creation
        OB_Campaign__c newOBC = new OB_Campaign__c();
        newOBC.Opportunity__c = newOpp.Id;
        newOBC.OB_Campaign_Branch__c = 'AZ-Phoenix_East';
        newOBC.OB_Campaign_Call_Center__c = newCC.Id;
        insert newOBC;
        system.assertNotEquals(null, newOBC.id);
        
        //OB_Campaign_Member__c creation
        OB_Campaign_Member__c obcm = new OB_Campaign_Member__c();
        obcm.status_post__c = 'Accepted';
        obcm.AccountName__c = personAcc.Id;
        OBCM.OB_Campaign__c = newOBC.Id;
        OBCM.User_Address__c = userAddrWithPhone.id;
        insert obcm; 
        system.assertNotEquals(null, obcm.id);
        
        OB_Campaign_Member__c obcm2 = new OB_Campaign_Member__c();
        obcm2.status_post__c = 'Accepted';
        obcm2.AccountName__c = personAcc.Id;
        OBCM2.OB_Campaign__c = newOBC.Id;
        OBCM2.User_Address__c = userAddrWithPhone.id;
        insert obcm2; 
        system.assertNotEquals(null, obcm2.id);
        
        //Update phone of secondary owner user address
        userAddrWithoutPhone.Phone__c = '9876543211';
        userAddrWithoutPhone.PersonMobilePhone__c = '9876543211';
        userAddrWithPhone.Respond_date__c = Date.Today();
        update userAddrWithoutPhone;
        
        userAddrWithPhone.Respond_date__c = null;
        userAddrWithPhone.PersonMobilePhone__c = null;
        userAddrWithPhone.phone__c = null;
        update userAddrWithPhone;
        
        Delivery_Object__c deliveryObject2 = new Delivery_Object__c();
        deliveryObject2.User_Address__c = userAddrWithoutPhone.id;
        deliveryObject2.Person_Account__c = personAcc.id;
        deliveryObject2.Driver__c = driver.id;
        deliveryObject2.name = '2';
        deliveryObject2.Branch_Object__c = branch.id;
        deliveryObject2.Parent_Gift_Card_Order__c = giftCardOrder.id;            
        deliveryObject2.Hung_Status__c = 'Sent To Cheetah';  
        deliveryObject2.Delivery_Date__c = system.today() -10;
        
        insert deliveryObject2;
        
        Test.stopTest();
    }
    
}