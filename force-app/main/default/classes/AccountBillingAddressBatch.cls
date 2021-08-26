/**
* Diaco
* @author 			Giovanni Ulloque href=<Gulloque@diaco.us>
* Project:			Script to update Billing Address from Address. 
* Description:		class responsible to update Billing Address.
* Test:             AccountBillingAddressBatchTest
*
* Changes (Version)
* -------------------------------------
*			No.		Date			Author						Description
*			-----	----------		--------------------		---------------
* @version	1.0		31/10/2020	    Giovanni Ulloque (GU)		Initial implementation of the class.
**/

global class AccountBillingAddressBatch implements Database.Batchable<sObject>, Database.Stateful {
    global Integer recordsProcessed = 0;
    private Integer lim;
    public AccountBillingAddressBatch(Integer lim ) {
        this.lim = lim;
    }
    global Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        DateTime cDate = system.now().addMonths(-2);
        system.debug('Created Date' + cDate);
        return  Database.getQueryLocator([SELECT Id, billingStreet, Street__c, City__c, State__c, Zip__c FROM Account WHERE billingStreet = null ORDER BY CreatedDate DESC LIMIT : lim]);
    }
    global void execute(Database.BatchableContext bc, List<Account> records){
        // process each batch of records
        List<Account> acc = new List<Account>();
        for(Integer i = 0; i < records.size(); i++){
            if(!records.isEmpty()){
                System.debug('AccountId = ' + records[i].id);
                acc.add(new Account(
                Id                = records[i].id,
                BillingStreet     = records[i].Street__c,
                BillingCity       = records[i].City__c,
                BillingState      = records[i].State__c,
                BillingPostalCode = records[i].Zip__c
                ));
                recordsProcessed++;
            }
        }
        update acc;
    }    
    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
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