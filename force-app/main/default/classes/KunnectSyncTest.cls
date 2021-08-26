@Istest
private class KunnectSyncTest {
    @TestSetup
    static void makeData() {
        
        TestClassUtil.createAccount(1);

        Id accountID = [SELECT Id FROM Account LIMIT 1]?.Id;        

        List<User_Address__c> userAddress = new List<User_Address__c>();
        for (Integer i = 0; i < 10; i++) {
            userAddress.add(
                new User_Address__c(
                    //Address__c = address[j].id, 
                    UserAccount__c = accountID,
                    User_Address_Type__c = 'Primary Owner',
                    Active__c = true,
                    Respond_date__c = Date.Today().addDays(-1)
                    )            
                );
        }
        insert userAddress;

        /*for (Integer i = 0; i < 10; i++) {
            userAddress[i].Phone__c = '1234556770';
        }
        update userAddress;*/
    }
    
    @IsTest
    static void methodName() {
        
        Test.startTest();
        // Create the mock response based on a static resource
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('PostUserAddressResponse');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Associate the callout with a mock response
        Test.setMock(HttpCalloutMock.class, mock);

        KunnectUsAddressDTO requestUserAddress = new KunnectUsAddressDTO();
        requestUserAddress.endPoint = 'test';

        KunnectSync inboundKunnect = new KunnectSync();
        inboundKunnect.syncUserAddress('test', requestUserAddress);

        Test.stopTest();
    }
}