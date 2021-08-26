/*
 * Diaco
 * @author             Esnayder Morales Corpas
 * Project:            Email validation and sincronize with sendgrid
 * TestClass:          diacoValidateEmailTest
 * Description:        Invocable method
 *
 * Changes (Version)
 * _________________________________________
 *            No.        Date            Author                    Description
 *            ____    __________        __________________      _____________________________________
 * @version    1.0    11/09/2020         Esnayder Morales         Initial implementation of the class.
 * @version    1.0    11/09/2020         Esnayder Morales         Remove extra SOQL.
 **/
public class diacoValidateEmail {
    
    @future(callout=true)
    public static void verificateEmail(String accounts){
        neverBounce__c config = [select Job_id__c, number_of_pages__c,next_page__c, ApiKey__c, First_Job__c, Second_Job__c, Emails_per_page__c 
                                 from neverBounce__c];
                                 system.debug(accounts);
        List<Account> accountsToValidate = (List<Account>)JSON.deserialize(accounts, List<Account>.class);
        List<Account> accUpdate = new List<Account>();
        Integer length = accountsToValidate.size();
            for(Integer i =0 ; i <length; i++){
                HttpResponse response =  diacoValidateEmail.validateOneEmail(config.ApiKey__c, accountsToValidate[i].PersonEmail);
                verification  vrfc = (verification)JSON.deserialize(response.getBody(), verification.class);
                accountsToValidate[i].Validate_Email__c = vrfc.result;
                accountsToValidate[i].Validate_email_status__c = 'Successful';
                if(accountsToValidate[i].Validate_Email__c == 'Valid'){
                    String body = oneAccount(accountsToValidate[i]);
                    HttpResponse responseEnd = diacoValidateEmail.sincronizeOne(body);
                }
                accUpdate.add(accountsToValidate[i]);
            }
            upsert accUpdate;
        /*HttpResponse response =  diacoValidateEmail.validateOneEmail(config.ApiKey__c, emailToValidate);
        verification  vrfc = (verification)JSON.deserialize(response.getBody(), verification.class);
        Acc.Validate_Email__c = vrfc.result;
        Acc.Validate_email_status__c = 'Successful';
        HttpResponse responseEnd = diacoValidateEmail.sincronizeOne(body);
        upsert Acc;*/
        /*Account Acc = [Select Id, Validate_Email__c, PersonEmail, FirstName, Id_SendGrid__c,
                       LastName, Utility__r.Name, Street__c, State__c, Phone, Sms_sweepstake__c,
                       City__c, Zip__c, Solar_Status__c, Water_Status__c, Window_Status__c,
                       Pest_Control_Status__c, Home_Automation_Status__c
                       from Account where Id = :AccId];
        System.debug('ValidateEmail');
        System.debug(Acc.Validate_Email__c);
        if(Acc.Validate_Email__c==null || Acc.Validate_Email__c ==''){
            HttpResponse response =  diacoValidateEmail.validateOneEmail(config.ApiKey__c, emailToValidate);
            verification  vrfc = (verification)JSON.deserialize(response.getBody(), verification.class);
            Acc.Validate_Email__c = vrfc.result;
            //Acc.Validate_Email__c = 'Valid';
            Acc.Validate_email_status__c = 'Successful';
            //String sms = diacoSmsHS.Sweepstake(Acc, 1);
            String body = diacoValidateEmail.oneAccount(Acc);
            HttpResponse responseEnd = diacoValidateEmail.sincronizeOne(body);
        	//System.debug(responseEnd.getBody());
        	upsert Acc;
        }*/
        
    
    }
    
    
    @InvocableMethod(label='Send sweepstake' description='Sends sweepstake and update contact sendgrid.')
    public static void Sweepstake(List<Account> param) {
        try {
            DiacoValidateEmailQueue updateJob = new DiacoValidateEmailQueue(param);
            ID jobID = System.enqueueJob(updateJob);
        /*for(Account account: param){
            //DiacoValidateEmailQueue updateJob = new DiacoValidateEmailQueue(account.PersonEmail, account.Id);
            // enqueue the job for processing
            
            //ID jobID = System.enqueueJob(updateJob);
            System.debug('###JOb Id###');
            //System.debug(jobID);
            System.debug('Process builder #1Condition PersonEmail: '+account.PersonEmail);
            System.debug('Process builder #1Condition PersonEmail: '+account.State__c);
            //upsert account;
        }*/
        
        
        } catch (Exception e) {
            System.debug(e);
        }
        return;
    }
    
    public HttpResponse validateEmail(String ApiKey, String emailToValidate){
        String endpoint = 'https://api.neverbounce.com/v4/jobs/create';
        String body = '{'+
            '"key": "'+ApiKey+'",'+
            '"input_location": "supplied",'+
            '"filename": "emailAccount.csv",'+
            '"auto_start": true,'+
            '"auto_parse": true,'+
            '"input": ['+emailToValidate+']'+
            '}';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setBody(body);
        HttpResponse response = http.send(request);
        // Parse the JSON response
        if (response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                         response.getStatusCode() + ' ' + response.getStatus());
            
        } else {
            //System.debug('response.body : '+response.getBody());
            //updateAccount(id, response.getBody());
        } 
        
        return response;
    } 
    
    public responseNeverBounce responseNB(HttpResponse Appname){
        responseNeverBounce response = (responseNeverBounce)JSON.deserialize(Appname.getBody(), responseNeverBounce.class);
        return response;
    }
    
    public reponseNBResult reponseNBRes(HttpResponse Appname){
        reponseNBResult response = (reponseNBResult)JSON.deserialize(Appname.getBody(), reponseNBResult.class);
        return response;
    }
    public diacoNeverBounceStatus reponseNBReStatus(HttpResponse Appname){
        diacoNeverBounceStatus response = (diacoNeverBounceStatus)JSON.deserialize(Appname.getBody(), diacoNeverBounceStatus.class);
        return response;
    }
    
    public HttpResponse getInfoAboutJobStatus(String ApiKey, String job_id){
        String endpoint = 'https://api.neverbounce.com/v4/jobs/status?key='+ApiKey+'&job_id='+job_id;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        // Parse the JSON response
        if (response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                         response.getStatusCode() + ' ' + response.getStatus());
            
        } else {
            System.debug('response.body : '+response.getBody());
            //updateAccount(id, response.getBody());
        } 
        
        return response;
    } 
    public HttpResponse getInfoAboutJob(String ApiKey, String job_id){
        String endpoint = 'https://api.neverbounce.com/v4/jobs/results?key='+ApiKey+'&job_id='+job_id;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        // Parse the JSON response
        if (response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                         response.getStatusCode() + ' ' + response.getStatus());
            
        } else {
            System.debug('response.body : '+response.getBody());
            //updateAccount(id, response.getBody());
        } 
        
        return response;
    } 
    
    public static HttpResponse validateOneEmail(String ApiKey, String emailToValidate){
        String endpoint = 'https://api.neverbounce.com/v4/single/check?key='+ApiKey+'&email='+emailToValidate;
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setTimeout(40000);
        //request.setBody(body);
        HttpResponse response = http.send(request);
        // Parse the JSON response
        // Parse the JSON response
        if (response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                         response.getStatusCode() + ' ' + response.getStatus());
            
        } else {
            system.debug('+++++++++++++++++++++++++++++++++++++++++++++');
            System.debug('response.body : '+response.getBody());
            system.debug('+++++++++++++++++++++++++++++++++++++++++++++');
            //updateAccount(id, response.getBody());
        } 
        return response;
    }

    //Method to convert an account in String to use the body in sendSweepstakeOne method
    public static String oneAccount(Account account){

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
            	'"valid": "'+ account.Validate_Email__c+'"'+
                '}';
        
        System.debug(acco);
        return acco;
    }

    //Sincronize contact
    public static HttpResponse sincronizeOne(String acc){
        String endpoint = 'https://salesforcewebsiteapi.herokuapp.com/api/v1.0/send-grid';
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