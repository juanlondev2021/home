@isTest
public class InboundKunnectTest {
    
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
            String jobId = System.schedule('Sync KunnectDB User Address',
                CRON_EXP,
                new InboundKunnectJob());
        Test.stopTest();
    }
    
    static testmethod void testScheduledJob2() {
        Test.startTest();
        // Create the mock response based on a static resource
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        	mock.setStaticResource('PostUserAddressResponse');
            mock.setStatusCode(400);
            mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
            // Associate the callout with a mock response
            Test.setMock(HttpCalloutMock.class, mock);

            // Schedule
            String CRON_EXP = '0 0 0 15 3 ? 2022';
            String jobId = System.schedule('Sync KunnectDB User Address',
                CRON_EXP,
                new InboundKunnectJob());
        Test.stopTest();
    }

}