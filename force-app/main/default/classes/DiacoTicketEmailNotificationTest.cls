@isTest
public class DiacoTicketEmailNotificationTest {
    @isTest static void testAll(){
        
        List<String> params = new List<String>();
        params.add('aovargas05@gmail.com, Álvaro, TP00025, Ticket Problem, In Progress');
        
        test.startTest();
        
        DiacoTicketEmailNotification.sendEmailToAssingTo(params);
        
        test.stopTest();
        
    }

}