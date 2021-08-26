public class validateEmailNeverBounce {
    public neverBounce__c config{get;set;}
    public diacoValidateEmail dve{get;set;}
    public validateEmailNeverBounce(){
        config = [select Job_id__c, number_of_pages__c,next_page__c, ApiKey__c, First_Job__c, Second_Job__c, Emails_per_page__c, Emails_per_Job__c 
                  from neverBounce__c];
        dve = new diacoValidateEmail();
    }
    
    public neverBounce__c sentJobToNeverBounce(){
        //getting all email to validate
        List<Account> accounts = [SELECT Id, Validate_Email__c, PersonEmail  
                                  FROM Account 
                                  Where PersonEmail != null AND PersonEmail != '' AND Validate_Email__c = '' AND Validate_Email__c = null LIMIT 10000];
        String emailToValidate = '';
        for(Account acc : accounts){
            emailToValidate += '{"id":"'+acc.Id+'","Email":"'+acc.PersonEmail+'"},';
        }
        emailToValidate = emailToValidate.removeEnd(',');
        //creating a job in neverBounce
        responseNeverBounce resNB =  dve.responseNB(dve.validateEmail(config.ApiKey__c, emailToValidate));
        
        //updating config
        config.Job_id__c = String.valueOf(resNB.job_id);
        config.next_page__c = 1;
        upsert config;
        Assignjob(Integer.valueOf(String.valueOf(config.First_Job__c)));
        return config;
    }
    
    @future(callout=true)
    public static void verificateEmailFromNeverBounce(){
        validateEmailNeverBounce venb = new validateEmailNeverBounce();
        venb.getInfofromNeverBounce();
    }
    
    public void getInfofromNeverBounce(){
        //getting job status
        diacoNeverBounceStatus response = dve.reponseNBReStatus(dve.getInfoAboutJobStatus(config.ApiKey__c, String.valueOf(config.Job_id__c)));
        if(response.percent_complete == 100){
            
            if(config.next_page__c == 1){
                
                String number_page = updatingAll();
                config.number_of_pages__c = Integer.valueOf(number_page);
                config.next_page__c = config.next_page__c + 1;
                upsert config;
                deleteJob();
                Assignjob(Integer.valueOf(String.valueOf(config.Second_Job__c)));
                
            }else if(config.next_page__c <= config.number_of_pages__c){
                
                updatingAll();
                config.next_page__c = config.next_page__c + 1;
                upsert config;
                deleteJob();
                Assignjob(Integer.valueOf(String.valueOf(config.Second_Job__c)));
                
            }else if(config.next_page__c > config.number_of_pages__c){
                config.next_page__c = config.number_of_pages__c;
                upsert config;
                deleteJob();
            }
            
        }else{
           deleteJob();
           Assignjob(Integer.valueOf(String.valueOf(config.First_Job__c)));
        }
        
    }    
    
    public String updatingAll(){
        HttpResponse response = dve.getInfoAboutJob(config.ApiKey__c, String.valueOf(config.Job_id__c)+'&page='+config.next_page__c+'&items_per_page='+config.Emails_per_page__c);
        reponseNBResult rest = dve.reponseNBRes(response);
        Map<ID, String> datos = new Map<ID, String>();
        for(resultIn re : rest.results){
            datos.put(re.data.id, re.verification.result);
        }
        Set<ID> ids = datos.keySet();
        List<Account> accounts = [SELECT Id, Validate_Email__c, PersonEmail FROM Account 
                                  Where Validate_Email__c = '' AND Id in :ids];
        List<Account> accoun = new List<Account>();
        Integer i = 0;
        for(Account acc : accounts){
            acc.Validate_Email__c = datos.get(acc.Id);
        } 
        upsert accounts;
        return rest.total_pages;
    }
    
    public void Assignjob(Integer afterTo){
        DateTime myDateTime = System.now().addMinutes(afterTo);
        diacoScheduleNeverbounce request = new diacoScheduleNeverbounce();
        String title = 'neverBounce job';
        String sch = '0 '+myDateTime.minute()+' '+myDateTime.hour()+' '+myDateTime.day()+' '+myDateTime.month()+' ?';
        String jobID = system.schedule(title, sch, request);
        system.debug('jobID = '+jobID);
    }
    //method responsible of deleting the with the name: neverBounce job.
    public void deleteJob(){
        CronTrigger con  = [SELECT Id, CronJobDetail.Name, CronJobDetail.Id, State FROM CronTrigger where CronJobDetail.Name = 'neverBounce job'];
        System.abortJob(con.Id);
        
    }
    
    @AuraEnabled
    public static neverBounce__c getCustomSetting(){
        validateEmailNeverBounce venb = new validateEmailNeverBounce();
        return venb.config;
    }
    
    @AuraEnabled
    public static neverBounce__c saveSettings(neverBounce__c settings){
        upsert settings;
        return settings;
    }
    
    @AuraEnabled
    public static neverBounce__c createNewJob(){
        validateEmailNeverBounce venb = new validateEmailNeverBounce();
        neverBounce__c settings = venb.sentJobToNeverBounce();
        return settings;
    }
    
    @AuraEnabled
    public static String ReinitJob(){
        validateEmailNeverBounce venb = new validateEmailNeverBounce();
        venb.getInfofromNeverBounce();
        return ''+venb.config.next_page__c;
    }
    
    @AuraEnabled
    public static void deleteJobSf(){
        validateEmailNeverBounce venb = new validateEmailNeverBounce();
        venb.deleteJob();
    }
    
}