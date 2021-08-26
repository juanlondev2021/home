global class diacoAssignContactBatch implements Database.Batchable<sObject>, Database.Stateful{
	global Integer recordsProcessed = 0;
    private Integer lim;
    public diacoAssignContactBatch(Integer lim ) {
        this.lim = lim;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        ID Rt = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
                .get('PersonAccount').getRecordTypeId();
        return Database.getQueryLocator([SELECT Id, FirstName, LastName, PersonEmail, Phone,
                                          Street__c, Zip__c, State__c, City__c from Account where CreatedDate = THIS_MONTH AND Geocode_Accuracy__c = NULL limit :lim]);
        /*return  Database.getQueryLocator([select Id, FirstName, LastName, PersonEmail, Phone,
                                          Street__c, Zip__c, State__c, City__c
                                          from Account where RecordTypeId = :Rt order by CreatedDate limit :lim]);*/
    }
    
    global void execute(Database.BatchableContext bc, List<Account> records){
        // process each batch of records
        List<Contact> contacts = new List<Contact>();
        List<Account> accounts = new List<Account>();
        for(Account acc : records){
            Contact contact = new Contact();
            contact.FirstName = acc.FirstName;
            contact.LastName = acc.LastName ==Null || acc.LastName ==''? 'Test': acc.LastName;
            contact.MailingCity = acc.City__c;
            contact.MailingState = acc.State__c;
            contact.MailingStreet = acc.Street__c;
            contact.Geo_Accuracy__c = true;
            //contact.MailingCountry = acc.City__c;
            contact.MailingPostalCode = acc.Zip__c;
            contact.Person_Account__c = acc.Id;
            contacts.add(contact);
            recordsProcessed = recordsProcessed +1;
        }
        upsert contacts;
        for(Contact contact : contacts){
            accounts.add(new Account(Id = contact.Person_Account__c));
        }
        //update accounts;
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