//This test class created for BrightPatternAddressCreation_AC.
/*
--------------------------
 * Modified By: Ganesh
 * Modified on:
 * Description: Updated the test class as per best practices. 
-----------------------------
*/
@isTest(seealldata = false)
private class BrightPatternAddressCreation_AC_Test{

    @TestSetup static void createtestrecords()
    {
        //Region Creation.
        Region__c regionIns = New Region__c( Name = 'Central' );
        Insert regionIns;
        System.assertnotEquals(null,regionIns.id);
        
        //Branch creation.           
        Branch__c branch = new Branch__c();
        branch.name = 'AL-Birmingham';
        branch.State__c = 'AL';
        branch.Carrier_ID__c = '123';
        branch.Region_MD__c = regionIns.Id;
        Insert branch;
        System.assertnotEquals(null,branch.id);
        
        //Address creation.
        Address__c address = new Address__c();
        address.city__c = 'Test';
        address.county__c= 'Test';
        address.street__c= 'Test Street';
        address.zip_code__c= '12345';
        address.Region_Code__c = '12345';
        address.Zip_Plus_Four__c = '1234';
        address.state__c= 'Test';
        address.country__c= 'Test';
        address.Branch__c = branch.id;  
        address.Home_Type__c = 'CT';    
        address.MSA__c = ''; 
        insert address;
        System.assertnotEquals(null,address.id);
        
        //Industry Creation
        Industry__c industry = new Industry__c();
        industry.name = 'Pest Control';
        industry.Industry_Code__c = '728';
        industry.Pricebook_To_Display__c = 'nuHome OB Campaign; nuHome nuCard CPL; nuHome Door Tag Script; nuHome SPEC CPL; nuHome nuCard SPEC';
        industry.CPL_Active__c = True;
        insert industry;
        System.assertnotEquals(null,industry.id);
        
        //Account Creation
        Account a = new Account();
        a.LastName = 'Test';
        a.PersonMobilePhone = '8220708920';
        a.Verbal_Consent__c = 'Yes';
        a.NuHome_Industry__c = industry.id;
        insert a;
        System.assertnotEquals(null,a.id);
        
        // Pricebook Creation
        Pricebook2 pbook = new Pricebook2();
        pbook.Name = 'nuHome SPEC CPL';
        insert pbook; 
        
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
        opp.OB_Operation_Stage__c = 'Active';
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
        
        // CPL Join creation
        CPL_Joins__c cpljoin = new CPL_Joins__c();
        cpljoin.Lead_Distribution__c = did.Lead_Distribution__c;
        cpljoin.Billing_Opportunity__c = opp.id;
        cpljoin.Sort_Order__c = 0;
        cpljoin.Active_CPL_Join__c = true;
        insert cpljoin; 
        System.assertnotEquals(null,cpljoin.id);         
    }
    static testmethod void testMethod1()
    {
        DID__c did = [select id,fOpportunity_Record_Type__c,Name,POC__c,DID_Type__c  from DID__c limit 1];       
        Address__c address = [select id from Address__c limit 1];
        
        PageReference pageRef = Page.BrightPatternSearchPopup;
        Test.setCurrentPage(pageRef);
        
        ApexPages.currentPage().getParameters().put('Didid', did.Id);
        ApexPages.currentPage().getParameters().put('stepid', '1');
        ApexPages.currentPage().getParameters().put('campaign','Spec');
        ApexPages.currentPage().getParameters().put('address',address.Id);
        
        Test.startTest();
        BrightPatternAddressCreation_AC brightcontroler = new BrightPatternAddressCreation_AC();
        brightcontroler.streetName = 'Test Street';
        brightcontroler.city = 'Test';
        brightcontroler.state = 'Test';
        brightcontroler.zipCode = '12345';
        brightcontroler.FirstName = 'Test';
        brightcontroler.lastName = 'Test';
        brightcontroler.scanCode = 'Test';
        brightcontroler.Country = 'Test';
        brightcontroler.PersonEmail = 'mstsolutions@gmail.com';
        brightcontroler.phone = '9600467559';
        brightcontroler.isConfirm = true;
        brightcontroler.acknowledge = 'Address is already in system. Please enter person account details.';
        brightcontroler.SearchAddress();
        brightcontroler.getStates();
        brightcontroler.getAddressType();
        Test.stopTest();   
    }
    static testmethod void testMethod2()
    {      
        DID__c did = [select id,fOpportunity_Record_Type__c,Name,POC__c,DID_Type__c  from DID__c limit 1];                    
        Address__c address = [select id from Address__c limit 1];
        
        PageReference pageRef = Page.BrightPatternSearchPopup;
        Test.setCurrentPage(pageRef);
        
        ApexPages.currentPage().getParameters().put('Didid', did.Id);
        ApexPages.currentPage().getParameters().put('stepid', '1');
        ApexPages.currentPage().getParameters().put('campaign','Spec');
        ApexPages.currentPage().getParameters().put('address',address.Id);
     
        Test.startTest();
        BrightPatternAddressCreation_AC brightcontroler = new BrightPatternAddressCreation_AC();
        BrightPatternAddressCreation_AC.AddressWrapper addressWrap = new BrightPatternAddressCreation_AC.AddressWrapper();
        addressWrap.City = 'Test';
        addressWrap.State = 'Test';
        addressWrap.Zip4 = '5487';       
        
        brightcontroler.streetName = 'negative';
        brightcontroler.city = 'negative';
        brightcontroler.state = 'negative';
        brightcontroler.zipCode = '12345';
        brightcontroler.FirstName = 'negative';
        brightcontroler.lastName = 'negative';
        brightcontroler.scanCode = 'negative';
        brightcontroler.Country = 'negative';
        brightcontroler.PersonEmail = 'mstsolutions@gmail.com';
        brightcontroler.phone = '9600467559';
        brightcontroler.isConfirm = true;
        brightcontroler.acknowledge = 'Address is already in system. Please enter person account details.';
        brightcontroler.responseAddressWrap = addressWrap;
        Test.setMock(HttpCalloutMock.class, new MockAddressValidationResponseGenerator());   
        brightcontroler.SearchAddress();        
        brightcontroler.getStates();
        brightcontroler.getAddressType();
        brightcontroler.GotoAccSearchPage();
        Test.stopTest();
    }
}