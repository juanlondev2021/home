@isTest
public class DiacoLeadFormsManageControllerTest {
    @isTest static void testAll(){
        //Test getLeads
        DiacoLeadFormsManageController.getLeadForms();
        Lead_Form__c lead=new Lead_Form__c();
        insert lead;
         Lead_Form__c returnLead=DiacoLeadFormsManageController.saveLeadForm(lead);
        //Test Tasks
        Account a = new Account(Name='Sample Account');
        insert a;
        Task task= new Task(
            ActivityDate = Date.today().addDays(7),
            Subject='Sample Task',
            WhatId = a.Id,
            OwnerId = UserInfo.getUserId(),
            Status='In Progress');
        
        list<Task> taskList= DiacoLeadFormsManageController.createLogCall(task);
        //test public static DataSet getLeadForm(String recordId)
        Object x=DiacoLeadFormsManageController.getLeadForm(lead.Id);
        Object y=DiacoLeadFormsManageController.getLeadForm(task.Id);
        
        //getPossibleAccounts(String LeadPhone,String LeadEmail)
       Object list1= DiacoLeadFormsManageController.getPossibleAccounts('212121','john@gmail.com');
        
        //associateLeadFormWithAccount(String LeadId,String AccountId)
        DiacoLeadFormsManageController.associateLeadFormWithAccount(lead.Id,a.Id);
        
        //AccountgetAssociatedAccount(String AccountId)
        Account b=DiacoLeadFormsManageController.AccountgetAssociatedAccount(a.Id);
        
        // Lead_Form__c getIndividualLeadForm(String recordId)
        Lead_Form__c lead2=DiacoLeadFormsManageController.getIndividualLeadForm(lead.Id);
        
        // Test getCountyData()
        County__c countyA = new County__c(County_Name__c='County A');
        County__c countyB = new County__c(County_Name__c='County B');
        List<County__c> counties = new List<County__c>{countyA, countyB};
        insert counties;
        Map<String, String> countyResult = DiacoLeadFormsManageController.getCountyData();
        System.assertNotEquals(countyResult, null);
        System.assertEquals(countyResult.size(), 2);
    }
}