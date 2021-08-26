global class DeliveryObjectFieldPopulation implements Database.Batchable<sObject>{
    global string query;
    
    //query = 'SELECT id,branch_object__c,fbranch__c from Delivery_object__c where branch_object__c = null and fbranch__c != null';
    
    global Database.querylocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Delivery_Object__c> deliveryList){        
        Set<String> branchName = new Set<String>();
        Map<String,Id> branchNameWithId = new Map<String,Id>();
        
        for(Delivery_Object__c delivery : deliveryList){            
            if(delivery.fbranch__c != null){                
                branchName.add(delivery.fbranch__c);                
            }            
        }        
        for(Branch__c branch : [SELECT id,name from Branch__c where name in : branchName]){            
            branchNameWithId.put(branch.name,branch.id);            
        }       
        for(Delivery_Object__c delivery : deliveryList){              
            if(delivery.branch_object__c == null)                
                delivery.branch_object__c = branchNameWithId.get(delivery.fbranch__c);            
        }
        
        if(deliveryList.size() > 0){
            try{
                 update deliveryList ;
            }
            Catch(Exception e){
                System.debug('Exception Caught'+e.getMessage());
            }
        }
    }
    global void finish(Database.BatchableContext BC){
                /* AsyncApexJob asynchronousJob = [SELECT Id, Status,ExtendedStatus,NumberOfErrors, JobItemsProcessed,
        TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id =:BC.getJobId()];       
        if(asynchronousJob.NumberOfErrors > 0){
        // Send an email to the Apex job's submitter to notify the job completion.  
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        //String[] toAddresses = new String[] {asynchronousJob.CreatedBy.Email};
        String[] toAddresses = new String[] {'priyanka@mstsolutions.com'};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Confirmation Number and Respond DatePopulation: ' + asynchronousJob.Status);
        mail.setPlainTextBody('The current job is processed with ' + asynchronousJob.TotalJobItems +
        ' batches with '+ asynchronousJob.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }*/   
    }
}