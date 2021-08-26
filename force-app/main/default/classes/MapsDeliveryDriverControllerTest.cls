@isTest
private class MapsDeliveryDriverControllerTest {
    @testSetup static void loadTestData() {
        TestClassUtil.createZipcodeForBranch();
        TestClassUtil.createAccount(5);
        TestClassUtil.createCheetahGiftCardOrder();
        TestClassUtil.createDriver(); 
        TestClassUtil.createAddress(5);
        TestClassUtil.createUserAddress(3);  
		String s = '"Hometype","Rental","New","SalePrice","Down","Firstname","Lastname","phone","address","city","state","plus4","zip","DATE","PostDate","Update","County","FileNumber","BMPS"\n'+
        '"SF",,,510000.00,288329.00,"OMAR","GASTELUM COTA",,"6303 N 65TH DR","GLENDALE","AZ","4315","85301","3/31/2021",4/2/2021 0:00:00,,"MARICOPA","20210359061","14415011"\n'+
        '"SF",,"N",342990.00,10289.00,"PETER & CAROL","VALENTINO",,"2727 W APOLLO RD","PHOENIX","AZ","5486","85041","3/31/2021",4/2/2021 0:00:00,,"MARICOPA","20210359063","10592048"\n'+
        '"SF",,,364000.00,36400.00,"MARGARET","JOHNSON",,"3813 E PARK AVE","PHOENIX","AZ","8255","85044","3/31/2021",4/2/2021 0:00:00,,"MARICOPA","20210359070","30601625"\n'+
        '"CT",,,265000.00,105000.00,"KEITH & KIMBERLY","EWING",,"2101 S YELLOW WOOD UNIT 14","MESA","AZ","1486","85209","3/31/2021",4/2/2021 0:00:00,,"MARICOPA","20210359072","31212008"\n'+
        '"SF",,,650000.00,154000.00,"MICHAEL","ALLEN",,"26250 N 46TH ST","PHOENIX","AZ","8510","85050","3/31/2021",4/2/2021 0:00:00,,"MARICOPA","20210359082","21209227"\n'+
        '"SF",,"N",469699.00,23485.00,"ARIEL & TROY","AUELUA",,"4706 S MARS","MESA","AZ","3270","85212","3/31/2021",4/2/2021 0:00:00,,"MARICOPA","20210359089","31216546"\n'+
        '"SF",,,610000.00,610000.00,"PAUL","INDELICATO",,"8212 E SHERIDAN ST","SCOTTSDALE","AZ","2344","85257","3/31/2021",4/2/2021 0:00:00,,"MARICOPA","20210359156","13133059"\n'+
        '"SF",,,585000.00,58500.00,"BRIAN & LAUREN","WEST",,"2481 E BELLERIVE PL","CHANDLER","AZ","4142","85249","3/31/2021",4/2/2021 0:00:00,,"MARICOPA","20210359164","30356382"';
        String contractName = 'test document 3';
        ContentVersion cv = new ContentVersion();
        cv.ContentLocation = 'S';
        cv.PathOnClient = '.csv';
        //cv.OwnerId = at.OwnerId;
        cv.Title = contractName;
        cv.VersionData = blob.valueOf(s);
        insert cv;
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
                delivery.Hung_Status__c = 'Sent To Cheetah';  
                if ( i > 5 ) {
                    delivery.Cheetah_Driver_Code__c = 'invalid 728337';
                }         
                deliveries.add(delivery);   
            }

            insert deliveries;
    }	

    @IsTest
    static void test(){
        Delivery_Object__c[] deliveries = [SELECT Id,Street__c FROM Delivery_Object__c ];
        Test.setMock(HttpCalloutMock.class, new MapsDeliveryDriverControllerMockTest());
        Test.startTest();
    
            maps__Route__c route = new maps__Route__c(Name='Test',maps__Date__c=Date.today(),maps__User__c = UserInfo.getUserId() ) ;
            insert route;
            maps__Waypoint__c point = new maps__Waypoint__c(Name='Test',maps__Route__c=route.id,Delivery_Object__c=deliveries[0].id);
            insert point;
            MapsDeliveryDriverController.getData();
            String ids = [select ContentDocumentId from ContentVersion where Title='test document 3'].contentdocumentId;
            system.debug(ids);
            MapsDeliveryDriverController.uploadPhoto(ids,deliveries[0].id);
        Test.stopTest();
        
    }
}