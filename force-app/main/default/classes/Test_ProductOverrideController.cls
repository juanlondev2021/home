/**********************************************************************
* Description : This test class created for ProductOverrideController class.
* Modified By: Ganesh
* Modified on:
* Description: Updated the test class as per best practices.
************************************************************************/

@isTest(seealldata=false)
private class Test_ProductOverrideController
{
    // creating test records.
    @TestSetup static void createRecords()
    {
        String oppRecTypeId = Schema.Sobjecttype.Opportunity.getRecordTypeInfosByName().get('nuHome Door Tag Script').getRecordTypeId();
        
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
        pbook.isactive = true;
        insert pbook;
        
        Industry__c curInd = new Industry__c();
        curInd.Name = 'Mattresses';
        curInd.Industry_Code__c = '66';
        curInd.Pricebook_To_Display__c = 'nuHome Door Tag Script';
        insert curInd;
        
        Product2 p2 = new product2(name='Az-Phenix-Mattresses',Industry__c = curInd.id,IsActive = true);
        insert p2;
        
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
        opp.pricebook2Id = pbook.id;
        opp.recordTypeId = oppRecTypeId;
        opp.OB_Operation_Stage__c = 'Active';
        insert opp;
        
    }
    
    static testmethod void productOverride()
    {
        Account a = [SELECT ID FROM ACCOUNT LIMIT 1];
        OPPORTUNITY OPP = [SELECT ID FROM OPPORTUNITY LIMIT 1];
        Product2 p2 = [SELECT ID FROM Product2 LIMIT 1];
        Pricebook2 pbook = [SELECT ID FROM Pricebook2 LIMIT 1];
        
        Id stdPbookId = Test.getStandardPricebookid();
        insert new PricebookEntry(pricebook2id = stdPbookId, product2id = p2.id,unitprice=1.0, isActive=true);
        insert new PricebookEntry(pricebook2id = pbook.id, product2id = p2.id,unitprice=1.0, isActive=true);

        Test.startTest();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        ProductOverrideController myextention = new ProductOverrideController(sc); 
        
        myextention.selectedCity = 'Phenix';
        myextention.selectedState = 'Az';
        myextention.selectedIndustry = 'Mattresses';
        myextention.selectedPriceBookId = pbook.id; 
        
        myextention.getStates();
        myextention.getIndustries();
        myextention.getCities();
        myextention.Search();
        myextention.Beginning();
        myextention.onCancel();
        myextention.Next();
        myextention.End();
        myextention.getDisablePrevious();
        myextention.getDisableNext();
        myextention.getPageNumber();
        myextention.savePriceBook();
        myextention.getTotalPages();
        myextention.addToShoppingCart();
        myextention.onSave();
        myextention.removeFromShoppingCart();
        myextention.clear();
        // myextention.Previous();
        Test.stopTest();
        
    }
    
    static testmethod void productOverride1()
    {
        Account aCC = [SELECT ID FROM ACCOUNT LIMIT 1];
        
        String oppRecTypeId = Schema.Sobjecttype.Opportunity.getRecordTypeInfosByName().get('nuHome Door Tag Script').getRecordTypeId();
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
        // opp.pricebook2Id = pbook.id;
        opp.recordTypeId = oppRecTypeId;
        opp.OB_Operation_Stage__c = 'Active';
        insert opp;
        
        Product2 p2 = [SELECT ID FROM Product2 LIMIT 1];
        Pricebook2 pbook = [SELECT ID FROM Pricebook2 LIMIT 1];
        
        Id stdPbookId = Test.getStandardPricebookid();
        insert new PricebookEntry(pricebook2id = stdPbookId, product2id = p2.id,unitprice=1.0, isActive=true);
        insert new PricebookEntry(pricebook2id = pbook.id, product2id = p2.id,unitprice=1.0, isActive=true);
        
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        ProductOverrideController myextention = new ProductOverrideController(sc); 
        Test.stopTest();
        
    }
    
}