//This test class created for BrightPatternSearchPopup_AC.
@isTest(seealldata = false)
private class BrightPatternSearchPopup_AC_Test{
    //creating a test records
    @TestSetup static void createTestrecords()
    {
        // Industry Creation
        Insert new Industry__c(name = 'Pest Control',Industry_Code__c = '728',CPL_Active__c = True,
                    Pricebook_To_Display__c = 'nuHome OB Campaign; nuHome nuCard CPL; nuHome Door Tag Script; nuHome SPEC CPL; nuHome nuCard SPEC');
        Industry__c recInd = [select id from industry__c limit 1];
        System.assertNotEquals(null,recInd.Id);

        // Test Account Creation
        Insert new Account(LastName = 'Test',PersonMobilePhone = '9876543210',Verbal_Consent__c = 'Yes',NuHome_Industry__c = recInd.id);
        Account recAcc = [select id from Account limit 1];
        System.assertNotEquals(null,recAcc.Id);

        // Pricebook Creation
        Insert new Pricebook2(Name = 'nuHome SPEC CPL');
        Pricebook2 recPb2 = [select id from Pricebook2 limit 1];
        System.assertNotEquals(null,recPb2.Id);

        // Opportunity Creation
        Insert new Opportunity(accountId = recAcc.Id,name='TestOpp',closeDate = date.today(),Operational_Stages__c = 'Gift Card Active Customer',
                    Forward_to_number__c = '8220708920',stageName = 'Needs Analysis',Art_File__c='sunnyvale',Back_pdf__c=2,Front_pdf__c=2,
                    pricebook2Id = recPb2.Id,OB_Operation_Stage__c = 'Active');
        Opportunity recOpp = [select id from Opportunity limit 1];
        System.assertNotEquals(null,recOpp.Id);

        // Lead Distribution Creation
        Insert new Lead_Distribution__c(Account__c = recAcc.id,opportunity__c = recOpp.id,VF_CPL_Location__c = 0);
        Lead_Distribution__c recLD = [select id from Lead_Distribution__c limit 1];
        System.assertNotEquals(null,recLD.Id);      

        // Did creation
        Insert new DID__c(POC__c = '8220708920',Destination_Number__c = '8220708920',DID_Type__c = 'DT Script',
                            Opportunity__c = recOpp.Id,Responsible_Organization__c = 'test',Lead_Distribution__c = recLD.Id);
        DID__c recDID = [select id from DID__c limit 1];
        System.assertNotEquals(null,recDID.Id);

        // CPL Join creation
        Insert new CPL_Joins__c(Lead_Distribution__c = recDID.Lead_Distribution__c=recLD.Id,Billing_Opportunity__c = recOpp.id,
                                            Sort_Order__c = 0,Active_CPL_Join__c = true);
        CPL_Joins__c recCPLJoin = [select id from CPL_Joins__c limit 1];
        System.assertNotEquals(null,recCPLJoin.Id);

        //Region creation
        Insert new Region__c ( Name = 'Central' );
        Region__c recRegion = [select id from Region__c limit 1];
        System.assertNotEquals(null,recRegion.Id);

        //Branch creation
        Insert new Branch__c(Name = 'AZ-Test Branch',Carrier_ID__c='Test',Branch_stage__c = 'Delivering',Region_MD__c = recRegion.Id);
        Branch__c recBranch = [select id from Branch__c limit 1];
        System.assertNotEquals(null,recBranch.Id);

        //Address Creation
        Insert new Address__c(city__c = 'Test',county__c= 'Test',street__c= 'Test Street',zip_code__c= '12345',Branch__c = recBranch.Id,
                                Region_Code__c = '12345',Zip_Plus_Four__c = '1234',state__c= 'Test',country__c= 'Test', 
                                Home_Type__c = 'CT',MSA__c = '',Invalid__c = True,Unique_Key__c = 'Test Street:12345');
        Address__c recAddress = [select id from Address__c limit 1];
        System.assertNotEquals(null,recAddress.Id);

        //Account creation
        Insert new Account(FirstName = 'Test',LastName = 'Account Record',Home_Type__c = 'SF', Phone = '98737262',
                                              PersonEmail = 'testAcc@ymail.com', Primary_Shipping_State__c = 'AZ',
                                              Primary_Shipping_County__c = 'Test County', Primary_Shipping_Zip_Code__c = '27007',
                                              Sales_Price__c = 1000, Recording_Date__c = Date.Today(), Branch__c = 'AZ-Test Branch');
        Account recAcc1 = [select id from Account where PersonEmail = 'testAcc@ymail.com' limit 1];
        System.assertNotEquals(null,recAcc1.Id);

        //User address Creation
        Insert new User_Address__c(Address__c = recAddress.Id,UserAccount__c = recAcc1.Id,User_Address_Type__c = 'Primary Owner',
                            Active__c = true,Sales_Price__c = 1000,Recording_Date__c = Date.Today()); 
        User_Address__c recUA = [select id from User_Address__c limit 1];
        System.assertNotEquals(null,recUA.Id);
    }
         
    static testmethod void testMethod1()
    {
        test.startTest();
            DID__c recDID = [select id,fOpportunity_Record_Type__c,Name,POC__c,DID_Type__c from DID__c limit 1];

            PageReference pageRef = Page.BrightPatternSearchPopup;
            Test.setCurrentPage(pageRef);
          
            BrightPatternSearchPopup_AC brightcontroler = new BrightPatternSearchPopup_AC();
            ApexPages.currentPage().getParameters().put('Didid', recDID.Id);
            ApexPages.currentPage().getParameters().put('stepid', '1');
            ApexPages.currentPage().getParameters().put('campaign','Spec');
            System.debug('test address '+ brightcontroler.selectedAddress);
            brightcontroler.scanCode = 'Test';
            brightcontroler.name = 'MST';
            brightcontroler.streetNumber = '23';
            brightcontroler.streetName = 'ThillaiNagra';
            brightcontroler.city = 'Trichy';
            brightcontroler.state = 'TamilNadu';
            brightcontroler.zipCode = '620017';
            brightcontroler.getPageNumber();
            brightcontroler.getTotalPages();
            brightcontroler.Beginning();
            brightcontroler.Previous();
            brightcontroler.Next();
            brightcontroler.End();
            brightcontroler.getDisablePrevious();
            brightcontroler.getDisableNext();
            brightcontroler.searchAccount();
            // brightcontroler.ValidateSearchAccount();
            brightcontroler.GotoAccCreatePage();
        test.stopTest();
    }
    static testmethod void testMethod2()
    {
        test.startTest();
            User_Address__c recUA = [SELECT Id, Address__c, UserAccount__c, User_Address_Type__c, Active__c, Recording_Date__c FROM User_Address__c LIMIT 1];
            
            DID__c recDID = [select id,fOpportunity_Record_Type__c,Name,POC__c,DID_Type__c from DID__c limit 1];

            PageReference pageRef = Page.BrightPatternSearchPopup;
            Test.setCurrentPage(pageRef);

            BrightPatternSearchPopup_AC brightcontroler = new BrightPatternSearchPopup_AC();
            ApexPages.currentPage().getParameters().put('Didid', recDID.Id);
            ApexPages.currentPage().getParameters().put('stepid', '1');
            ApexPages.currentPage().getParameters().put('campaign','Spec');
            brightcontroler.getStates();
            brightcontroler.scanCode = 'Test';
            brightcontroler.name = 'MST';
            brightcontroler.streetNumber = '23';
            brightcontroler.streetName = 'ThillaiNagra';
            brightcontroler.city = 'Trichy';
            brightcontroler.state = 'TamilNadu';
            brightcontroler.zipCode = '620017';
            brightcontroler.phone = '9876543210';
            brightcontroler.confirmationNumber = '564678965';
            brightcontroler.getPageNumber();
            brightcontroler.getTotalPages();
            brightcontroler.Beginning();
            brightcontroler.Previous();
            brightcontroler.closePopup();
            brightcontroler.Next();
            brightcontroler.getDisablePrevious();
            brightcontroler.getDisableNext();
            brightcontroler.searchAccount();
            brightcontroler.searchAccountId = recUA.id;
            brightcontroler.ValidateSearchAccount();
            brightcontroler.GotoAccCreatePage();
            Test.setMock(HttpCalloutMock.class, new MockAddressValidationResponseGenerator());   
            brightcontroler.Validate();
            BrightPatternSearchPopup_AC.AddressWrapper addressWrap = new BrightPatternSearchPopup_AC.AddressWrapper();
            addressWrap.City = 'Test';
            addressWrap.State = 'Test';
            addressWrap.Zip4 = '5487'; 
            brightcontroler.responseAddressWrap = addressWrap;
            brightcontroler.saveAddress();
            brightcontroler.createAddress();
        test.stopTest();
    }
    
    static testmethod void testMethod3()
    {    
        test.startTest();
            User_Address__c recUA = [SELECT Id, Address__c, UserAccount__c, User_Address_Type__c, Active__c, Recording_Date__c FROM User_Address__c LIMIT 1];
            DID__c recDID = [select id,fOpportunity_Record_Type__c,Name,POC__c,DID_Type__c  from DID__c];
            
            PageReference pageRef = Page.BrightPatternSearchPopup;
            Test.setCurrentPage(pageRef);
            
            BrightPatternSearchPopup_AC brightcontroler = new BrightPatternSearchPopup_AC();
            ApexPages.currentPage().getParameters().put('Didid', recDID.Id);
            ApexPages.currentPage().getParameters().put('stepid', '1');
            ApexPages.currentPage().getParameters().put('campaign','Spec');
            brightcontroler.getStates();
            brightcontroler.scanCode = 'Test';
            brightcontroler.name = 'MST';
            brightcontroler.streetNumber = '23';
            brightcontroler.streetName = 'ThillaiNagra';
            brightcontroler.city = 'Trichy';
            brightcontroler.state = 'TamilNadu';
            brightcontroler.zipCode = '620017';
            brightcontroler.searchAccountId = recUA.id;
            brightcontroler.ValidateSearchAccount();
            BrightPatternSearchPopup_AC.AddressWrapper addressWrap = new BrightPatternSearchPopup_AC.AddressWrapper();
            addressWrap.City = 'Test';
            addressWrap.State = 'Test';
            addressWrap.Zip4 = '5487'; 
            brightcontroler.responseAddressWrap = addressWrap;
            brightcontroler.saveAddress();
            brightcontroler.createAddress();
        test.stopTest();
    }
}