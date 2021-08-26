/**
* Diaco
* @author 			Esnayder Morales href=<esnaydermorales25@gmail.com>
* Project:			Script to syncronize address information between account and delivery object. 
* Description:		class responsible to syncronize address information.
*
* Changes (Version)
* -------------------------------------
*			No.		Date			Author						Description
*			-----	----------		--------------------		---------------
* @version	1.0		26/02/2021		Esnayder Morales (EM)		Initial implementation of the class.
**/

global class DeliverySyncAddress implements Database.Batchable<sObject>, Database.Stateful {
    
    global Integer recordsProcessed = 0;
    private Integer lim;
    public DeliverySyncAddress(Integer lim ) {
        this.lim = lim;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        return  Database.getQueryLocator([select Id, Person_Account__c, Person_Account__r.Street__c, Person_Account__r.City__c,
                                          Person_Account__r.State__c, Person_Account__r.Zip__c, 
                                          Person_Account__r.County__c, Person_Account__r.Geocode_Accuracy__c,
                                          Person_Account__r.BillingLatitude,Person_Account__r.BillingLongitude 
                                          from Delivery_Object__c 
                                          where Hung_Status__c = 'Sent to cheetah' and Street__c = null
                                          and County__c = null and State__c = null 
                                          and City__c = null and Zip__c = null 
                                          and Geocode_Accuracy__c = null limit :lim]);
    }
    global void execute(Database.BatchableContext bc, List<Delivery_Object__c> records){
        // process each batch of records
        for(Delivery_Object__c data: records){
            if(data.Person_Account__c != null){
                data.Street__c = data.Person_Account__r.Street__c;
                data.City__c = data.Person_Account__r.City__c;
                data.State__c = data.Person_Account__r.State__c;
                data.Zip__c = data.Person_Account__r.Zip__c;
                data.County__c = data.Person_Account__r.County__c;
                data.Geocode_Accuracy__c = data.Person_Account__r.Geocode_Accuracy__c;
                data.Maps_Latitude__c =  data.Person_Account__r.BillingLatitude;
                data.Maps_Longitude__c = data.Person_Account__r.BillingLongitude;
                recordsProcessed = recordsProcessed+1;
            }
        }
        update records;
    }    
    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
                            JobItemsProcessed,
                            TotalJobItems, CreatedBy.Email
                            FROM AsyncApexJob
                            WHERE Id = :bc.getJobId()];
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] { 'esnaydermorales25@gmail.com' };
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