/**
* Diaco
* @author 			Esnayder Morales href=<esnaydermorales25@gmail.com>
* Project:			Script to assign a route for each account. 
* Description:		class responsible to assign route to account.
*
* Changes (Version)
* -------------------------------------
*			No.		Date			Author						Description
*			-----	----------		--------------------		---------------
* @version	1.0		18/12/2019		Esnayder Morales (EM)		Initial implementation of the class.
**/
global class DiacoAssignZIP implements Database.Batchable<sObject>, Database.Stateful{
    global Integer recordsProcessed = 0;
    private Integer lim;
    private List<ZipCode__c> zipCode;
    private List<ZipCode__c> routeId = [select Route__c from ZipCode__c where Name = 'unknown']; 
    public DiacoAssignZIP(Integer lim,  List<ZipCode__c> zipCode) {
        this.lim = lim;
        this.zipCode = zipCode; 
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        return  Database.getQueryLocator([select Id, Zip__c, Name, Route__c 
                                          from Account limit :lim]);
    }
    global void execute(Database.BatchableContext bc, List<Account> records){
        // process each batch of records
        List<Account> accounts = new List<Account>();
        for(Account acc : records){
            for(ZipCode__c zip : zipCode){
                if(acc.Zip__c == zip.Name){
                	acc.Route__c = zip.Route__c;
                    break;
                }
            }
            if(acc.Route__c == null){
                acc.Route__c = routeId[0].Route__c;
            }
            accounts.add( new Account(
            	Id = acc.Id,
                Route__c = acc.Route__c
            ));
            recordsProcessed = recordsProcessed + 1;
        }
        for(Account ac : accounts){
            System.debug(ac.Id+ ' ------------  ' +ac.Route__c);
        }
        update accounts;
    }    
    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
        System.debug(recordsProcessed + ' records processed. Shazam!');
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
                            JobItemsProcessed,
                            TotalJobItems, CreatedBy.Email
                            FROM AsyncApexJob
                            WHERE Id = :bc.getJobId()];
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] { 'esnaydermorales25@gmail.com', 'giovanniyunior@gmail.com' };
        message.optOutPolicy = 'FILTER';
        message.subject = 'Records processed: '+ recordsProcessed;
        message.plainTextBody ='Id: '+job.Id+ '\n Status: '+job.Status+
            '\n Number of Error: '+ job.NumberOfErrors+
            '\n Job items Processed: '+ job.JobItemsProcessed+
            '\n Total Job items: '+ job.TotalJobItems;
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        
        if (results[0].success) {
            System.debug('The email was sent successfully.');
        } else {
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        }
        
    }   

}