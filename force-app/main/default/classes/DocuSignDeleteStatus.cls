public class DocuSignDeleteStatus implements Database.Batchable<sObject>{
    private Integer lim1;
    private Id envId;
    public DocuSignDeleteStatus(Integer lim1,Id envId){
        this.lim1 = lim1;
        this.envId = envId;
    }
    public Database.QueryLocator start(Database.BatchableContext BC){
        List<String> names = new List<String>{'getting Envelope status','getting Envelope status(HTTP)','getting signer status(HTTP)'};
        List<ddsign__Status__c> status = new List<ddsign__Status__c>();
        List<ddsign__Status__c> status1 = new List<ddsign__Status__c>();
        for (String name:names){
            status1 = [select Id from ddsign__Status__c where ddsign__Name__c=:name and 
                       (ddsign__Envelope_HTTP__c=:envId or ddsign__Envelope__c=:envId) 
                       order by createddate desc limit 1];
            if(!status1.isEmpty()){
                status1[0].Selected__c=true;
                status.add(status1[0]);
            }
        }
        update status;
        return Database.getQueryLocator([Select Id,ddsign__Name__c from ddsign__Status__c where 
                                         (ddsign__Name__c='getting Envelope status' or 
                                          ddsign__Name__c='getting Envelope status(HTTP)' or
                                          ddsign__Name__c='getting signer status(HTTP)') and
                                         (ddsign__Envelope_HTTP__c=:envId or ddsign__Envelope__c=:envId) and Selected__c=false 
                                         order by createddate desc limit :lim1]);
    }
    
    public void execute(Database.BatchableContext BC, List<ddsign__Status__c> scope){
        delete scope;
    }
    
    public void finish(Database.BatchableContext BC){       
        // execute any post-processing operations
        /*
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
                            JobItemsProcessed,
                            TotalJobItems, CreatedBy.Email
                            FROM AsyncApexJob
                            WHERE Id = :bc.getJobId()];
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] {'esnaydermorales25@gmail.com','jeison14.99@gmail.com'};
       	message.optOutPolicy = 'FILTER';
        message.subject = 'Docusign Delete Status: ';
        message.plainTextBody ='Id: '+job.Id+ '\n Status: '+job.Status+
            '\n Number of Error: '+ job.NumberOfErrors+
            '\n Job items Processed: '+ job.JobItemsProcessed+
            '\n Total Job items: '+ job.TotalJobItems;
        
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results =  new Messaging.SendEmailResult[]{};
                if(!Test.isRunningTest()){results = Messaging.sendEmail(messages);}
        
        
        if (!results.isEmpty() && results[0].success) {
            System.debug('The email was sent successfully.');
        } else if(!results.isEmpty()){
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        }*/
    }
}