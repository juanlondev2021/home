/*********************************************************
* Description : This test class created for nuHomeInventoryHandler class.
* Modified By: Ganesh
* Modified on:
* Description: Updated the test class as per best practices.
**********************************************************/

@isTest(seealldata = false)
private class Test_nuHomeInventoryHandler
{
    // creating test records.
    static testMethod void DoorTagScript(){
        List<Door_Tag_Script__c> DtsList = new List<Door_Tag_Script__c>();
        for(integer i=0; i<20; i++){
            
            Door_Tag_Script__c newDoor = new Door_Tag_Script__c();
           // newDoor.account__C = acclist[0].Id;
            newDoor.Pest_Control__c = 'Yes';
            newDoor.Consent__c = 'Yes';
            newDoor.additional_Industry__c = 'Pest Control,Handman';
            DtsList.add(newDoor);
            
        }
        if(DtsList.size()>0)
            insert DtsList;
    }
    
    static testmethod void createSurvey()
    {
        List<account> accList = new List<Account>();
        String oppRecTypeId = Schema.Sobjecttype.Opportunity.getRecordTypeInfosByName().get('nuHome Door Tag Script').getRecordTypeId();
        for(integer i=0; i<20; i++)
        {
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
            accList.add(acc);
            
        }
        
        if(accList.size() > 0)
            insert acclist;
        
        Opportunity opp = new Opportunity();
        opp.accountId = acclist[0].Id;
        opp.name='TestOpp';
        opp.closeDate = date.today();
        opp.Operational_Stages__c = 'Gift Card Active Customer';
        opp.Forward_to_number__c = 'Test';
        opp.stageName = 'Needs Analysis';
        opp.Art_File__c='sunnyvale'; 
        opp.Back_pdf__c=2;
        opp.Front_pdf__c=2;
        opp.recordTypeId = oppRecTypeId;
        opp.OB_Operation_Stage__c = 'Active';
        opp.Sort_Order__C = 1;
        insert opp;
        
        Industry_Values__c industry1 = new Industry_Values__c();
        industry1.name = 'Flooring__c';
        industry1.Label__c = 'Flooring/Carpeting';
        insert industry1;
        
        Id pbookId =  Test.getStandardPriceBookId(); 
        
        Product2 prod = new Product2();
        prod.Name = 'CA-San_Jose-Pest Control';
        prod.zip_codes__c = '621011';
        insert prod;
        
        PricebookEntry pbookEntry = new PricebookEntry(Product2Id=prod.Id, Pricebook2Id=pbookId, UnitPrice = 59.99, 
                                                       UseStandardPrice=false, IsActive=true);
        insert pbookEntry;
        
        
        OpportunityLineItem lineItem = new OpportunityLineItem();
        lineItem.OpportunityId = opp.id;
        lineItem.pricebookentryId = pbookentry.id;
        lineItem.quantity = 1;
        lineItem.unitprice = 200;
        insert lineItem;
        
        
        
        
        Industry_Values__c industry = new Industry_Values__c();
        industry.name = 'Pest_Control__c';
        industry.Label__c = 'Health Club/CrossFit';
        //industry.Label__c = 'Pest Control';
        insert industry;

        Door_Tag_Script__c newFloor = new Door_Tag_Script__c();
        newFloor.account__C = acclist[0].Id;
        newFloor.Flooring__c = 'Yes';
        newFloor.wood__c = True;
        newFloor.Tile__c = True;
        newFloor.Carpet__c = True;
        newFloor.additional_Industry__c = 'Pest Control,Handman';
        insert newFloor;
        
        
        Door_Tag_Script__c newDoor = new Door_Tag_Script__c();
        newDoor.account__C = acclist[0].Id;
        newDoor.Pest_Control__c = 'Yes';
        newDoor.additional_Industry__c = 'Pest Control,Handman';
        insert newDoor;
        
        
        Door_Tag_Script__c newDoor1 = new Door_Tag_Script__c();
        newDoor1.account__C = acclist[0].Id;
        newDoor1.Pest_Control__c = 'N';
        newDoor1.additional_Industry__c = 'Pest Control,Handman';
        insert newDoor1;
        
        
        Door_Tag_Script__c  door3 = [select id,account__c from Door_Tag_Script__c  where account__c =: acclist[0].id LIMIT 1];
        door3 .Pest_Control__c = 'Yes';
        //newDoor1.additional_Industry__c = 'Pest Control,Handman';
        door3 .additional_Industry__c = 'Cable/Satellite TV/Internet';
        update door3 ;
        
        //Added 25Jan*
        
        
        Door_Tag_Script__c newDoor2 = new Door_Tag_Script__c();
        newDoor2.account__C = acclist[0].Id;
        newDoor2.Flooring__c = 'N';
        newDoor2.additional_Industry__c = 'Pest Control,Handman';
        insert newDoor2;
        
        Door_Tag_Script__c  door4 = [select id,account__c from Door_Tag_Script__c  where account__c =: acclist[0].id LIMIT 1];
        door4 .additional_Industry__c = 'Handyman';
        door4 .Flooring__c = 'Yes';
        update door4 ;
        //*Added 25Jan
        System.assert(opp.id != Null);
        System.assertEquals(opp.accountId,newDoor.Account__c);
        System.assertEquals('Active',Opp.OB_Operation_Stage__c);
        System.assertEquals(opp.RecordTypeId, oppRecTypeId);
        
        
        
    }
    @isTest
    static void TestScenario2(){
        
        Industry_Values__c industry1 = new Industry_Values__c();
        industry1.name = 'Pest_Control__c';
        //industry1.Label__c = 'Pest Control';
        industry1.Label__c = 'Identity Theft';
        insert industry1;
        
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
        INSERT acc;
        
        DoorTagScript();
        
        
        Door_Tag_Script__c newDoor1 = new Door_Tag_Script__c();
        newDoor1.account__C = acc.Id;
        newDoor1.Pest_Control__c = 'Blinds and Shutters';
        newDoor1.additional_Industry__c = 'Pest Control,Handman';
        insert newDoor1;
        
        newDoor1.Pest_Control__c = 'Maybe';
        Test.startTest();
        update newDoor1;
        Test.stopTest();
        
    }
    
    
    @isTest
    static void TestScenario3(){
        
        Account acc = new Account();
        acc.name = 'testAccount';  
        acc.Primary_Billing_City__c='Sunnyvale';    
        acc.Primary_Billing_Country__c='US';
        acc.Primary_Billing_State__c='CA';
        acc.Primary_Billing_Street__c='260 N Mathilda Ave';
        acc.Primary_Billing_Zip_Code__c='94086'; 
        acc.branch__c = 'CA-San_Jose'; 
        acc.Phone = '1234567893';
        acc.verbal_consent__c = 'Yes';
        INSERT acc;
        
        DoorTagScript();
        
        Door_Tag_Script__c newDoor1 = new Door_Tag_Script__c();
        newDoor1.account__C = acc.Id;
        newDoor1.Pest_Control__c = 'Yes';
        newDoor1.additional_Industry__c = 'Pest Control,Handman';
        insert newDoor1;
        
        newDoor1.Pest_Control__c = 'Blinds';
        Test.startTest();
        update newDoor1;
        Test.stopTest();
        
    }
    
      @isTest
    static void TestScenario4(){
        
        Industry_Values__c industry1 = new Industry_Values__c();
        industry1.name = 'Pest_Control__c';
        //industry1.Label__c = 'Pest Control';
        industry1.Label__c = 'Sheds';
        insert industry1;
        
        Account acc = new Account();
        acc.name = 'testAccount';  
        acc.Primary_Billing_City__c='Sunnyvale';    
        acc.Primary_Billing_Country__c='US';
        acc.Primary_Billing_State__c='CA';
        acc.Primary_Billing_Street__c='260 N Mathilda Ave';
        acc.Primary_Billing_Zip_Code__c='94086'; 
        acc.branch__c = 'CA-San_Jose'; 
        acc.Phone = '1234567894';
        acc.verbal_consent__c = 'Yes';
        INSERT acc;
        
        DoorTagScript();
        
        
        Door_Tag_Script__c newDoor1 = new Door_Tag_Script__c();
        newDoor1.account__C = acc.Id;
        newDoor1.Pest_Control__c = 'Blinds and Shutters';
        newDoor1.additional_Industry__c = 'Pest Control,Handman';
        insert newDoor1;
        
        newDoor1.Pest_Control__c = 'Blinds';
        Test.startTest();
        update newDoor1;
        Test.stopTest();
        
    }
    
          @isTest
    static void TestScenario5(){
        
        Industry_Values__c industry1 = new Industry_Values__c();
        industry1.name = 'Pest_Control__c';
        //industry1.Label__c = 'Pest Control';
        industry1.Label__c = 'Energy Audit/Radiant Barrier/Insulation';
        insert industry1;
        
        Account acc = new Account();
        acc.name = 'testAccount';  
        acc.Primary_Billing_City__c='Sunnyvale';    
        acc.Primary_Billing_Country__c='US';
        acc.Primary_Billing_State__c='CA';
        acc.Primary_Billing_Street__c='260 N Mathilda Ave';
        acc.Primary_Billing_Zip_Code__c='94086'; 
        acc.branch__c = 'CA-San_Jose'; 
        acc.Phone = '1234567895';
        acc.verbal_consent__c = 'Yes';
        INSERT acc;
        
        DoorTagScript();
        
        
        Door_Tag_Script__c newDoor1 = new Door_Tag_Script__c();
        newDoor1.account__C = acc.Id;
        newDoor1.Pest_Control__c = 'Blinds and Shutters';
        newDoor1.additional_Industry__c = 'Pest Control,Handman';
        insert newDoor1;
        
        newDoor1.Pest_Control__c = 'Shutters';
        Test.startTest();
        update newDoor1;
        Test.stopTest();
        
    }
    
         @isTest
    static void TestScenario6(){
        
        Industry_Values__c industry1 = new Industry_Values__c();
        industry1.name = 'Pest_Control__c';
        //industry1.Label__c = 'Pest Control';
        industry1.Label__c = 'Solar Power';
        insert industry1;
        
        Account acc = new Account();
        acc.name = 'testAccount';  
        acc.Primary_Billing_City__c='Sunnyvale';    
        acc.Primary_Billing_Country__c='US';
        acc.Primary_Billing_State__c='CA';
        acc.Primary_Billing_Street__c='260 N Mathilda Ave';
        acc.Primary_Billing_Zip_Code__c='94086'; 
        acc.branch__c = 'CA-San_Jose'; 
        acc.Phone = '1234567892';
        INSERT acc;
        
        DoorTagScript();
        
        
        Door_Tag_Script__c newDoor1 = new Door_Tag_Script__c();
        newDoor1.account__C = acc.Id;
        newDoor1.Pest_Control__c = 'Yes';
        newDoor1.additional_Industry__c = 'Pest Control,Handman';
        insert newDoor1;
        
        newDoor1.Pest_Control__c = 'Blinds and Shutt';
        Test.startTest();
        update newDoor1;
        Test.stopTest();
        
    }
    
         @isTest
    static void TestScenario7(){
        
        Industry_Values__c industry1 = new Industry_Values__c();
        industry1.name = 'Flooring__c';
        //industry1.Label__c = 'Flooring/Carpeting';
        industry1.Label__c = 'Cable/Satellite TV/Internet';
        insert industry1;
        
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
        INSERT acc;
        
        DoorTagScript();
        
        
        Door_Tag_Script__c newDoor1 = new Door_Tag_Script__c();
        newDoor1.account__C = acc.Id;
        newDoor1.Flooring__c = 'Yes';
        newDoor1.additional_Industry__c = 'Pest Control,Handman';
        insert newDoor1;
        
        newDoor1.Flooring__c = 'Maybe';
        newDoor1.Wood__c = True;
        Test.startTest();
        update newDoor1;
        Test.stopTest();
        
    }
    
       @isTest
    static void TestScenario8(){
        
        Industry_Values__c industry1 = new Industry_Values__c();
        industry1.name = 'Flooring__c';
       // industry1.Label__c = 'Flooring/Carpeting';
        industry1.Label__c = 'Handyman';
        insert industry1;
        
        Account acc = new Account();
        acc.name = 'testAccount';  
        acc.Primary_Billing_City__c='Sunnyvale';    
        acc.Primary_Billing_Country__c='US';
        acc.Primary_Billing_State__c='CA';
        acc.Primary_Billing_Street__c='260 N Mathilda Ave';
        acc.Primary_Billing_Zip_Code__c='94086'; 
        acc.branch__c = 'CA-San_Jose'; 
        acc.Phone = '1234567894';
        acc.verbal_consent__c = 'Yes';
        INSERT acc;
        
        DoorTagScript();
        
        
        Door_Tag_Script__c newDoor1 = new Door_Tag_Script__c();
        newDoor1.account__C = acc.Id;
        newDoor1.Flooring__c = 'Yes';
        newDoor1.additional_Industry__c = 'Pest Control,Handman';
        insert newDoor1;
        
        newDoor1.Flooring__c = 'Maybe';
        newDoor1.Carpet__c = True;
 
        Test.startTest();
        update newDoor1;
        Test.stopTest();
        
    }
        @isTest
    static void TestScenario9(){
        
        Industry_Values__c industry1 = new Industry_Values__c();
        industry1.name = 'Flooring__c';
        //industry1.Label__c = 'Flooring/Carpeting';
        industry1.Label__c = 'Security Systems';
        insert industry1;
        
        Account acc = new Account();
        acc.name = 'testAccount';  
        acc.Primary_Billing_City__c='Sunnyvale';    
        acc.Primary_Billing_Country__c='US';
        acc.Primary_Billing_State__c='CA';
        acc.Primary_Billing_Street__c='260 N Mathilda Ave';
        acc.Primary_Billing_Zip_Code__c='94086'; 
        acc.branch__c = 'CA-San_Jose'; 
        acc.Phone = '1234567895';
        INSERT acc;
        
        DoorTagScript();
        
        
        Door_Tag_Script__c newDoor1 = new Door_Tag_Script__c();
        newDoor1.account__C = acc.Id;
        newDoor1.Flooring__c = 'Yes';
        newDoor1.additional_Industry__c = 'Pest Control,Handman';
        insert newDoor1;
        
        newDoor1.Flooring__c = 'Maybe';
        newDoor1.Tile__c = True;
        Test.startTest();
        update newDoor1;
        Test.stopTest();
        
    }
    
     @isTest
    static void TestScenario10(){
        
        Industry_Values__c industry1 = new Industry_Values__c();
        industry1.name = 'Flooring__c';
        //industry1.Label__c = 'Flooring/Carpeting';
        industry1.Label__c = 'Home Automation';
        insert industry1;
        
        Account acc = new Account();
        acc.name = 'testAccount';  
        acc.Primary_Billing_City__c='Sunnyvale';    
        acc.Primary_Billing_Country__c='US';
        acc.Primary_Billing_State__c='CA';
        acc.Primary_Billing_Street__c='260 N Mathilda Ave';
        acc.Primary_Billing_Zip_Code__c='94086'; 
        acc.branch__c = 'CA-San_Jose'; 
        acc.Phone = '1234567839';
        acc.verbal_consent__c = 'Yes';
        INSERT acc;
        
        DoorTagScript();
        
        
        Door_Tag_Script__c newDoor1 = new Door_Tag_Script__c();
        newDoor1.account__C = acc.Id;
        newDoor1.Flooring__c = 'Yes';
        newDoor1.additional_Industry__c = 'Pest Control,Handman';
        insert newDoor1;
        
        newDoor1.Flooring__c = 'Maybe';
        newDoor1.Tile__c = True;
       newDoor1.Wood__c = TRUE;
        Test.startTest();
        update newDoor1;
        Test.stopTest();
        
    }
    
      @isTest
    static void TestScenario11(){
        
        Industry_Values__c industry1 = new Industry_Values__c();
        industry1.name = 'Flooring__c';
        //industry1.Label__c = 'Flooring/Carpeting';
        industry1.Label__c = 'Locksmiths';
        insert industry1;
        
       
        
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
        
        INSERT acc;
        
        DoorTagScript();
        
        
        Door_Tag_Script__c newDoor1 = new Door_Tag_Script__c();
        newDoor1.account__C = acc.Id;
        newDoor1.Flooring__c = 'Yes';
        newDoor1.additional_Industry__c = 'Pest Control,Handman';
        insert newDoor1;
        
        newDoor1.Flooring__c = 'Maybe';
        newDoor1.Carpet__c = True;
        newDoor1.Wood__c = TRUE;
        Test.startTest();
        update newDoor1;
        Test.stopTest();
        
    }
    
       @isTest
    static void TestScenario12(){
        
        Industry_Values__c industry1 = new Industry_Values__c();
        industry1.name = 'Flooring__c';
        //industry1.Label__c = 'Flooring/Carpeting';
        industry1.Label__c = 'Garage Floor Coating';
        insert industry1;      
        
        Account acc = new Account();
        acc.name = 'testAccount';  
        acc.Primary_Billing_City__c='Sunnyvale';    
        acc.Primary_Billing_Country__c='US';
        acc.Primary_Billing_State__c='CA';
        acc.Primary_Billing_Street__c='260 N Mathilda Ave';
        acc.Primary_Billing_Zip_Code__c='94086';
        acc.Phone = '1234567894' ;
        acc.branch__c = 'CA-San_Jose'; 
        acc.verbal_consent__c = 'Yes';
        INSERT acc;
        
        DoorTagScript();
        
        
        Door_Tag_Script__c newDoor1 = new Door_Tag_Script__c();
        newDoor1.account__C = acc.Id;
        newDoor1.Flooring__c = 'Yes';
        newDoor1.additional_Industry__c = 'Pest Control,Handman';
        insert newDoor1;
        
        newDoor1.Create_Task_Update__c = 'Email Sent';
        update newDoor1;
        
        newDoor1.Flooring__c = 'Maybe';
        newDoor1.Carpet__c = True;
        newDoor1.Tile__c = TRUE;
        
        ID businessRecTypID = SObjectType.Account.getRecordTypeInfosByName().get('Business Accounts').getRecordTypeId();
         // Business Account Creation.
        Account businessTestAccount = new Account();
        businessTestAccount.FirstName = 'TestBusiness';
        businessTestAccount.LastName = 'TestBusiness';
        businessTestAccount.Phone = '1234567891';
        businessTestAccount.Recordtypeid = businessRecTypID ;
          insert businessTestAccount;
          
        //Opportunity Creation.
          
          Opportunity testOpp = new Opportunity();
          testOpp.AccountId = businessTestAccount.Id ;
          testOpp.Name = 'testOpportunity';
          testOpp.Type = 'New Business';
          testOpp.StageName = 'Qualified';
          testOpp.CloseDate = system.today()+7;
          insert testOpp;
        
           ID dtsRecTypID = SObjectType.Inventory__c.getRecordTypeInfosByName().get('nuHome Door Tag Script').getRecordTypeId(); 
        
           Inventory__c testDTSInventory = new Inventory__c();
           testDTSInventory.RecordTypeId = dtsRecTypID;
           testDTSInventory.ANI__c = '1234567890';
           testDTSInventory.Survey_Question__c = 'Awnings outside for shade?' ;
           testDTSInventory.Survey_Response__c = 'Y';
           testDTSInventory.UnMatching_Invetnory__c = False;
           testDTSInventory.Account__c = acc.Id;
           testDTSInventory.idCPL_Billing_Opportunity__c = testOpp.Id;
           testDTSInventory.Product_Price__c = acc.Sales_Price__c;
           testDTSInventory.lead_emailed__c = false;
           testDTSInventory.billing_stage__c = 'Billable';
           testDTSInventory.industry__c = 'Cable/Satellite TV/Internet';
           testDTSInventory.Boberdoo_Project_Values__c = 'Cable/Satellite TV/Internet';
           // testDTSInventory.additional_Industry__c = 'Pest Control,Handman';
           insert testDTSInventory;
           
           testDTSInventory.lead_emailed__c = True;
           update testDTSInventory;
        
        
        
        
        Test.startTest();
            update newDoor1;
        Test.stopTest();
        
    }
    
     @isTest
    static void TestScenario13(){
        
        Industry_Values__c industry1 = new Industry_Values__c();
        industry1.name = 'Flooring__c';
        //industry1.Label__c = 'Flooring/Carpeting';
        industry1.Label__c = 'Vehicle Purchase';
        insert industry1;
        
        Account acc = new Account();
        acc.name = 'testAccount';  
        acc.Primary_Billing_City__c='Sunnyvale';    
        acc.Primary_Billing_Country__c='US';
        acc.Primary_Billing_State__c='CA';
        acc.Primary_Billing_Street__c='260 N Mathilda Ave';
        acc.Primary_Billing_Zip_Code__c='94086'; 
        acc.branch__c = 'CA-San_Jose'; 
        acc.Phone = '1234567839';
        acc.verbal_consent__c = 'Yes';
        INSERT acc;
        
        DoorTagScript();
        
        
        Door_Tag_Script__c newDoor1 = new Door_Tag_Script__c();
        newDoor1.account__C = acc.Id;
        newDoor1.Flooring__c = 'Yes';
        newDoor1.additional_Industry__c = 'Pest Control,Handman';
        insert newDoor1;
        
        newDoor1.Flooring__c = 'Maybe';
        newDoor1.Tile__c = True;
       newDoor1.Wood__c = TRUE;
        Test.startTest();
        update newDoor1;
        Test.stopTest();
        
    }
    
     @isTest
    static void TestScenario14(){
        
        Industry_Values__c industry1 = new Industry_Values__c();
        industry1.name = 'Flooring__c';
        //industry1.Label__c = 'Flooring/Carpeting';
        industry1.Label__c = 'Home Warranty';
        insert industry1;
               
        Account acc = new Account();
        acc.name = 'testAccount';  
        acc.Primary_Billing_City__c='Sunnyvale';    
        acc.Primary_Billing_Country__c='US';
        acc.Primary_Billing_State__c='CA';
        acc.Primary_Billing_Street__c='260 N Mathilda Ave';
        acc.Primary_Billing_Zip_Code__c='94086'; 
        acc.branch__c = 'CA-San_Jose'; 
        acc.Phone = '1234567839';
        acc.verbal_consent__c = 'Yes';
        INSERT acc;
        
        DoorTagScript();
        
        
        Door_Tag_Script__c newDoor1 = new Door_Tag_Script__c();
        newDoor1.account__C = acc.Id;
        newDoor1.Flooring__c = 'Yes';
        newDoor1.additional_Industry__c = 'Pest Control,Handman';
        insert newDoor1;
        
        newDoor1.Flooring__c = 'Maybe';
        newDoor1.Tile__c = True;
       newDoor1.Wood__c = TRUE;
        Test.startTest();
        update newDoor1;
        Test.stopTest();
        
    }
    
     @isTest
    static void TestScenario15(){
        
        Industry_Values__c industry1 = new Industry_Values__c();
        industry1.name = 'Flooring__c';
        
        industry1.Label__c = 'Mortgage Protection';
        insert industry1;
               
        Account acc = new Account();
        acc.name = 'testAccount';  
        acc.Primary_Billing_City__c='Sunnyvale';    
        acc.Primary_Billing_Country__c='US';
        acc.Primary_Billing_State__c='CA';
        acc.Primary_Billing_Street__c='260 N Mathilda Ave';
        acc.Primary_Billing_Zip_Code__c='94086'; 
        acc.branch__c = 'CA-San_Jose'; 
        acc.Phone = '1234567839';
        acc.verbal_consent__c = 'Yes';
        INSERT acc;
        
        DoorTagScript();
        
        
        Door_Tag_Script__c newDoor1 = new Door_Tag_Script__c();
        newDoor1.account__C = acc.Id;
        newDoor1.Flooring__c = 'Yes';
        newDoor1.additional_Industry__c = 'Pest Control,Handman';
        insert newDoor1;
        
        newDoor1.Flooring__c = 'Maybe';
        newDoor1.Tile__c = True;
       newDoor1.Wood__c = TRUE;
        Test.startTest();
        update newDoor1;
        Test.stopTest();
        
    }
   
     @isTest
     static void TestScenario16(){
        
        Industry_Values__c industry1 = new Industry_Values__c();
        industry1.name = 'Flooring__c';
        industry1.Label__c = 'Flooring/Carpetin';
        industry1.Response__c = 'YES';
        insert industry1;
               
        Account acc = new Account();
        acc.name = 'testAccount';  
        acc.Primary_Billing_City__c='Sunnyvale';    
        acc.Primary_Billing_Country__c='US';
        acc.Primary_Billing_State__c='CA';
        acc.Primary_Billing_Street__c='260 N Mathilda Ave';
        acc.Primary_Billing_Zip_Code__c='94086'; 
        acc.branch__c = 'CA-San_Jose'; 
        acc.Phone = '1234567839';
        acc.verbal_consent__c = 'Yes';
        INSERT acc;
        
       
        
        Door_Tag_Script__c newDoor1 = new Door_Tag_Script__c();
        newDoor1.account__C = acc.Id;
        newDoor1.Flooring__c = 'Yes';
        newDoor1.consent__c = 'Yes';
        newDoor1.additional_Industry__c = 'Pest Control,Handman';
        newDoor1.Account__c = acc.id;
        newDoor1.Wood__c = True;
        newDoor1.Carpet__c =True;
        newDoor1.Tile__c = True;
        newDoor1.Account_Phone__c = '9600467559';
        insert newDoor1;
        
       
    }
    
    @isTest
     static void TestScenario17(){
        
        Industry_Values__c industry1 = new Industry_Values__c();
        industry1.name = 'Flooring__c';
        industry1.Label__c = 'Flooring/Carpetin';
        industry1.Response__c = 'YES';
        insert industry1;
        
        
        Account acc = new Account();
        acc.name = 'testAccount';  
        acc.Primary_Billing_City__c='Sunnyvale';    
        acc.Primary_Billing_Country__c='US';
        acc.Primary_Billing_State__c='CA';
        acc.Primary_Billing_Street__c='260 N Mathilda Ave';
        acc.Primary_Billing_Zip_Code__c='94086'; 
        acc.branch__c = 'CA-San_Jose'; 
        acc.Phone = '1234567839';
        acc.verbal_consent__c = 'Yes';
        INSERT acc;
        
       Id stdPbId = Test.getStandardPricebookid();
        // Pricebook Creation
      
        // Opportunity Creation.
        String oppRecTypeId = Schema.Sobjecttype.Opportunity.getRecordTypeInfosByName().get('nuHome Door Tag Script').getRecordTypeId();
        opportunity opp = new opportunity();
        opp.accountId = acc.Id;
        opp.name='TestOpp';
        opp.closeDate = date.today();
        opp.Operational_Stages__c = 'Gift Card Active Customer';
        opp.Forward_to_number__c = '8220708920';
        opp.stageName = 'Needs Analysis';
        opp.Art_File__c='sunnyvale'; 
        opp.Back_pdf__c=2;
        opp.Front_pdf__c=2;
        opp.pricebook2Id = stdPbId;
        opp.recordTypeId = oppRecTypeId;
        opp.OB_Operation_Stage__c = 'Active';
        opp.CPL_Operation_Stages__c = 'Active';
        insert opp;   
        
        
        Product2 newProd = new Product2();
        newProd.Name = 'null-Flooring/Carpetin';
        newProd.Product_Industry__c = 'Test industry';
        newProd.Available_ZipCodes__c = '35004';
        insert newProd;
        
        PricebookEntry stdPbEntry = new PricebookEntry();
        stdPbEntry.Product2Id = newProd.id;
        stdPbEntry.Pricebook2Id = stdPbId;
        stdPbEntry.unitprice = 100;
        stdPbEntry.isActive = True;
        Insert stdPbEntry;
        

        OpportunityLineItem opplineItem = new OpportunityLineItem();
        opplineItem.pricebookEntryId = stdPbEntry .id;
        opplineItem.Quantity = 1;
        opplineItem.unitprice = 100;
        opplineItem.opportunityId = opp.id;
        insert opplineItem;
         
          Address__c add = new Address__c();
         add.Name = 'Test';
         add.Zip_Code__c = '35004';
         Insert add;
         
         User_Address__c userAdd = new User_Address__c();
         userAdd.UserAccount__c = acc.id;
         userAdd.Address__c = add.Id;
         Insert userAdd;
        
        Door_Tag_Script__c newDoor1 = new Door_Tag_Script__c();
        newDoor1.account__C = acc.Id;
         newDoor1.User_Address__c = userAdd.id;
        newDoor1.Flooring__c = 'Yes';
        newDoor1.consent__c = 'Yes';
        newDoor1.additional_Industry__c = 'Pest Control,Handman';
        newDoor1.Account__c = acc.id;
        newDoor1.Wood__c = True;
        newDoor1.Carpet__c =True;
        newDoor1.Tile__c = True;
        newDoor1.Account_Phone__c = '9600467559';
        insert newDoor1;
        
        Door_Tag_Script__c  doorIns = [SELECT id,account__C,Flooring__c,Account_Phone__c ,consent__c ,additional_Industry__c ,Wood__c, Carpet__c,Tile__c  FROM Door_Tag_Script__c where id =: newDoor1.id Limit 1 ];
        doorIns.Flooring__c =  'Maybe';
        update doorIns; 
    }
    
     @isTest
    static void TestScenario18(){
        Id dtsRecTypeId = Schema.SObjectType.Inventory__c.getRecordTypeInfosByName().get('nuHome Door Tag Script').getRecordTypeId();
        
          Account newAcc = new Account();
        newAcc.LastName = 'Test Account';
        newAcc.Verbal_Consent__c = 'Yes';
        newAcc.Previous_Street__c = 'Test Street';
        newAcc.Previous_City__c ='Test City';
        newAcc.Previous_Country__c = 'Test Country';
        newAcc.Previous_State__c ='Test State';
        newAcc.Previous_Zip__c = '123455'; 
        newAcc.Phone = '1234567891';
        newAcc.PersonMobilePhone = '1234567890';
        newAcc.Primary_Shipping_Zip_Code__c = '35004';
        newAcc.Primary_Billing_City__c='Sunnyvale';    
        newAcc.Primary_Billing_Country__c='US';
        newAcc.Primary_Billing_State__c='CA';
        newAcc.Primary_Billing_Street__c='260 N Mathilda Ave';
        newAcc.Primary_Billing_Zip_Code__c='35004'; 
        newAcc.branch__c = 'AL-Birmingham';  
        insert newAcc;
        
        Boberdoo_Project_Value__c currBober = new Boberdoo_Project_Value__c();
        currBober.Name = 'Awnings - Back';
        currBober.Boberdoo_Project_Value__c = 'Awnings - Back';
        currBober.Picklist_Values__c = 'Awnings - Back';
        currBober.Industry__c = 'blank';
        insert currBober;
        
        
        Inventory__c curInv = new Inventory__c();
        curInv.Account__c = newAcc.id;
        curInv.RecordTypeId = dtsRecTypeId;
        curInv.appointment_outcome__c = 'Network Lead';
        insert curInv;
        
        update curInv;
    }
    
}