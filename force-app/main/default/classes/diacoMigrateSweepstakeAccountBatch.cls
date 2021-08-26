/**
* Diaco
* @author 			Esnayder Morales href=<esnaydermorales25@gmail.com>
* Project:			Script to migrate a sweepstake info to account object. 
* Description:		class responsible to migrate a sweepstake info to account object.
*
* Changes (Version)
* -------------------------------------
*			No.		Date			Author						Description
*			-----	----------		--------------------		---------------
* @version	1.0		18/07/2019		Esnayder Morales (EM)		Initial implementation of the class.
**/
global class diacoMigrateSweepstakeAccountBatch implements Database.Batchable<sObject>, Database.Stateful {
    global Integer recordsProcessed = 0;
    private Integer lim;
    
    public diacoMigrateSweepstakeAccountBatch(Integer lim ) {
        this.lim = lim;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        return  Database.getQueryLocator([Select Id, Name, I_Accept_Terms__c, Sweepstake_Date__c, 
                                          Sweepstake_In_Date__c, Services_Pick__c, Account__c 
                                          From webForm__c 
                                          where Account__c != null and Type__c='Sweepstake' limit :lim]);
    }
    
    global void execute(Database.BatchableContext bc, List<webForm__c> records){
        System.debug(records);
        // process each batch of records
        List<Account> accounts = new List<Account>();
        for(webForm__c wf : records){
                Account account = new Account();
                account.Id = wf.Account__c;
                account.Sweepstake_Date__c = wf.Sweepstake_Date__c;
                account.Sweepstake_In_Date__c = wf.Sweepstake_In_Date__c;
                account.Interests__c = wf.Services_Pick__c;
            	account.I_Accept_Terms__c = wf.I_Accept_Terms__c;
                if(!wf.I_Accept_Terms__c 
                   && (wf.Sweepstake_Date__c.indexOf('S-1') != -1
                      || wf.Sweepstake_Date__c.indexOf('S-2') != -1
                      || wf.Sweepstake_Date__c.indexOf('S-3') != -1)){
                       account.I_Accept_Terms__c = true;
                   }
                accounts.add(account);          
        }
        update accounts;
    }   
    
    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
                            JobItemsProcessed,
                            TotalJobItems, CreatedBy.Email
                            FROM AsyncApexJob
                            WHERE Id = :bc.getJobId()];
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] { 'esnaydermorales25@gmail.com', 'giovanniyunior@gmail.com', 
            'emorales@diaco.us'};
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