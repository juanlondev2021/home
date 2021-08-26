/**************************************************************************************************************
Created By:MST Solutions.
Description : Test Class for nuHome_HotleadInventory_Handler
***************************************************************************************************************/
@isTest(SeeAllData = False)
public class nuHome_HotleadInventory_Handler_test {
    
    
    public static testMethod void createUserAddress(){
        
        Id oppRTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('nuHome Hot Lead').getRecordTypeId();
        
        Region__c regionIns = New Region__c( Name = 'Central' );
        Insert regionIns;
        
        Branch__c branchIns = new Branch__c();
        branchIns.Name = 'AL-Birmingham';
        branchIns.State__c = 'AL';
        branchIns.MSA__c = 'Birmingham-Hoover, AL MSA';
        branchIns.Carrier_ID__c = 'Please Update';
        branchIns.Region_MD__c = regionIns.Id;
        Insert branchIns;
        
        ZipCode__c zpCode 	=	New ZipCode__c();
        zpCode.Branch__c	=	branchIns.Id;
        zpCode.ZipCode__c	=	'35004';
        zpCode.Name			=	'35004';
        Insert zpCode;
        
        Address__c address = new Address__c();
        address.Name = '4330 W Chandler Blvd:Chandler:AZ';
        address.Zip_Code__c = '35004';
        address.Branch__c = branchIns.Id;
        Insert address;
        
        
        Account accInv = New Account();
        accInv.LastName = 'Test Account';
        accInv.Verbal_Consent__c = 'Yes';
        accInv.Previous_Street__c = 'Test Street';
        accInv.Previous_City__c ='Test City';
        accInv.Previous_Country__c = 'Test Country';
        accInv.Previous_State__c ='Test State';
        accInv.Previous_Zip__c = '35004'; 
        accInv.Phone = '1234567891';
        accInv.Primary_Shipping_Zip_Code__c = '35004';
        accInv.Primary_Billing_City__c='Sunnyvale';    
        accInv.Primary_Billing_Country__c='US';
        accInv.Primary_Billing_State__c='CA';
        accInv.Primary_Billing_Street__c='260 N Mathilda Ave';
        accInv.Primary_Billing_Zip_Code__c='35004'; 
        accInv.branch__c = 'AL-Birmingham';
        
        Insert accInv;
        
        Opportunity opp						=	New Opportunity();
        opp.accountId						=	accInv.Id;
        opp.name							=	'TestOpp';
        opp.closeDate						=	date.today();
        opp.Operational_Stage_Hot_Leads__c	=	'Active Tier 1';
        opp.Forward_to_number__c			=	'8220708920';
        opp.stageName						=	'Closed Won';
        opp.recordTypeId					=	oppRTId;
        opp.OB_Operation_Stage__c			=	'Active';
        opp.Branch__c						=	'AL-Birmingham';
        insert opp; 
        
        Pricebook2 pb22 = new Pricebook2(Name='nuHome Hot Lead');
        insert pb22;
        
        Product2 pro2 = new Product2(Name='Test',isActive=true,available_zipcodes__c = '35004');
        insert pro2;
        
        PricebookEntry pbe2 =new PricebookEntry(unitprice=0.01,Product2Id=pro2.Id,Pricebook2Id=Test.getStandardPricebookId(),
                                                isActive=true,UseStandardPrice = false);
        insert pbe2;
        
        OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Quantity=2, OpportunityId=opp.Id,UnitPrice=0.01,PriceBookEntryId=pbe2.Id);
        insert OPplineitem2;

        User_Address__c userAddress = new User_Address__c();
        userAddress.UserAccount__c = accInv.Id;
        userAddress.Address__c = address.Id;
        userAddress.Active__c = True;
        userAddress.User_Address_Type__c = 'Primary Owner';
        userAddress.Hot_Lead_Created__c	= False;
        Insert userAddress;
        
        userAddress.phone__c = '8220708920';
        userAddress.inventory_created__c = false;
        userAddress.Hot_Lead_Created__c	= True;
        test.startTest();
        update userAddress;
        test.stopTest();

    }
 
}