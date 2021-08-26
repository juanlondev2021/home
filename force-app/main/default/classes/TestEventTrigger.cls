/****************************************************************
This Test Class crated for Event Trigger.
******************************************************************/

@isTest
public class TestEventTrigger {

    public static Event testEvent;   
    //creating test records. 
    public static testmethod void eventInsert(){
        
        Account testAccount = new Account();
        testAccount.Name = 'TestAccount';
        testAccount.Phone = '1234567893';
        insert testAccount;
        
        Opportunity testOpportunity = new Opportunity();
        testOpportunity.Name = 'TestOpportunity';
        testOpportunity.AccountId = testAccount.Id;
        testOpportunity.StageName = 'Qualified';
        testOpportunity.CloseDate = system.today();
        insert testOpportunity;
        
        testEvent = new Event();
        testEvent.WhatId = testOpportunity.Id; 
        testEvent.StartDateTime = system.today() + 1;
        testEvent.EndDateTime = system.today() + 2;
        insert testEvent;

     }
    
    public static testmethod void eventUpdate(){
        eventInsert();      
       
        testEvent.Subject = 'Test';
        testEvent.StartDateTime = system.today() -1;
        testEvent.EndDateTime = system.today();
        testEvent.Completed__c = True ;
        update testEvent;
        
        

     }
    

}