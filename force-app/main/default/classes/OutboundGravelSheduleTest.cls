@isTest
private class OutboundGravelSheduleTest {
    @TestSetup
    static void makeData() {
        
        TestClassUtil.createAccount(1);

        Id accountID = [SELECT Id FROM Account LIMIT 1]?.Id;
        
        Address__c address = new Address__c();
        address.city__c = 'Test';
        address.county__c= 'Test';
        address.street__c= 'Test Street';
        address.zip_code__c= '85014';
        address.Region_Code__c = '12345';
        insert address;    

        List<User_Address__c> userAddress = new List<User_Address__c>();
        for (Integer i = 0; i < 10; i++) {
            userAddress.add(
                new User_Address__c(
                    Address__c = address.id, 
                    UserAccount__c = accountID,
                    User_Address_Type__c = 'Primary Owner',
                    Active__c = true,
                    Respond_date__c = Date.Today().addDays(-1)
                    )            
                );
        }
        insert userAddress;

        for (Integer i = 0; i < 10; i++) {
            userAddress[i].Phone__c = '1234556770';
        }
        update userAddress;
    }
    static testmethod void testScheduledJob() {
        Test.startTest();
            // Create the mock response based on a static resource
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('PostUserAddressResponse');
            mock.setStatusCode(200);
            mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
            // Associate the callout with a mock response
            Test.setMock(HttpCalloutMock.class, mock);

            // Schedule
            String CRON_EXP = '0 0 0 15 3 ? 2022';
            String jobId = System.schedule('OutboundGravel',
                CRON_EXP,
                new OutboundGravelShedule());
        Test.stopTest();
    }
}