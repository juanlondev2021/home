public class diacoSendSweepstake {
    
    @future(callout=true)
    public static void sendSweepstakeTrigger(String body){
        HttpResponse response = diacoSendSweepstake.sendSweepstakeOne(body);
        System.debug(response.getBody());
        System.debug('Class sweepstake');
    }
    
    
    
    @future(callout=true)
    public static void sendSmsSweepstakeTrigger(String body){
        HttpResponse response = diacoSendSweepstake.sendSmsSweepstake(body);
        System.debug(response.getBody());
        System.debug('Class sweepstake');
    }
    
    @InvocableMethod(label='Check send sweepstake' description='Send sweepstake when check sendsweepstake.')
    public static void SweepstakeSms(List<String> param) {
            List<Account> Acc = [Select Id, Validate_Email__c, PersonEmail, FirstName, Id_SendGrid__c,
                       LastName, Utility__r.Name, Street__c, State__c, Phone, Sms_sweepstake__c,
                       City__c, Zip__c, Solar_Status__c, Water_Status__c, Window_Status__c,
                       Pest_Control_Status__c, Home_Automation_Status__c
                       from Account where Id IN :param]; 
        for(Account account: Acc){
            String sms = diacoSmsHS.Sweepstake(account, 1);
            String body = diacoSendSweepstake.oneAccount(account, sms);
            diacoSendSweepstake.sendSweepstakeTrigger(body);
            System.debug('Process #2Condition builder Sms check : '+account.PersonEmail);
            System.debug('Process #2Condition builder Sms check: '+account.State__c);
            System.debug(body);
        }
        
        return;

        }
    
    //Method to convert List to account in String to use the body in sendSweepstake method
    public String accounts(List<Account> accounts){
        String acco = '';
        for(Account account: accounts){
            acco += '{'+
                '"email": "'+account.PersonEmail+'",'+
                '"first_name": "'+account.FirstName+'",'+
                '"last_name": "'+account.LastName+'",'+
                '"Id_Account": "'+account.Id+'",'+
                '"Utility":"'+account.Utility__r.Name+'",'+
                '"Street":"'+account.Street__c+'",'+
                '"State":"'+account.State__c+'",'+
                '"City":"'+account.City__c+'",'+
                '"Zip":"'+account.Zip__c+'",'+
                '"Solar_Status":"'+account.Solar_Status__c+'",'+
                '"Water_Status":"'+account.Water_Status__c+'",'+
                '"Window_Status":"'+account.Window_Status__c+'",'+
                '"Pest_Control_Status":"'+account.Pest_Control_Status__c+'",'+
                '"Home_Automation_Status":"'+account.Home_Automation_Status__c+'"'+
                '},';
        }
        String accounts2 = acco.removeEnd(',');
        return accounts2;
    }
    
    
    //Method to convert List to account in String to use the body in sendSweepstake method
    public List<smagicinteract__smsMagic__c> accountsSms(List<Account> accounts){
        List<Sms_Url__c> config = [select Activate_sms_function__c, Sms_Text__c, Sender_Id__c, Function__c 
                                   from Sms_Url__c where Function__c= 'Sweepstake' Limit 1];
        List<smagicinteract__smsMagic__c> listSms = new List<smagicinteract__smsMagic__c>();
        smagicinteract__smsMagic__c sms = new smagicinteract__smsMagic__c();
        if(config.size()>0 && config[0].Function__c=='Sweepstake'
           && config[0].Activate_sms_function__c == true
           && config[0].Sender_Id__c != null && config[0].Sender_Id__c != ''
           && config[0].Sms_Text__c != '' && config[0].Sms_Text__c != null){
               String text = 'Hello '+account.FirstName+', '+config[0].Sms_Text__c+
            ' https://myhsaz.com/s/?id='+account.Id;
        for(Account account: accounts){
            
            if(account.Phone != null && account.Phone != ''
              && account.Sms_sweepstake__c == null){
                sms.smagicinteract__PhoneNumber__c= account.Phone;
          		sms.OwnerId= '005410000063AjdAAE';
          		sms.smagicinteract__SMSText__c= text;
          		sms.smagicinteract__SenderId__c= config[0].Sender_Id__c;
          		sms.smagicinteract__Account__c= account.Id;
                listSms.add(sms);
            }
        }
        }
        System.debug(listSms);
        //tring accounts2 = acco.removeEnd(',');
        return listSms;
    }
    
    
    //Method to convert an account in String to use the body in sendSweepstakeOne method
    public static String oneAccount(Account account, String smsText){
        String acco = '';
        System.debug(account.Sms_sweepstake__c);
        acco = '{'+
                '"email": "'+account.PersonEmail+'",'+
                '"first_name": "'+account.FirstName+'",'+
                '"last_name": "'+account.LastName+'",'+
                '"Id_Account": "'+account.Id+'",'+
                '"Utility":"'+account.Utility__r.Name+'",'+
                '"Street":"'+account.Street__c+'",'+
                '"State":"'+account.State__c+'",'+
                '"City":"'+account.City__c+'",'+
                '"Zip":"'+account.Zip__c+'",'+
                '"Solar_Status":"'+account.Solar_Status__c+'",'+
                '"Water_Status":"'+account.Water_Status__c+'",'+
                '"Window_Status":"'+account.Window_Status__c+'",'+
                '"Pest_Control_Status":"'+account.Pest_Control_Status__c+'",'+
                '"Home_Automation_Status":"'+account.Home_Automation_Status__c+'",'+
            	'"Id_SendGrid__c": "'+account.Id_SendGrid__c+'",'+
            	'"valid": "'+ account.Validate_Email__c+'",'+
            	'"sms": "'+ account.Sms_sweepstake__c+'"'+
            	smsText+
                '}';
        
        System.debug(acco);
        return acco;
    }
    
    public void sendSweepstake(String acc){
        String endpoint = 'https://salesforcewebsiteapi.herokuapp.com/sendgrid/api/sweepstake';
        String body = '{"accounts":['+acc+']}';
        //String body = '{"accounts":[{"email": "rdemarbiex1@msn.com","first_name": "Daniel","last_name": "Demarbiex","Id_Account": "0014100001yH9ugAAC"}]}';
        System.debug(body);
        System.debug(body);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('origin', 'https://myhomeservices--preprod.cs42.my.salesforce.com');
        request.setBody(body);
        
        HttpResponse response = http.send(request);
        // Parse the JSON response
        if (response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                         response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug('response.body : '+response.getBody());
            
        }      
        System.debug('Here');
        System.debug('Good');
    }
    
    public static HttpResponse sendSweepstakeOne(String acc){
        String endpoint = 'https://salesforcewebsiteapi.herokuapp.com/sendgrid/api/sweepstake-one';
        String body = acc;
        //String body = '{"accounts":[{"email": "rdemarbiex1@msn.com","first_name": "Daniel","last_name": "Demarbiex","Id_Account": "0014100001yH9ugAAC"}]}';
        System.debug(body);
        System.debug(body);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('origin', 'https://myhomeservices--preprod.cs42.my.salesforce.com');
        request.setBody(body);
        
        HttpResponse response = http.send(request);
        // Parse the JSON response
        if (response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                         response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug('response.body : '+response.getBody());
            
        }      

        return response;
    }
    
    //Send sms
    public static HttpResponse sendSmsSweepstake(String acc){
        String endpoint = 'https://salesforcewebsiteapi.herokuapp.com/sendgrid/api/sweepstake-sms';
        String body = acc;
        //String body = '{"accounts":[{"email": "rdemarbiex1@msn.com","first_name": "Daniel","last_name": "Demarbiex","Id_Account": "0014100001yH9ugAAC"}]}';
        System.debug(body);
        System.debug(body);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('origin', 'https://myhomeservices--preprod.cs42.my.salesforce.com');
        request.setBody(body);
        
        HttpResponse response = http.send(request);
        // Parse the JSON response
        if (response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                         response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug('response.body : '+response.getBody());
            
        }      

        return response;
    }
    
    
}