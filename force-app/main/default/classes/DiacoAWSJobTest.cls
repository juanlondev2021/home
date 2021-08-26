@isTest
public class DiacoAWSJobTest {
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    static testmethod void testScheduledJob() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new diacoSendSweepstakeHttpCallOutMock());
        // Schedule the test job
        String jobId = System.schedule('ScheduledApexTest',
            CRON_EXP, 
            new DiacoAWSJob());

        String jobId2 = System.schedule('ScheduledApexTest2',
        CRON_EXP, 
        new DiacoFtpJob());
        
        Test.stopTest();
    }
}