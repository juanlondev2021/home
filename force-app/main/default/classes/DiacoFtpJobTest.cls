@isTest
public class DiacoFtpJobTest {
    
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    static testmethod void testScheduledJob() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new diacoSendSweepstakeHttpCallOutMock());
        // Schedule the test job
        String jobId = System.schedule('ScheduledApexTest',
            CRON_EXP, 
            new DiacoFtpJob());
        
        Test.stopTest();
    }

}