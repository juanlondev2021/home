global class DiacoApplicationDISCBatch implements  Database.Batchable<sObject>,Database.AllowsCallouts {
    
    global List<deapp__Applicant__c> start(Database.BatchableContext bc) {
        
        list<deapp__Applicant__c> listToCheck = [SELECT id,Disc_Emails_Sent__c,
                                                 Last_DISC_Date__c,
                                                  Name,
                                                 deapp__Email__c,
                                                 deapp__Position_Applied_for__c,
                                                 deapp__Vacancy__r.deapp__Title__c,  
                                                 deapp__Vacancy__r.deapp__Hiring_Manager__r.name,
                                                 deapp__Vacancy__r.Company_Name__c,
                                                 deapp__City__c,
                                                 deapp__State__c,
                                                 deapp__Training_End_Date__c,
                                                 deapp__Training_Start_Date__c
                                                 FROM deapp__Applicant__c
                                                 WHERE Meets_DISC_Profile_Required__c = null 
                                                 and deapp__Status__c ='DISC Sent'
                                                 and Disc_Emails_Sent__c!=null
                                                 and Last_DISC_Date__c!=null];
        return listToCheck;
        
    }
    
    global void execute(Database.BatchableContext bc, List<deapp__Applicant__c> scope){
        list<deapp__Applicant__c> listToSendEmail = new list<deapp__Applicant__c>(); 
        list<deapp__Applicant__c> listToUpdate = new list<deapp__Applicant__c>();
        system.debug('Scope');
        system.debug(scope);
        for(deapp__Applicant__c application:scope){
            //Entro a for Scope
            System.debug('For Scope');
            system.debug('Current application');
            system.debug(application);
            system.debug('Emails sent <3:');
            system.debug(application.Disc_Emails_Sent__c<3 );
            system.debug('Fecha added 5:');
            system.debug(application.Last_DISC_Date__c.addDays(5));
            system.debug('Mas 5 es menor a now:');
            system.debug(application.Last_DISC_Date__c.addDays(5)< System.now());
            
            if(application.Disc_Emails_Sent__c<3 && application.Last_DISC_Date__c.addDays(5)< System.now()){
                System.debug('Mandar email');
                //listToSendEmail.add(new deapp__Applicant__c(Id = application.Id));
                listToSendEmail.add(application);
            }else if(application.Disc_Emails_Sent__c==3 && application.Last_DISC_Date__c.addDays(5)<System.now()){
                System.debug('Actualizar');
                listToUpdate.add(new deapp__Applicant__c(Id = application.Id,deapp__Status__c ='DISC Not Returned'));
                
            }
        }//We create a list of email history
        list<Application_Email_History__c> historyList = new list<Application_Email_History__c>();
        System.debug('List to Re-Send Email: ');
        System.debug(listToSendEmail); 
        if(listToSendEmail.size()>0){
            for(deapp__Applicant__c application:listToSendEmail){
                DiacoApplicationAndEmailHistory response=DiacoSendVacancyEmails.sendEmailBatch(application, 'DISCAssessmentSent');
                listToUpdate.add(response.app);
               historyList.add(response.history);
                //MAKE EMMAILS HISTOORY
                
            }
        }
        System.debug('List to Update: ');
        System.debug(listToUpdate); 
        if(listToUpdate.size()>0){
            system.debug('UPDATED');
            update listToUpdate;
        }
            
        if(historyList.size()>0)insert historyList;
    } 
    
    
    global void finish(Database.BatchableContext bc){
    } 
}