global class validateEmailAccount implements 
    Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
        global Integer recordsProcessed = 0;
        global Database.QueryLocator start(Database.BatchableContext bc) {
            return Database.getQueryLocator([select Id, PersonEmail, Validate_Email__c from Account]
        );
    }
    global void execute(Database.BatchableContext bc, List<sObject> records){
        List<Account> accounts = (List<Account>) records;
        for (Account account : accounts) {
            if(account.PersonEmail != ''){
                diacoValidateEmail.validateAccountvalidate(account.PersonEmail, account.Id); 
                recordsProcessed = recordsProcessed + 1;
            }
        }
        System.debug('valid');
    }    
    global void finish(Database.BatchableContext bc){
        System.debug('Number of emails: '+recordsProcessed);
    }  

}