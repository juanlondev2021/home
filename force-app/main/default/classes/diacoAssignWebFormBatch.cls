/**
* Diaco
* @author 			Esnayder Morales href=<esnaydermorales25@gmail.com>
* Project:			Script to create a webform for each account. 
* Description:		class responsible to assign webform to account.
*
* Changes (Version)
* -------------------------------------
*			No.		Date			Author						Description
*			-----	----------		--------------------		---------------
* @version	1.0		18/07/2019		Esnayder Morales (EM)		Initial implementation of the class.
**/

global class diacoAssignWebFormBatch implements Database.Batchable<sObject>, Database.Stateful {
    global Integer recordsProcessed = 0;
    private Integer lim;
    public diacoAssignWebFormBatch(Integer lim ) {
        this.lim = lim;
    }
    global Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        return  Database.getQueryLocator([select Id, FirstName, LastName, PersonEmail, Phone
                                          from Account where Web_Form__c =null limit :lim]);
    }
    global void execute(Database.BatchableContext bc, List<Account> records){
        // process each batch of records
        List<webForm__c> WFs = new List<webForm__c>();
        for(Account acc : records){
            webForm__c webForm = new webForm__c();
            webForm.FirstName__c=acc.FirstName;
            webForm.LastName__c= acc.LastName;
            webForm.Email__c=acc.PersonEmail;
            webForm.Phone__c= acc.Phone;
            webForm.Type__c = 'Home Services';
            webForm.RecordTypeId = '0121K000001h2IKQAY';
            webForm.Account__c = acc.Id;
            WFs.add(webForm);
            recordsProcessed = recordsProcessed +1;
        }
        upsert WFs;
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