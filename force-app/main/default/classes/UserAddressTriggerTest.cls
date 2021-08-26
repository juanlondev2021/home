/**
 * @description       : 
 * @author            : William Aldana
 * @group             : 
 * @last modified on  : 09-29-2020
 * @last modified by  : William Aldana
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   09-24-2020   William Aldana   Initial Version
**/
@isTest
private class UserAddressTriggerTest {
    
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

    @istest public static void testHouseHoldRespondDate(){
        //try {
            Test.startTest();
            Personnel__c per = new Personnel__c(Name='Test',Kunnect_ID__c='none',SF_User__c=UserInfo.getUserId(),salesRabbitUserId__c='1235');
        	insert per;
            List<User_Address__c> userAddressLst  = new List<User_Address__c>();
            Address__c addressrrec = [SELECT Id FROM Address__c limit 1];
            Account personAcc = [SELECT Id FROM Account limit 1];
            //Industry__c industryrec = [SELECT Id,Active__c,OBC_Active__c FROM Industry__c limit 1];
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
            /*
            //OB_Campaign__c creation
            OB_Campaign__c newOBC = new OB_Campaign__c();
            newOBC.Opportunity__c = newOpp.Id;
            newOBC.OB_Campaign_Branch__c = 'AZ-Phoenix_East';
            newOBC.OB_Campaign_Call_Center__c = newCC.Id;
            insert newOBC;
            system.assertNotEquals(null, newOBC.id);*/
            /*
            //OB_Campaign_Member__c creation
            OB_Campaign_Member__c obcm = new OB_Campaign_Member__c();
            obcm.status_post__c = 'Accepted';
            obcm.AccountName__c = personAcc.Id;
            OBCM.OB_Campaign__c = newOBC.Id;
            OBCM.User_Address__c = userAddrWithPhone.id;
            insert obcm; 
            system.assertNotEquals(null, obcm.id);*/
            /*
            OB_Campaign_Member__c obcm2 = new OB_Campaign_Member__c();
            obcm2.status_post__c = 'Accepted';
            obcm2.AccountName__c = personAcc.Id;
            OBCM2.OB_Campaign__c = newOBC.Id;
            OBCM2.User_Address__c = userAddrWithPhone.id;
            insert obcm2; 
            system.assertNotEquals(null, obcm2.id);*/
            
            //Update phone of secondary owner user address
            userAddrWithoutPhone.Phone__c = '9876543211';
            userAddrWithoutPhone.PersonMobilePhone__c = '9876543211';
            userAddrWithPhone.Respond_date__c = Date.Today();
            userAddrWithPhone.Inbound_Verification_Code_Date__c = DateTime.now();
            update userAddrWithoutPhone;
            
            userAddrWithPhone.Respond_date__c = null;
            userAddrWithPhone.PersonMobilePhone__c = null;
            userAddrWithPhone.phone__c = null;
            update userAddrWithPhone;
            /*
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
            */
            Test.stopTest();
        /*
        } catch (Exception ex) {
            System.debug(ex.getStackTraceString());        
        }*/
    }
	/*
    @isTest static void TestSalesRabbitIntegration() {
        
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        insert r;
        User user = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserRoleId = r.Id
        );
        insert user;
        
        
        
        
        
        System.runAs ( user ) {
            Personnel__c personnel = new Personnel__c(
                    Name = 'tst',
                    Kunnect_ID__c = 'none',
                    salesRabbitUserId__c = '911705138',
                	SF_User__c = user.Id
            );
            insert personnel;
            salesRabbitSchedule__c customsetting = new salesRabbitSchedule__c(
                    quantityDayOrHour__c = 2,
                    options__c = 'hours',
                    knockCounter__c = 5,
                    deleteAfter__c = 5,
                    minSalePrice__c = 20000,
                    maxSalePrice__c = 100000,
                    deleteAfterOptions__c = 'days',
                	token__c = 'T3ok8e9nt7e4s1t1'
            );
            upsert customsetting;
            Account acc = new Account(
                FirstName ='test',
                LastName = 'test',
                Phone = '6643433',
                PersonMobilePhone = '1234567890',
                Street__c = 'cll 43',
                State__c = 'CO',
                City__c = 'cartagena',
                Zip__c  = '12345'
            );
            insert acc;
            Address__c ads = new Address__c(
                City__c = 'cartagena',
                Country__c = 'US',
                State__c = 'CO',
                Street__c = 'test',
                Zip_Code__c = '12352'
            );
            insert ads;
            User_Address__c uadd = new User_Address__c(
                Email__c = 'test@test.com',
                Phone__c = '6627786',
                status__c ='Other',
                knock_counter__c = 4,
                PersonMobilePhone__c= '3014263364',
                UserAccount__c = acc.Id,
                Address__c = ads.Id,
                sales_rabbit_leadId__c = '85',
                Sales_Price__c = 50000               
            );
            insert uadd;
            User_Address__c uadd2 = new User_Address__c(
                Email__c = 'test@test.com',
                Phone__c = '6627786',
                status__c ='Other',
                knock_counter__c = 3,
                PersonMobilePhone__c= '3014263364',
                UserAccount__c = acc.Id,
                Address__c = ads.Id,
                sales_rabbit_leadId__c = '85',
                Sales_Price__c = 50000
            );
            insert uadd2;
            neverBounce__c nb = new neverBounce__c(
                Job_id__c = '277461',
                number_of_pages__c = 10,
                next_page__c = 1, 
                ApiKey__c = 'Apikey******', 
                First_Job__c = 3, 
                Second_Job__c =1, 
                Emails_per_page__c = 10 
            );
            upsert nb;
            

            String token = 'e9d241343edfbe085176aeae2661282c8cb8e62490ff5b09563dddf22523158ed53b2142cd9e4f3d551c375b6489eaebac663f7eca480dd002c4c44fc357c307'; 
            String body = '{"data": {"userId":911705138,"firstName":"jorge test","lastName":"martinez","phonePrimary":"6627786","phoneAlternate":"(301) 426-3364","street1":"la candelaria","city":"cartagena","state":"AR","zip":"523621","status":"New Lead","email":"test@test.com"}}';
            Date ifModifiedSince = Date.newInstance(2018, 08, 07);
            
            Integer leadId = 85;
            Test.setMock(HttpCalloutMock.class, new DiacoSalesRabbitIntegrationCalloutMock());
            Test.startTest();
            DiacoSalesRabbitIntegration.leadsToUpdate(
                DiacoSalesRabbitIntegration.allLeads(token, ifModifiedSince)
            );
            DiacoSalesRabbitIntegration.createLeadSR(token, body, uadd.Id);
            DiacoSalesRabbitIntegration.createLeads(token, body);
            DiacoSalesRabbitIntegration.dateStmap('2018-08-16T17:51:02+00:00');
            DiacoSalesRabbitIntegration.allLeadsSR(token, ifModifiedSince);
            DiacoSalesRabbitIntegration.deleteLead(token, leadId);
            Test.stopTest();
            
        }
    }*/   
}