/*

Diaco
@author 			Esnayder Morales Corpas href=<esnaydermorales25@gmail.com>
Project:			diacoSendGridSincronize
Description:		class reponsible to sincronize account salesforce with contact sendgrid

Changes (Version)
_________________________________________

No.		Date			Author					Description
____	__________      __________________      _____________________________________
@version	1.0		05/10/2019		Esnayder Morales (ES)	Initial implementation  of the class.
*/
public class DiacoSendgridSincronize {
    /**
* 
* This method is responsible to get id accounts and call queue class.
* 
* This method is used in:
*  the  Account Send Grid process builder
*  
* 
* @param List<String> param (id's accounts)
* @return nothing
**/
    @InvocableMethod(label='Sincronize account' description='Sincronize change in account with sendgrid.')
    public static void sincronizeAcount(List<Account> accounts) {
        /*List<Account>accounts =[select Id, Zip__c, State__c, Street__c, PersonEmail, Solar_Status__c, Water_Status__c, Remodel_Status__c,
                                Pest_Control_Status__c, Home_Automation_Status__c, Utility__c, Utility__r.Name, City__c,Sweepstake_Status__c 
                                from Account where Id in :param];*/
        List<String> param = new List<String>();
        for(Account acc : accounts){
            param.add(acc.Id);
        }
        DiacoSendgridSincronizeQueue updateJob = new DiacoSendgridSincronizeQueue(accounts, param);
        // enqueue the job for processing
        System.debug('###accounts######>');
        System.debug(accounts);
        ID jobID = System.enqueueJob(updateJob);
        System.debug('###JOb Id###');
        System.debug(jobID);
    }
    
    /**
* 
* This method is responsible to make http request async.
* 
* This method is used in:
*  DiacoSendgridSincronize (sincronizeAcount method)
*  
* 
* @param String body (body to request)
* @return nothing
**/
    @future(callout=true)
    public static void sincronize(String body, List<String> acc){
        HttpResponse response = DiacoSendgridSincronize.sincronizeAccountSendgrid(body);
        // Parse the JSON response
        List<Account> accounts2 = new List<Account>();
        if (response.getStatusCode() != 200) {
            for(String acc1 : acc){
                accounts2.add(new Account(
                    Sendgrid_Status__c = 'No Synchronized ',
                    Id = acc1
                ));
            }
        }else{
            for(String acc1 : acc){
                accounts2.add(new Account(
                    Sendgrid_Status__c = 'synchronized',
                    Id = acc1
                ));
            }  
        }
        update accounts2;
    }
    
    /**
* 
* This method is responsible to make http request async.
* 
* This method is used in:
*  DiacoSendgridSincronize (sincronizeAcount method)
*  
* 
* @param String body (body to request)
* @return nothing
**/
    @future(callout=true)
    public static void sincronizeAccounts(String body){
        try{
            List<Object> result =DiacoSendgridSincronize.resultSendgrid(DiacoSendgridSincronize.sincronizeAccountSendgridBatch(body));
            //List<Account> accounts = new List<Account>();
            Map<String, String> emailAccount = new Map<String, String>();
            List<String> email = new List<String>();
            for(Object contact: result){
                Map<String, Object> MapResult = (Map<String, Object>) contact;
                System.debug('###ID SendGrid###');
                system.debug(MapResult.get('id'));
                
                Map<String,Object> customField = (Map<String, Object>) MapResult.get('custom_fields');
                system.debug('Account:  '+customField.get('Id_Account'));
                if(customField.get('Id_Account') != null &&
                   customField.get('Id_Account') != ''){
                       emailAccount.put(String.valueOf(MapResult.get('email')), String.valueOf(MapResult.get('id')));
                       email.add(String.valueOf(MapResult.get('email')));
                       /*accounts.add( new Account(
Id = String.valueOf(customField.get('Id_Account')),
Id_SendGrid__c = String.valueOf(MapResult.get('id')),
Sendgrid_Status__c = 'synchronized'
)); */  
                   }
            }
            List<Account> accs = [select Id, PersonEmail from Account Where PersonEmail IN :email];
            List<Account> accs2 = new List<Account>();
            for(Account ac: accs){
                accs2.add(new Account(
                    Id = ac.Id,
                    Id_SendGrid__c = String.valueOf(emailAccount.get(ac.PersonEmail)),
                    Sendgrid_Status__c = 'synchronized'
                ));
            }
            System.debug('###emailAccount###');
            System.debug(emailAccount);
            System.debug(accs2);
            update accs2;
        }catch(Exception e){
            System.debug('Exception '+ e.getMessage());
        }
        
        
    }
    
    /**
* 
* This method is responsible to create body to request.
* 
* This method is used in:
*  DiacoSendgridSincronizeQueue
*  
* 
* @param List<Account> accounts
* @return String (body)
**/
    public static String accounts(List<Account> accounts){
        String acco = '';
        String solar, water, remodel, pest, ha, utility, body, ac, zip, state, street, city, sweepstake;
        acco='{'+
            '"contacts": [';
        for(Account account: accounts){
            ac = '"e1_T":"'+account.Id+'",';
            zip = account.Zip__c != null? '"e6_T":"'+account.Zip__c+'",' : '';
            city = account.city__c != null? '"e6_T":"'+account.city__c+'",' : '';
            state = account.State__c != null? '"e5_T":"'+account.State__c+'",' : '';
            street = account.Street__c != null? '"e4_T":"'+account.Street__c+'",' : '';
            solar = account.Solar_Status__c != null? '"e7_T":"'+account.Solar_Status__c+'",' : '';
            water = account.Water_Status__c != null? '"e8_T":"'+account.Water_Status__c+'",' : '';
            remodel = account.Remodel_Status__c != null? '"e9_T":"'+account.Remodel_Status__c+'",' : '';
            pest = account.Pest_Control_Status__c != null? '"e10_T":"'+account.Pest_Control_Status__c+'",' : '';
            ha = account.Home_Automation_Status__c != null? '"e11_T":"'+account.Home_Automation_Status__c+'",' : '';
            utility = account.Utility__c != null? '"e3_T":"'+account.Utility__r.Name+'",' : '';
            sweepstake = account.Sweepstake_Status__c != null? '"e12_T":"'+account.Sweepstake_Status__c+'",' : '';
            body =ac+zip+state+street+solar+water+remodel+pest+ha+utility+sweepstake;
            body = body.removeEnd(',');
            acco += '{'+
                
                '"email": "'+account.PersonEmail+'",'+
                '"custom_fields":{'+
                body+
                '}},';
        }
        String accounts2 = acco.removeEnd(',');
        accounts2 +=']}';
        System.debug(accounts2);
        return accounts2;
    }
    
    /**
* 
* This method is responsible to get apikey sendgrid.
* 
* This method is used in:
*  DiacoSendgridSincronize (sincronizeAccountSendgrid method)
*  
* 
* @param nothing
* @return String (apikey)
**/
    public static String apikeySendgrid(){
        Send_Grid__c config = [select Api_Key__c 
                               from Send_Grid__c];
        return config.Api_Key__c;
    }
    
    
    /**
* 
* This method is responsible to make http request.
* 
* This method is used in:
*  DiacoSendgridSincronize (sincronize method)
*  
* 
* @param String acounts (body)
* @return HttpResponse
**/
    public static HttpResponse sincronizeAccountSendgrid(String accounts){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://api.sendgrid.com/v3/marketing/contacts');
        request.setMethod('PUT');
        request.setHeader('authorization', apikeySendgrid());
        request.setBody(accounts);
        System.debug(request.getBody());
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
    
    /**
* 
* This method is responsible to create body to request.
* 
* This method is used in:
*  DiacoSendgridSincronizeQueue
*  
* 
* @param List<Account> accounts
* @return String (body)
**/
    public static String accountsBody(List<Account> accounts){
        String body = '';
        for(Account acc: accounts){
            body += '\''+acc.PersonEmail+'\',';
        }
        String bodyAcc = '{"query": "email IN ('+body.removeEnd(',')+')"}';
        return bodyAcc;
    }
    
    /**
* 
* This method is responsible to make http request.
* 
* This method is used in:
*  DiacoSendgridSincronize (sincronize method)
*  
* 
* @param String acounts (body)
* @return HttpResponse
**/
    public static HttpResponse sincronizeAccountSendgridBatch(String accounts){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://api.sendgrid.com/v3/marketing/contacts/search');
        request.setMethod('POST');
        request.setHeader('authorization', apikeySendgrid());
        //request.setTimeout(3000);
        request.setBody(accounts);
        
        System.debug(request.getBody());
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
    
    public static List<Object> resultSendgrid(HttpResponse responseBody){
        //ResultSendgrid result = new ResultSendgrid();
        system.debug(responseBody.getBody());
        string json = responseBody.getBody();
        Map<String, Object> MapJson = (Map<String, Object>) System.JSON.deserializeUntyped(json);
        system.debug(MapJson);
        
        List<Object> result = (List<Object>) MapJson.get('result');        
        return result;
    }
}