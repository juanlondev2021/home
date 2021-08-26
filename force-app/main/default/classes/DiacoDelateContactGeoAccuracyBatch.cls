/**  testclass : diacoAssignContactBatchTest */

global class DiacoDelateContactGeoAccuracyBatch  implements Database.Batchable<sObject>, Database.Stateful{
    
    global Integer recordsProcessed = 0;
    private Integer lim;
    
    public DiacoDelateContactGeoAccuracyBatch(Integer lim ) {
        this.lim = lim;
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {

        return  Database.getQueryLocator([SELECT Id, Geo_Accuracy__c
                                        FROM Contact WHERE Geo_Accuracy__c = true ORDER BY CreatedDate limit :lim]);
    }
    
    global void execute(Database.BatchableContext bc, List<contact> records){
        delete records;
    }    

    global void finish(Database.BatchableContext bc) {
        // execute any post-processing operations
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
                            JobItemsProcessed,
                            TotalJobItems, CreatedBy.Email
                            FROM AsyncApexJob
                            WHERE Id = :bc.getJobId()];
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] { 'jullsforce@gmail.com'};
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