/******************
* 
* Class to responsible 
* to send SMS
* 
*******************/

public class diacoSmsHS {
    
    @InvocableMethod(label='Check send sms sweepstake' description='Send sms sweepstake when check sms sendsweepstake.')
    public static void Sweepstake(List<String> param) {
            List<Account> Acc = [Select Id, Validate_Email__c, PersonEmail, FirstName, Id_SendGrid__c,
                       LastName, Utility__r.Name, Street__c, State__c, Phone, Sms_sweepstake__c,
                       City__c, Zip__c, Solar_Status__c, Water_Status__c, Window_Status__c,
                       Pest_Control_Status__c, Home_Automation_Status__c
                       from Account where Id IN :param]; 
        for(Account account: Acc){
            String sms = diacoSmsHS.Sweepstake(account,0);
            diacoSendSweepstake.sendSmsSweepstakeTrigger(sms);
            System.debug('Process builder #3Condition PersonEmail check : '+account.PersonEmail);
            System.debug('Process builder #3Condition PersonEmail check: '+account.State__c);
        }
        
        return;

        }
    
    //Method to responsible to send sweepstake
    public static String Sweepstake(Account account, Integer option){
        List<Sms_Url__c> config = [select Activate_sms_function__c, Sms_Text__c, Sender_Id__c, Function__c 
                                   from Sms_Url__c where Function__c= 'Sweepstake' Limit 1];
        String body = ', "status_sms": "true" ';
        
        if(config.size()>0 && config[0].Function__c=='Sweepstake'
           && config[0].Activate_sms_function__c == true && account.Phone != null
           && config[0].Sender_Id__c != null && config[0].Sender_Id__c != ''
           && config[0].Sms_Text__c != '' && config[0].Sms_Text__c != null){
               //&& account.Sms_sweepstake__c == null
               String text = 'Hello '+account.FirstName+', '+config[0].Sms_Text__c+
            ' https://myhsaz.com/s/?id='+account.Id;
               System.debug('Sent sms True');
               body = ', "sender_id": "'+ config[0].Sender_Id__c+'",'+
                   '"Phone": "'+account.Phone+'", '+
                   '"sms_text": "'+ text+'" ';
               //insert sms;
               if(option == 0){
                   body = '{ "sender_id": "'+ config[0].Sender_Id__c+'",'+
                   			'"Phone": "'+account.Phone+'", '+
                       		'"Id_Account": "'+account.Id+'", '+
                       		'"sms_text": "'+ text+'" }';
               }
               
           }else{
               System.debug('No Sent sms True');
               body = ', "status_sms": "true" ';
           }
        return body;
        
    }
}