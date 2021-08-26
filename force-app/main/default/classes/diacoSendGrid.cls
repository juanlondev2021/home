/*

 Diaco
 @author 			Esnayder Morales Corpas href=<esnaydermorales25@gmail.com>
 Project:			diacoSendGrid
 Description:		class reponsible sync up Account to sendgrid
     
 Changes (Version)
 _________________________________________

   No.		Date			Author					Description
   ____	__________      __________________      _____________________________________
@version	1.0		04/05/2019		Esnayder Morales (ES)	Initial implementation  of the class.
*/
public class diacoSendGrid {
    
    public List<HttpResponse> dataSendGrid(Integer lim, Integer second, List<Account> acc){
        
        List<String> accounts = new List<String>();
        List<HttpResponse> resp = new List<HttpResponse>();
        Integer i = 0;
        String acco = '';
        System.debug(acc);
        for(Account account : acc){
            i = i+1;
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
            if( math.mod(i, lim) ==0){
                accounts.add(acco.removeEnd(','));
                acco = '';
                
                // System.debug('Email');
            }
        }
        if(acco != ''){
            accounts.add(acco.removeEnd(','));
        }
        
        diacoSendGrid send = new diacoSendGrid();
        for(String items : accounts){  
            diacoThread thread = new diacoThread();
            thread.thread(second);
            System.debug(items);
            resp.add(send.sendAccountSendgrid(items, 'Bearer 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'));
        }
        System.debug('Succefull');
        return resp;
    }
    
    public List<Account> getAccounts(Integer page, Integer pageSize){
        diacoSendGrid send = new diacoSendGrid();
        HttpResponse response = send.getAccountsSendGrid(page,pageSize,'Bearer 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');
        resSendgrid rest = send.responseSendgrid(response);
        System.debug('---test---');
        System.debug(rest);
        List<Account> accounts = new List<Account>();
        for(recipients re : rest.recipients){
            Account acc = new Account(Id_SendGrid__c = re.id);
            for(customFields custom : re.custom_fields){
                
                if(custom.id == 44204523 && custom.name == 'Id_Account' && custom.value != null && custom.value != ''){
                    acc.Id = custom.value;
                    acc.Sendgrid_Status__c = 'synchronized';
                }              
                
            }
            accounts.add(acc);
            //datos.put(re.data.id, re.verification.result);
        }
        return accounts;
    }
    
    public List<Account> getDateAccounts(Integer page, Integer pageSize, Integer created_at, Integer filterDate, Integer segment_id){
        diacoSendGrid send = new diacoSendGrid();
        HttpResponse response = send.getAccountsDateSendGrid(page,pageSize,'Bearer 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',created_at, filterDate,segment_id);
        resSendgrid rest = send.responseSendgrid(response);
        System.debug(rest);
        List<Account> accounts = new List<Account>();
        for(recipients re : rest.recipients){
            Account acc = new Account(Id_SendGrid__c = re.id);
            for(customFields custom : re.custom_fields){
                
                if(custom.id == 44204523 && custom.name == 'Id_Account' && custom.value != null && custom.value != ''){
                    acc.Id = custom.value;
                    acc.Sendgrid_Status__c = 'synchronized';
                }              
                
            }
            accounts.add(acc);
            //datos.put(re.data.id, re.verification.result);
        }
        return accounts;
    }
    
    public HttpResponse sendAccountSendgrid(String accounts, String apikey){
        String endpoint = 'https://api.sendgrid.com/v3/contactdb/recipients';
        String body = '['+accounts+']';
        System.debug(body);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('authorization', apikey);
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
    
    public HttpResponse getAccountsSendGrid(Integer page, Integer pageSize,String apikey){
        String endpoint = 'https://api.sendgrid.com/v3/contactdb/recipients?page='+page+'&page_size='+pageSize;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        request.setHeader('authorization', apikey);
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
    
    public HttpResponse getAccountsDateSendGrid(Integer page, Integer pageSize,String apikey, Integer dateCreateUpdate, Integer filterDate, Integer recipient_id){
        String endpoint ='';
        if(filterDate==0){
            endpoint = 'https://api.sendgrid.com/v3/contactdb/recipients/search?created_at='+dateCreateUpdate+'&page='+page+'&page_size='+pageSize;
        }else if (filterDate==1){
            endpoint = 'https://api.sendgrid.com/v3/contactdb/recipients/search?updated_at='+dateCreateUpdate+'&page='+page+'&page_size='+pageSize;
        }else{
            endpoint = 'https://api.sendgrid.com/v3/contactdb/segments/'+recipient_id+'/recipients?&page='+page+'&page_size='+pageSize;
        }
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        request.setHeader('authorization', apikey);
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
    
    public resSendgrid responseSendgrid(HttpResponse Appname){
        resSendgrid response = (resSendgrid)JSON.deserialize(Appname.getBody(), resSendgrid.class);
        return response;
    }
    }