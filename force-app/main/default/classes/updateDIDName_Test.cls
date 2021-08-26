@isTest
public class updateDIDName_Test{
    
    public static Account createAccount()
    {
        Account testAccount = new Account();
        testAccount.Name = 'Test Account';
        testAccount.Type = 'Customer';
        testAccount.Branch__c = 'AZ-Tucson';
        testAccount.Industry = 'Awnings';
        testAccount.phone = '9090909090';
        
        return testAccount;
    }
    
    public static Opportunity createOpportunity()
    {
        Account testAccount = createAccount();
        insert testAccount;
        
        opportunity testOpportunity = new opportunity();
        testOpportunity.Name = 'Test Opportunity';
        testOpportunity.AccountId = testAccount.Id;
        testOpportunity.Type = 'Trade';
        testOpportunity.StageName = 'Leagal Review';
        testOpportunity.CloseDate = system.today().addDays(10);
        testOpportunity.NuCard_Industry__c = 'Awnings';
        testOpportunity.Branch__c = 'AZ-Tucson';
        
        return testOpportunity;
    }
    
   public static DID__c createDID()
    {
        opportunity testOpp = createOpportunity();
        insert testOpp;
        
        DID__c testDID = new DID__c();
        testDID.POC__c = '9898989898';
        testDID.Destination_Number__c = '9090898978';
        testDID.Opportunity__c = testOpp.Id;
        testDID.DID_Type__c = 'Gift Card';
        
        return testDID;
    }
    
    public static testMethod void insertInventoryWithDID(){
        DID__c testDID = createDID();
        insert testDID;
        
        Inventory__c testInventory = new Inventory__c();
        testInventory.DID__c = '9898989898';
        insert testInventory;
    }
    
     public static testMethod void insertInventoryWithoutDID(){
        DID__c testDID = createDID();
        insert testDID;
        
        Inventory__c testInventory = new Inventory__c();
        testInventory.DID__c = '';
        insert testInventory;
    }
    
     public static testMethod void coverCheckInventoryforNewRecord(){
        
        Inventory__c testInventory = new Inventory__c();
        testInventory.DID__c = '(111) 111-1111';
        insert testInventory;
         System.debug('##testInventory'+testInventory);
        
        DID__c testDID = createDID();
         insert testDID;
        
        testDID.POC__c ='1111111111';
        update testDID;
    }

 /*   public static testMethod void coverCheckInventoryforExistingRecord(){
        
        DID__c testDID = createDID();
        insert testDID;
        
        Inventory__c testInventory = new Inventory__c();
        testInventory.DID__c = '(989) 898-9898'; 
        insert testInventory;
        
        testDID.POC__c ='1111111111';
        update testDID;
    }*/

}