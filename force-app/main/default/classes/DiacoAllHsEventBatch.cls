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

global class DiacoAllHsEventBatch implements Database.Batchable<sObject>, Database.Stateful {
    global Integer recordsProcessed = 0;
    private Integer lim;
    public DiacoAllHsEventBatch(Integer lim ) {
        this.lim = lim;
    }
    global Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        return  Database.getQueryLocator([select Id,Event_Count__c from Home_Services__c limit :lim]);
    }
    global void execute(Database.BatchableContext bc, List<Home_Services__c> records){
        // process each batch of records
        List<Home_Services__c> hs = new List<Home_Services__c>();
        
        List<string> ids = new List<string>();
        for(Home_Services__c hsElement : records){
            ids.add(hsElement.Id);
        }
        
        List<Event> eventList =[Select Id,WhatId, Home_Service__c, Current_Appointment__c from Event Where WhatId in :ids and RecordType.Name ='Sales'];
        
        Integer CountSales = 0; 
        
        for(Home_Services__c hsElement : records){
            CountSales = 0; 
            for(Event event : eventList){
                if(event.WhatId == hsElement.Id){
                    CountSales = CountSales + 1;      
                }
            }
            if(CountSales>0){
                hsElement.Event_Count__c = CountSales;
                hs.add(hsElement);
            }
        }
        upsert hs;
    }    
    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
                            JobItemsProcessed,
                            TotalJobItems, CreatedBy.Email
                            FROM AsyncApexJob
                            WHERE Id = :bc.getJobId()];
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] { 'kevin.vega.h@hotmail.com' };
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