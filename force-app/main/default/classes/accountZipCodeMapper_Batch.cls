/********************************************************************************************
* Class Name : accountZipCodeMapper_Batch
* Created By : GIT CRM
* Modified By : Priyanka Shanmugam
* Created Date : 29/03/2016
* Author : MST
* Description: Get all the address of invalid zipcodes and populate values in Branch,MSA 
and Region Code fields of address based on the newly added zipcodes in th ezipcode custom object.
**********************************************************************************************/
global class accountZipCodeMapper_Batch implements Database.Batchable<Sobject>{
    global Database.queryLocator start(Database.BatchableContext bc){
        String query = 'SELECT id,Zip_Code__c,Branch__c,MSA__c,Region_Code__c FROM Address__c WHERE Zip_Code__c !=\'\'';
        query+=' AND (Branch__c = null'+' OR MSA__c ='+'\''+'Invalid Zip Code' + '\'' + ' OR Region_Code__c ='+'\''+'Invalid Zip Code' + '\'' +')';
        return Database.getQueryLocator(query); 
    }
    global void execute(Database.BatchableContext bc, List<Address__c> incomingAddress) {
        
        Set<String> zipCodeSet = new Set<String>();
        Map<String,ZipCode__c> zipCodeMap = new Map<String,ZipCode__c>();
        List<Address__c> addressList = new List<Address__c>();
        // Get thezipcodes from the address
        for(Address__c currAddress : incomingAddress){
            zipCodeSet.add(currAddress.Zip_Code__c);                   
        }     
        // Get the zipcode records based on the zipcodes obtained from address
        for(ZipCode__c currZipCode : [SELECT Name,Branch__c,MSA__c,Region_Code__c,State__c FROM ZipCode__c WHERE Name IN :zipCodeSet]){
            zipCodeMap.put(currZipCode.Name,currZipCode);   
        }
        // If the zip code is found on the zipcode object then assign the related branch,MSAand Region code
        for(Address__c currAddress : incomingAddress){              
            if(zipCodeMap.containsKey(currAddress.Zip_Code__c)){                      
                ZipCode__c zipCode = zipCodeMap.get(currAddress.Zip_Code__c);                
                currAddress.Branch__c = zipCode.Branch__c;
                currAddress.MSA__c = zipCode.MSA__c;
                currAddress.Region_Code__c = zipCode.Region_Code__c; 
                addressList.add(currAddress);
            }
        }
        // update the address 
        if(!addressList.isEmpty()){
            try{
                update addressList;
            }
            catch(exception e){
                System.debug('----Error occured while updating the address---'+e.getMessage());
            }
        }
    }
    
    global void finish(Database.BatchableContext bc){
         // Get the ID of the AsyncApexJob representing this batch job  
        // from Database.BatchableContext.Query the AsyncApexJob object to retrieve the current job's information.  
        
        AsyncApexJob asynchronousJob = [SELECT Id, Status,ExtendedStatus,NumberOfErrors, JobItemsProcessed,
                                        TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id =:BC.getJobId()];       
        if(asynchronousJob.NumberOfErrors > 0){
            // Send an email to the Apex job's submitter to notify the job completion.  
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {asynchronousJob.CreatedBy.Email};
            //String[] toAddresses = new String[] {'priyanka@mstsolutions.com'};
            mail.setToAddresses(toAddresses);
            mail.setSubject('ZipCode Based Field Population: ' + asynchronousJob.Status);
            mail.setPlainTextBody('The current job is processed with ' + asynchronousJob.TotalJobItems +
                                  ' batches with '+ asynchronousJob.NumberOfErrors + ' failures.');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }    
    }
    
}