public class DiacoLeadFormsManageController {
    @AuraEnabled
    public static List<Lead_Form__c> getLeadForms(){  
        String query = 'select Id, First_Name__c, Last_Name__c, Street__c, City__c, State__c, Zip__c, Phone__c'
            + ' from Lead_Form__c'
            + ' order by CreatedDate desc';
        
        system.debug(query);
        List<Lead_Form__c> LeadFormsList = Database.query(query);
        
        return LeadFormsList;
    }
    @AuraEnabled
    public static Lead_Form__c saveLeadForm(Lead_Form__c leadForm){
        update leadForm;
        return leadForm;
    }
    @AuraEnabled
    public static List<Task> createLogCall(Task task){
        insert task;
        
        String query = 'select Subject, ActivityDate, Description, Dispositions__c'
            + ' from Task'
            + ' where WhatId = \'' + task.WhatId + '\''
            + ' order by CreatedDate desc';
        List<Task> TaskList = Database.query(query);   
        
        return TaskList;
    }
    @AuraEnabled
    public static DataSet getLeadForm(String recordId){  
        String query = 'select Id, First_Name__c, Last_Name__c, Street__c, City__c, State__c, Zip__c, Phone__c,Account__c,Email__c'
            + ' from Lead_Form__c'
            + ' where Id = \'' + recordId + '\'';
        system.debug(query);
        List<Lead_Form__c> LeadFormsList = Database.query(query);
        
        if(LeadFormsList.size() > 0){
            query = 'select Subject, ActivityDate, Description, Dispositions__c'
                + ' from Task'
                + ' where WhatId = \'' + recordId + '\''
                + ' order by CreatedDate desc';
           	List<Task> TaskList = Database.query(query);
            
            return new DataSet(LeadFormsList[0], TaskList);
        }
        return null;
    }
    
    
    
    public class DataSet{
        @AuraEnabled
        public Lead_Form__c LeadForm {get;set;}
        @AuraEnabled
        public List<Task> Tasks {get;set;}
        
        public DataSet(Lead_Form__c LeadForm, List<Task> Tasks){
            this.LeadForm  = LeadForm; 
            this.Tasks     = Tasks;
        }
        
    }
    @AuraEnabled
    public static List<Account> getPossibleAccounts(String LeadPhone,String LeadEmail){
        List<Account> accounts=[SELECT id,Name,City__c,Phone,PersonEmail,State__c FROM Account Where Phone=:LeadPhone and PersonEmail=:LeadEmail];
        return accounts;
    }
    
    @AuraEnabled
    public static void associateLeadFormWithAccount(String LeadId,String AccountId){
        Lead_Form__c lead=[SELECT Id,Account__c FROM Lead_Form__c where Id=:LeadId];
        lead.Account__c=AccountId;
        update lead;
    }
    
    @AuraEnabled
    public static Account AccountgetAssociatedAccount(String AccountId){
        Account account=[SELECT id,Name,City__c,Phone,PersonEmail,State__c FROM Account Where Id=:AccountId Limit 1];
        return account;
    }
    
    @AuraEnabled
    public static Lead_Form__c getIndividualLeadForm(String recordId){
        Lead_Form__c lead=[SELECT Id, First_Name__c, Last_Name__c, 
                           Street__c, City__c, State__c, Zip__c, Phone__c,
                           Account__c,Email__c FROM Lead_Form__c where Id=:recordId Limit 1];
        return lead;
    }
    
    @AuraEnabled
    public static Map<String, String> getCountyData() {
        return DiacoWaterContractController.getCountyData();
    }
}