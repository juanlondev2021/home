// This test class created for LeadTrigger.

@isTest(seealldata=false)
private class LeadTrigger_Test{

    static testmethod void UpdateLeadTypeWithoutNull(){
        test.startTest();
        Lead currLead = new Lead();
        currLead.Company = 'TestMST1';
        currLead.Branch__c = 'AL-Birmingham';
        currLead.LastName = 'TestLead1';
        currLead.Status = 'Open';
        currLead.Jigsaw = '124435245';
        currLead.LeadSource = 'Jigsaw';
        insert currLead;
        system.assertnotEquals(null,currLead.id);
        test.stopTest();
    }
    
}