/**
* Diaco
* @author 			Álvaro José Ortega Vargas href=<aovargassf@gmail.com>
* Project:			Send Email Notification to Account or User email address
* Description:		
*
* Changes (Version)
* ____________________________________
*			No.		Date			Author					Description
*			_____	__________		_____________________	___________________________________
* @version	1.0		05/02/2020		Álvaro Ortega (AO)		Creation
**/
public class DiacoTicketEmailNotification {
    @InvocableMethod
    public static void sendEmailToAssingTo(List<String> params){
        system.debug('___________________________________Open Ticket Email___________________________________');
        for(String param: params){
            system.debug(params);
            string[] split= param.split(',');
            
            string email = split[0];
            string firstName = split[1];
            string code = split[2];
            string ticketName = split[3];
            string state = split[4];
            
            sendEmail(email, firstName, code, ticketName, state.toUppercase());
        }
        system.debug('___________________________________Close Ticket Email___________________________________');
    }
    public static void sendEmail(String email, string accountFirstName, string code, string ticketName, string status){
        // System.debug('Staring email process');
        
        try {
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            
            List<string> emails = new List<string>();
            emails.add(email);
            
            message.setToAddresses(emails);
            
            message.optOutPolicy = 'FILTER';
            message.subject = 'Ticket Update '+code;
            message.setHtmlBody('<p>Hello '+accountFirstName+'<br/><br/>'+'The ticket '+ticketName+' with code '+code+' was update to '+status +'.</p>');
            
            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            
            if (results[0].success) {
                System.debug('The email was sent successfully.');
            }else {
                System.debug('The email failed to send: ' + results[0].errors[0].message);
                
            }
        }
        catch (Exception e) {
            // "Convert" the exception into an AuraHandledException
            System.debug('The email failed to send: ' + e);   
        }
            
        
    }
}