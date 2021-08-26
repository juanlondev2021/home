/***************************************************************
* Description : This test class created for Choosepricebookcontroller class.
* Modified By: Ganesh
* Modified on:
* Description: Updated the test class as per best practices. 
****************************************************************/

@isTest(seealldata=false)
private class Test_ChoosepricebookController
{
    // creating test records.
    @testsetup static void createtestdata()
    {
        String oppRecTypeId = Schema.Sobjecttype.Opportunity.getRecordTypeInfosByName().get('nuHome Door Tag Script').getRecordTypeId();
        //Account Creation
        Account acc = new Account();
        acc.name = 'testAccount';  
        acc.Primary_Billing_City__c='Sunnyvale';    
        acc.Primary_Billing_Country__c='US';
        acc.Primary_Billing_State__c='CA';
        acc.Primary_Billing_Street__c='260 N Mathilda Ave';
        acc.Primary_Billing_Zip_Code__c='94086'; 
        acc.branch__c = 'CA-San_Jose'; 
        acc.Phone = '1234567892';
        acc.verbal_consent__c = 'Yes';  
        insert acc;
        system.assertnotEquals(null, acc.id);
        
        Pricebook2 pbook = new Pricebook2();
        pbook.Name = 'nuHome Hot Leads - Tier 2';
        pbook.IsActive = True;
        insert pbook;
        system.assertnotEquals(null, pbook.id);
        
        //Opportunity creation
        Opportunity opp = new Opportunity();
        opp.accountId = acc.Id;
        opp.name='TestOpp';
        opp.closeDate = date.today();
        opp.Operational_Stages__c = 'Gift Card Active Customer';
        opp.Forward_to_number__c = 'Test';
        opp.stageName = 'Needs Analysis';
        opp.Art_File__c='sunnyvale'; 
        opp.Back_pdf__c=2;
        opp.Front_pdf__c=2;
        //opp.pricebook2Id = pbook.id;
        opp.recordTypeId = oppRecTypeId;
        opp.OB_Operation_Stage__c = 'Active';
        insert opp;
        system.assertnotEquals(null, opp.id);
    }
    
    static testmethod void createOpp()
    {
        Opportunity opp = [select id from Opportunity limit 1];
        test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        ChoosepricebookController myextention = new ChoosepricebookController(sc); 
        myextention.selectedPriceBookId = '0';
        myextention.savePriceBookName();
        test.stopTest();
    }
    static testmethod void assignPricebook()
    {
        Opportunity opp = [select id from Opportunity limit 1];
        Pricebook2 pb = [select id from Pricebook2 limit 1];
        Update new Opportunity(id = opp.id,pricebook2Id = pb.id);
        Opportunity opp1 = [select id from Opportunity limit 1];
        test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(opp1);
        ChoosepricebookController myextention = new ChoosepricebookController(sc); 
        myextention.savePriceBookName();
        test.stopTest();
    }
    
}