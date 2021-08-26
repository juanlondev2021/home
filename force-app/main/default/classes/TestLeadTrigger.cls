// This test class created for LeadTrigger.

@isTest
public class TestLeadTrigger {
    
    static testmethod void UpdateLeadType(){
        Lead currLead = new Lead();
        
        currLead.Company = 'TestMST';
        currLead.Branch__c = 'AL-Birmingham';
        currLead.LastName = 'TestLead';
        currLead.Status = 'Open';
        currLead.Jigsaw = '';
        currLead.LeadSource = 'Jigsaw';
       
        insert currLead;
    }
    static testmethod void UpdateLeadTypeWithoutNull(){
        Lead currLead = new Lead();
        
        currLead.Company = 'TestMST1';
        currLead.Branch__c = 'AL-Birmingham';
        currLead.LastName = 'TestLead1';
        currLead.Status = 'Open';
        currLead.Jigsaw = '124435245';
         currLead.LeadSource = 'Jigsaw';
        insert currLead;
    }

}