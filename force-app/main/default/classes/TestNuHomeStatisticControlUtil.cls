@isTest
public class TestNuHomeStatisticControlUtil {
    
    public static id createAccount()
    {    
        Account newAcc = new Account();
        newAcc.LastName = 'Test Account';
        newAcc.Verbal_Consent__c = 'Yes';
        newAcc.Previous_Street__c = 'Test Street';
        newAcc.Previous_City__c ='Test City';
        newAcc.Previous_Country__c = 'Test Country';
        newAcc.Previous_State__c ='Test State';
        newAcc.Previous_Zip__c = '123455'; 
        newAcc.Phone = '1234567891';
        newAcc.phone = '8220708920';
        newAcc.Primary_Shipping_Zip_Code__c = '35004';
        newAcc.Primary_Billing_City__c='Sunnyvale';    
        newAcc.Primary_Billing_Country__c='US';
        newAcc.Primary_Billing_State__c='CA';
        newAcc.Primary_Billing_Street__c='260 N Mathilda Ave';
        newAcc.Primary_Billing_Zip_Code__c='35004'; 
        newAcc.branch__c = 'AL-Birmingham';  
       
        insert newAcc;
        
        return newAcc.id;        
    }
    
    public static Opportunity opp = new Opportunity();
    public static Pricebook2 pbook = new Pricebook2();
    public static Industry_values__c customSetting = new Industry_values__c();
    public static ZipCodeMatch__c zipCodeMatch = new ZipCodeMatch__c();
    
     static void createtestrecords()
    {
        
        
        zipCodeMatch.Name = '35004';
        zipCodeMatch.Carrier_Code__c='AL-Birmingham';
        zipCodeMatch.MSA__c='Test';
        zipCodeMatch.Zip_Code__c = '35004';
        insert zipCodeMatch;
        
        Id accId = createAccount();
        
       
        customSetting.Name = 'Pest_Control__c';
        customSetting.question__c = 'Pest Control?';
        customSetting.label__c = 'Pest Control';
        insert customSetting;
        
        Id stdPbId = Test.getStandardPricebookid();
        // Pricebook Creation
       
        pbook.Name = 'nuHome Door Tag Script';
        insert pbook; 
        
        // Opportunity Creation.
        String oppRecTypeId = Schema.Sobjecttype.Opportunity.getRecordTypeInfosByName().get('nuHome Door Tag Script').getRecordTypeId();
       
        opp.accountId = accId;
        opp.name='TestOpp';
        opp.closeDate = date.today();
        opp.Operational_Stages__c = 'Gift Card Active Customer';
        opp.Forward_to_number__c = '8220708920';
        opp.stageName = 'Needs Analysis';
        opp.Art_File__c='sunnyvale'; 
        opp.Back_pdf__c=2;
        opp.Front_pdf__c=2;
        opp.pricebook2Id = pbook.id;
        // opp.recordTypeId = oppRecTypeId;
        opp.OB_Operation_Stage__c = 'Active';
        insert opp;   
        
        opp.recordTypeid = oppRecTypeId;
        opp.StageName = 'Closed Won';
        opp.CPL_Operation_Stages__c = 'Active';
        update opp;
        
    }
    
    
     public static Door_Tag_Script__c insertDoorTag()
    {
         //Account acc = [SELECT id from Account Limit 1];
         
          Account newAcc = new Account();
        newAcc.LastName = 'Test Account';
        newAcc.Verbal_Consent__c = 'Yes';
        newAcc.Previous_Street__c = 'Test Street';
        newAcc.Previous_City__c ='Test City';
        newAcc.Previous_Country__c = 'Test Country';
        newAcc.Previous_State__c ='Test State';
        newAcc.Previous_Zip__c = '123455'; 
        //newAcc.Phone = '1234567891';
        //newAcc.phone = '8220708920';
        newAcc.Primary_Shipping_Zip_Code__c = '35004';
        newAcc.Primary_Billing_City__c='Sunnyvale';    
        newAcc.Primary_Billing_Country__c='US';
        newAcc.Primary_Billing_State__c='CA';
        newAcc.Primary_Billing_Street__c='260 N Mathilda Ave';
        newAcc.Primary_Billing_Zip_Code__c='35004'; 
        newAcc.branch__c = 'AL-Birmingham';  
       
        insert newAcc;
        
        Region__c regionIns = New Region__c( Name = 'Central' );
        Insert regionIns;
        
        Branch__c branch = new Branch__c();
        branch.Name = 'AL-Birmingham';
        branch.State__c = 'AL';
        branch.MSA__c = 'Birmingham-Hoover, AL MSA';
        branch.Carrier_ID__c = 'Please Update';
        branch.Region_MD__c = regionIns.Id;
        Insert branch;
        
        Address__c address = new Address__c();
        address.Name = '4330 W Chandler Blvd:Chandler:AZ';
        address.Zip_Code__c = '35004';
        address.Branch__c = branch.Id;
        Insert address;
        
        User_Address__c userAddress = new User_Address__c();
        userAddress.UserAccount__c = newAcc.Id;
        userAddress.Address__c = address.Id;
        userAddress.Active__c = True;
        userAddress.User_Address_Type__c = 'Primary Owner';
        userAddress.Respond_Date__c = Date.today();
        userAddress.PersonMobilePhone__c = '9600467559';
        userAddress.phone__c = '9007766123';
        
        Insert userAddress;
        
        
      //  Id accId = createAccount();
        Door_Tag_Script__c doorTagScript = new Door_Tag_Script__c ();
        doorTagScript.Consent__c = 'Yes';
        doorTagScript.Account__c = createAccount();
        doorTagScript.Box_Confirmation_Email__c = 'Test@test.com';
        doorTagScript.Box_Confirmation__c = 'Y';
        doorTagScript.Box_Confirmation_Email2__c = 'test@test.com';
        doorTagScript.First_Home__c = 'Yes';
        doorTagScript.Completed_Fields__c = 5;
        doorTagScript.Total_Fields__c = 5;
        doorTagScript.Flooring__c = 'Yes';
        doorTagScript.Starting_Agent__c = null;
        doorTagScript.Cats_Dogs__c = 'Yes';
        doorTagScript.Pool__c = 'Yes';
        doorTagScript.Awning__c = 'Yes';
        doorTagScript.Bathroom_Remodeling__c = 'Yes';
        doorTagScript.Blinds_Shutters__c = 'Yes';
        doorTagScript.Carpet_Cleaning__c = 'Yes';
        doorTagScript.Chiropractor__c = 'Yes';
        doorTagScript.Closet_Organizing__c = 'Yes';
        doorTagScript.Deck_Patio_Awnings__c = 'Yes';
        doorTagScript.Dentist__c = 'Yes';
        doorTagScript.Do_you_have_a_Water_Softener__c = 'Yes';
        doorTagScript.Electrical__c = 'Yes';
        doorTagScript.Energy_Audit__c = 'Yes';
        doorTagScript.Fencing__c = 'Yes';
        doorTagScript.Granite_Marble__c = 'Yes';
        doorTagScript.Home_Automation__c = 'Yes';
        doorTagScript.pest_control__c = 'Yes';
        doorTagScript.Consent__c  = 'Phone Only';
        doorTagScript.Previous_Street__c = 'AZ';
        doorTagScript.Previous_City__c  = 'Yes';
        doorTagScript.Previous_Country__c = 'Yes';
        doorTagScript.Previous_State__c = 'Yes';
        doorTagScript.Previous_Zip__c = 'Yes';
        doorTagScript.Additional_Industry__c = 'Pest Control,Handman';
        doorTagScript.User_Address__c = userAddress.Id;
        insert doorTagScript;
        return doorTagScript;
        
    }
    
    public static Door_Tag_Script__c insertDoorTagv2()
    {
         //Account acc = [SELECT id from Account Limit 1];
         
          Account newAcc = new Account();
        newAcc.LastName = 'Test Account';
        newAcc.Verbal_Consent__c = 'Yes';
        newAcc.Previous_Street__c = 'Test Street';
        newAcc.Previous_City__c ='Test City';
        newAcc.Previous_Country__c = 'Test Country';
        newAcc.Previous_State__c ='Test State';
        newAcc.Previous_Zip__c = '123455'; 
        newAcc.Phone = '1234567891';
        newAcc.phone = '8220708920';
        newAcc.Primary_Shipping_Zip_Code__c = '35004';
        newAcc.Primary_Billing_City__c='Sunnyvale';    
        newAcc.Primary_Billing_Country__c='US';
        newAcc.Primary_Billing_State__c='CA';
        newAcc.Primary_Billing_Street__c='260 N Mathilda Ave';
        newAcc.Primary_Billing_Zip_Code__c='35004'; 
        newAcc.branch__c = 'AL-Birmingham';  
       
        insert newAcc;
        
        Region__c regionIns = New Region__c( Name = 'Central' );
        Insert regionIns;
        
        Branch__c branch = new Branch__c();
        branch.Name = 'AL-Birmingham';
        branch.State__c = 'AL';
        branch.MSA__c = 'Birmingham-Hoover, AL MSA';
        branch.Carrier_ID__c = 'Please Update';
        branch.Region_MD__c = regionIns.Id;
        Insert branch;
        
        Address__c address = new Address__c();
        address.Name = '4330 W Chandler Blvd:Chandler:AZ';
        address.Zip_Code__c = '35004';
        address.Branch__c = branch.Id;
        Insert address;
        
        User_Address__c userAddress = new User_Address__c();
        userAddress.UserAccount__c = newAcc.Id;
        userAddress.Address__c = address.Id;
        userAddress.Active__c = True;
        userAddress.User_Address_Type__c = 'Primary Owner';
        userAddress.Respond_Date__c = Date.today();
        userAddress.PersonMobilePhone__c = '9600467559';
        userAddress.phone__c = '9007766123';
        
        Insert userAddress;
        
        
      //  Id accId = createAccount();
        Door_Tag_Script__c doorTagScript = new Door_Tag_Script__c ();
        doorTagScript.Consent__c = 'Yes';
        doorTagScript.Account__c = createAccount();
        doorTagScript.Box_Confirmation_Email__c = 'Test@test.com';
        doorTagScript.Box_Confirmation__c = 'Y';
        doorTagScript.Box_Confirmation_Email2__c = 'test@test.com';
        doorTagScript.First_Home__c = 'Yes';
        doorTagScript.Completed_Fields__c = 5;
        doorTagScript.Total_Fields__c = 5;
        doorTagScript.Flooring__c = 'Yes';
        doorTagScript.Starting_Agent__c = null;
        doorTagScript.Cats_Dogs__c = 'Yes';
        doorTagScript.Pool__c = 'Yes';
        doorTagScript.Awning__c = 'Yes';
        doorTagScript.Bathroom_Remodeling__c = 'Yes';
        doorTagScript.Blinds_Shutters__c = 'Yes';
        doorTagScript.Carpet_Cleaning__c = 'Yes';
        doorTagScript.Chiropractor__c = 'Yes';
        doorTagScript.Closet_Organizing__c = 'Yes';
        doorTagScript.Deck_Patio_Awnings__c = 'Yes';
        doorTagScript.Dentist__c = 'Yes';
        doorTagScript.Do_you_have_a_Water_Softener__c = 'Yes';
        doorTagScript.Electrical__c = 'Yes';
        doorTagScript.Energy_Audit__c = 'Yes';
        doorTagScript.Fencing__c = 'Yes';
        doorTagScript.Granite_Marble__c = 'Yes';
        doorTagScript.Home_Automation__c = 'Yes';
        doorTagScript.pest_control__c = 'Yes';
        doorTagScript.Consent__c  = 'Phone Only';
        doorTagScript.Previous_Street__c = 'AZ';
        doorTagScript.Previous_City__c  = 'Yes';
        doorTagScript.Previous_Country__c = 'Yes';
        doorTagScript.Previous_State__c = 'Yes';
        doorTagScript.Previous_Zip__c = 'Yes';
        doorTagScript.Additional_Industry__c = 'Pest Control,Handman';
        doorTagScript.User_Address__c = userAddress.Id;
        doorTagScript.Home_Remodeling__c = 'Appointment';
        doorTagScript.Kitchen_Remodeling__c = 'Appointment';
        doorTagScript.Bathroom_Remodeling__c = 'Appointment';
        doorTagScript.Granite_Marble__c = 'Appointment';
        doorTagScript.Windows_Doors__c = 'Appointment';
        doorTagScript.Flooring__c = 'Appointment';
        doorTagScript.Gutters__c = 'Appointment';
        doorTagScript.Roofer__c = 'Appointment';
        doorTagScript.Siding__c = 'Appointment';
        doorTagScript.PaintingInside__c = true;
        insert doorTagScript;
        return doorTagScript;
        
    }
    
    public static Door_Tag_Script__c insertDoorTagComplaince()
    {
        
        Id dtsRecTypeId = Schema.SObjectType.Door_Tag_Script__c.getRecordTypeInfosByName().get('nuHome Door Tag Compliance').getRecordTypeId();
         //Account acc = [SELECT id from Account Limit 1];
         
          Account newAcc = new Account();
        newAcc.LastName = 'Test Account';
        newAcc.Verbal_Consent__c = 'Yes';
        newAcc.Previous_Street__c = 'Test Street';
        newAcc.Previous_City__c ='Test City';
        newAcc.Previous_Country__c = 'Test Country';
        newAcc.Previous_State__c ='Test State';
        newAcc.Previous_Zip__c = '123455'; 
        newAcc.Phone = '1234567891';
        newAcc.phone = '8220708920';
        newAcc.Primary_Shipping_Zip_Code__c = '35004';
        newAcc.Primary_Billing_City__c='Sunnyvale';    
        newAcc.Primary_Billing_Country__c='US';
        newAcc.Primary_Billing_State__c='CA';
        newAcc.Primary_Billing_Street__c='260 N Mathilda Ave';
        newAcc.Primary_Billing_Zip_Code__c='35004'; 
        newAcc.branch__c = 'AL-Birmingham';  
       
        insert newAcc;
        
        Branch__c branch = new Branch__c();
        branch.Name = 'AL-Birmingham';
        branch.State__c = 'AL';
        branch.MSA__c = 'Birmingham-Hoover, AL MSA';
        branch.Carrier_ID__c = 'Please Update';
        Insert branch;
        
        Address__c address = new Address__c();
        address.Name = '4330 W Chandler Blvd:Chandler:AZ';
        address.Zip_Code__c = '35004';
        address.Branch__c = branch.Id;
        Insert address;
        
        User_Address__c userAddress = new User_Address__c();
        userAddress.UserAccount__c = newAcc.Id;
        userAddress.Address__c = address.Id;
        userAddress.Active__c = True;
        userAddress.User_Address_Type__c = 'Primary Owner';
        userAddress.Respond_Date__c = Date.today();
        userAddress.PersonMobilePhone__c = '9600467559';
        userAddress.phone__c = '9007766123';
        
        Insert userAddress;
        
        
      //  Id accId = createAccount();
        Door_Tag_Script__c doorTagScript = new Door_Tag_Script__c ();
        doorTagScript.Consent__c = 'Yes';
        doorTagScript.Account__c = createAccount();
        doorTagScript.Box_Confirmation_Email__c = 'Test@test.com';
        doorTagScript.Box_Confirmation__c = 'Y';
        doorTagScript.Box_Confirmation_Email2__c = 'test@test.com';
        doorTagScript.First_Home__c = 'Yes';
        doorTagScript.Completed_Fields__c = 5;
        doorTagScript.Total_Fields__c = 5;
        doorTagScript.Flooring__c = 'Yes';
        doorTagScript.Starting_Agent__c = null;
        doorTagScript.Cats_Dogs__c = 'Yes';
        doorTagScript.Pool__c = 'Yes';
        doorTagScript.Awning__c = 'Yes';
        doorTagScript.Bathroom_Remodeling__c = 'Yes';
        doorTagScript.Blinds_Shutters__c = 'Yes';
        doorTagScript.Carpet_Cleaning__c = 'Yes';
        doorTagScript.Chiropractor__c = 'Yes';
        doorTagScript.Closet_Organizing__c = 'Yes';
        doorTagScript.Deck_Patio_Awnings__c = 'Yes';
        doorTagScript.Dentist__c = 'Yes';
        doorTagScript.Do_you_have_a_Water_Softener__c = 'Yes';
        doorTagScript.Electrical__c = 'Yes';
        doorTagScript.Energy_Audit__c = 'Yes';
        doorTagScript.Fencing__c = 'Yes';
        doorTagScript.Granite_Marble__c = 'Yes';
        doorTagScript.Home_Automation__c = 'Yes';
        doorTagScript.pest_control__c = 'Yes';
        doorTagScript.Consent__c  = 'Phone Only';
        doorTagScript.Previous_Street__c = 'AZ';
        doorTagScript.Previous_City__c  = 'Yes';
        doorTagScript.Previous_Country__c = 'Yes';
        doorTagScript.Previous_State__c = 'Yes';
        doorTagScript.Previous_Zip__c = 'Yes';
        doorTagScript.Additional_Industry__c = 'Pest Control,Handman';
        doorTagScript.User_Address__c = userAddress.Id;
        doorTagScript.RecordTypeId = dtsRecTypeId;
        insert doorTagScript;
        return doorTagScript;
        
    }
    
    public Static void lineitemcreation(String industry, String productName)
    {
         createtestrecords();
         Id accId = createAccount();
        Door_Tag_Script__c doorTag = insertDoorTag();
        
         String queryString = 'select id,Starting_Date__c,Cats_Dogs__c,Box_Confirmation__c,Completed_Fields__c,Finishing_Date__c,Account__c';
        for(Schema.FieldSetMember fld :SObjectType.Door_Tag_Script__c.FieldSets.Survey_Fields.getFields()) {
            queryString += ', ' + fld.getFieldPath();
        }
        queryString += ' from Door_Tag_Script__c limit 1';
        
        Door_Tag_Script__c doorTagScript = Database.query(queryString); 
        
        Id stdPbId = Test.getStandardPricebookid();
        
        
     
        Product2 newProd = new Product2();
        newProd.Name = productName;
        newProd.Product_Industry__c = industry;
        newProd.Available_ZipCodes__c = '35004';
        insert newProd;
        
        PricebookEntry stdPbEntry = new PricebookEntry();
        stdPbEntry.Product2Id = newProd.id;
        stdPbEntry.Pricebook2Id = stdPbId;
        stdPbEntry.unitprice = 100;
        stdPbEntry.isActive = True;
        Insert stdPbEntry;
        
        
        PricebookEntry bathPbEntry = new PricebookEntry();
        bathPbEntry.Product2Id = newProd.id;
        bathPbEntry.Pricebook2Id = pbook.id;
        bathPbEntry.unitprice = 100;
        bathPbEntry.isActive = True;
        Insert bathPbEntry;
        
        OpportunityLineItem opplineItem = new OpportunityLineItem();
        opplineItem.pricebookEntryId = bathPbEntry.id;
        opplineItem.Quantity = 1;
        opplineItem.unitprice = 100;
        opplineItem.opportunityId = opp.id;
        insert opplineItem;
        
        DTSQuestion__c DTS = new DTSQuestion__c();
        DTS.Question__c = 'Test';
        DTS.Industry__c ='Bathroom';
        DTS.Order__c =1;
        DTS.Section__c='Inbound';
        insert DTS;
        
        
    }
    
   

}