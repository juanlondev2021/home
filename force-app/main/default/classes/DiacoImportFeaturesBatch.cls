public with sharing class DiacoImportFeaturesBatch implements Database.Batchable<DiacoImportFeaturesBatch.importPackage>{
    List<importPackage> importPackages;
    Boolean deliveries = false;
    public DiacoImportFeaturesBatch(List<importPackage> packages) {
        this.importPackages = packages;
    }
    public DiacoImportFeaturesBatch(List<importPackage> packages,Boolean option) {
        this.importPackages = packages;
        this.deliveries = option;
    }
    public List<importPackage> start(Database.BatchableContext bc) {
        return importPackages;
    }
    public void execute(Database.BatchableContext bc, List<importPackage> scope){
        List<Account> accounts = new List<Account>();
        List<Address__c> address = new List<Address__c>();
        List<User_Address__c> uaddress = new List<User_Address__c>();
        for (importPackage pack:scope){
            accounts.add(pack.account);
            address.add(pack.address);
        }
        if(!accounts.isEmpty()){
            insert accounts;
            Database.Insert(address,false);
        }
        if(!accounts.isEmpty()){
            for(importPackage pack:scope){
                pack.uaddress.UserAccount__c=pack.account.Id;
                uaddress.add(pack.uaddress);
            }
        }
        if(!uaddress.isEmpty()){
            insert uaddress;
        }
    }
    public void finish(Database.BatchableContext bc){
        if(deliveries){
            System.debug('Import Deliveries');
            DiacoImportFeatures.createDeliveries();
        }
        // execute any post-processing operations
        /*
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors,ExtendedStatus,
                            JobItemsProcessed,
                            TotalJobItems, CreatedBy.Email
                            FROM AsyncApexJob
                            WHERE Id = :bc.getJobId()];
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] {'jeison14.99@gmail.com'};
       	message.optOutPolicy = 'FILTER';
        message.subject = 'Docusign Delete Status: ';
        message.plainTextBody ='Id: '+job.Id+ '\n Status: '+job.Status+
        '\n Number of Error: '+ job.NumberOfErrors+
        '\n Job items Processed: '+ job.JobItemsProcessed+
        '\n Total Job items: '+ job.TotalJobItems+
        '\n Status Detail: ' +job.ExtendedStatus;
        
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
        Messaging.SendEmailResult[] results =  new Messaging.SendEmailResult[]{};
        if(!Test.isRunningTest()){results = Messaging.sendEmail(messages);}
        
        
        if (!results.isEmpty() && results[0].success) {
            System.debug('The email was sent successfully.');
        } else if(!results.isEmpty()){
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        }*/
    }

    public class importPackage{
        public Account account;
        public Address__c address;
        public User_Address__c uaddress;
        
        public importPackage(Account acct, Address__c addr, User_Address__c uaddr){
            this.account=acct;
            this.address = addr;
            this.uaddress = uaddr;
        }
    }
}