/**
* Diaco
* @author 			Esnayder Morales href=<esnaydermorales25@gmail.com>
* Project:			Script to update date time field to hs when they are diferent to current event. 
* Description:		class responsible  to update date time field to hs when they are diferent to current event. 
*Test:              DiacoEventUpdateBAtchTest
*
* Changes (Version)
* -------------------------------------
*			No.		Date			Author						Description
*			-----	----------		--------------------		---------------
* @version	1.0		06/10/2020		Esnayder Morales (EM)		Initial implementation of the class.
**/

global class DiacoEventUpdateBAtch implements Database.Batchable<sObject>, Database.Stateful {
    global Integer recordsProcessed = 0;
    private Integer lim;
    
    public DiacoEventUpdateBAtch(Integer lim ) {
        this.lim = lim;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        return  Database.getQueryLocator([select Id, Home_Service__c, Home_Service__r.Appointment_Date_Time__c, 
        Home_Service__r.Appt_End_Time__c, StartDateTime, EndDateTime 
        from Event where Home_Service__c!=null and RecordType.Name = 'Sales' and Current_Appointment__c = true limit :lim]);
    }
    
    global void execute(Database.BatchableContext bc, List<Event> records){
        List<Home_Services__c> hsUpdate = new List<Home_Services__c>();
        for (Event record : records) {
            if(record.Home_Service__c != null && 
            (record.Home_Service__r.Appointment_Date_Time__c != record.StartDateTime
            && record.Home_Service__r.Appt_End_Time__c != record.EndDateTime)){
                hsUpdate.add(new Home_Services__c(
                    Id = record.Home_Service__c,
                    Appointment_Date_Time__c = record.StartDateTime,
                    Appt_End_Time__c = record.EndDateTime
                ));
                recordsProcessed = recordsProcessed +1;
            }
        }
        if (!hsUpdate.isEmpty()) {
            update hsUpdate;
        }
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