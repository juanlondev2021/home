@IsTest
private class SyncKunnectUsAddressTest {
    @TestSetup
    static void makeData() {

        TestClassUtil.createAccount(1);

        Id accountID = [SELECT Id FROM Account LIMIT 1]?.Id;        

        List<User_Address__c> userAddress = new List<User_Address__c>();
        for (Integer j = 0; j < 10; j++) {
            userAddress.add(
                new User_Address__c(
                    //Address__c = address[j].id, 
                    UserAccount__c = accountID,
                    User_Address_Type__c = 'Primary Owner',
                    Active__c = true,
                    Sales_Price__c = 1000,
                    Recording_Date__c = Date.Today(),
                    Respond_date__c = Date.Today())
            );
        }
        insert userAddress;
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
            String jobId = System.schedule('SyncKunnectUsAddressShedule',
                CRON_EXP,
                new SyncKunnectUsAddressShedule());
        Test.stopTest();
    }
}