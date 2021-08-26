/*
--------------------------
 * Modified By: Ganesh
 * Modified on:
 * Description: This test class cover CallLogTrigger and CallLogTriggerHandler. Updated the test class as per best practices. 
-----------------------------
*/
@istest(seealldata=false)
private class CallLogTriggerTest{
    @testSetup static void loadData() {
        //Industry Creation
        Industry__c industry = new Industry__c();
        industry.name = 'Pest Control';
        industry.Industry_Code__c = '728';
        industry.Pricebook_To_Display__c = 'nuHome OB Campaign; nuHome nuCard CPL; nuHome Door Tag Script; nuHome SPEC CPL; nuHome nuCard SPEC';
        industry.CPL_Active__c = True;
        insert industry;
        System.assertnotEquals(null,industry.id);
        
        // Test Account Creation
        Account a = new Account();
        a.LastName = 'Test';
        a.PersonMobilePhone = '8220708920';
        a.Phone = '8220708920';
        a.Verbal_Consent__c = 'Yes';
        a.NuHome_Industry__c = industry.id;
        a.Verbal_consent__c = 'Yes';
        a.Phone_was_added_to_wrong_account__c = True;
        insert a; 
        System.assertnotEquals(null,a.id);
        
        // Pricebook Creation
        Pricebook2 pbook = new Pricebook2();
        pbook.Name = 'nuHome SPEC CPL';
        insert pbook;
        
        Id oppCPLid = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('nuHome nuCard CPL').getRecordTypeId();
        // Opportunity Creation.
        
        Opportunity opp = new Opportunity();
        opp.accountId = a.Id;
        opp.name='TestOpp';
        opp.closeDate = date.today();
        opp.Operational_Stages__c = 'Gift Card Active Customer';
        opp.Forward_to_number__c = '8220708920';
        opp.stageName = 'Needs Analysis';
        opp.Art_File__c='sunnyvale'; 
        opp.Back_pdf__c=2;
        opp.Front_pdf__c=2;
        opp.pricebook2Id = pbook.id;
        opp.recordTypeId = oppCPLid;
        opp.OB_Operation_Stage__c = 'Active';
        opp.NuCard_Industry__c = 'Pest Control';
        insert opp; 
        System.assertnotEquals(null,opp.id);
        
        // Lead Distribution Creation.
        Lead_Distribution__c ld = new Lead_Distribution__c();
        ld.Account__c = a.id;
        ld.opportunity__c = opp.id;
        ld.VF_CPL_Location__c = 0;
        insert ld;
        System.assertnotEquals(null,ld.id);
        
        // Did creation.
        DID__c did = new DID__c();
        did.POC__c = '8220708920';
        did.Destination_Number__c = '8220708920';
        did.DID_Type__c = 'DT Script';
        did.Opportunity__c = opp.id;
        did.Responsible_Organization__c = 'test';
        did.DID_Type__c = 'CPL';
        did.Lead_Distribution__c = ld.id;
        insert did;  
        System.assertnotEquals(null,did.id);      
    }
    static testMethod void myTest()
    {
        test.startTest();
        //insert call log record
        Account acc = [select id from account limit 1];
        did__c did =[select id from did__c limit 1];
        Id devRecordTypeId = Schema.SObjectType.Call_Log__c.getRecordTypeInfosByName().get('nuHome nuCard SPEC').getRecordTypeId();
        Call_Log__c recCallLog = new Call_Log__c(Account__c = acc.id,Answered_Duration__c = 80,
                                                RecordTypeid = devRecordTypeId ,Service__c ='nuHome nuCard SPEC',
                                                 Agent_Disposition__c ='Forward to Business',Inventory_Created__c =false,did__c=did.id);
        Insert recCallLog;
        System.debug([select id,recordtypeid from call_log__c limit 1].recordtypeid);
        
        call_log__c t = [select id,DNIS__c from call_log__c limit 1];
        t.DNIS__c ='1234567890';
        update t; 
        test.stopTest();
    }
}