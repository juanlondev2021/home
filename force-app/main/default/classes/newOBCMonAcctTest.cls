//Backup sandbox trigger 2 of 2 for 8_15_16
/*
--------------------------
 * Modified By: Ganesh
 * Modified on:
 * Description: Updated the test class as per best practices. 
-----------------------------
*/
@isTest(seealldata = false)
Private class newOBCMonAcctTest {
    @testsetup static void createtestdata() {
        //Account creation
        Account newAcc = new Account();
        newAcc.verbal_consent__c = 'Yes';
        newAcc.LastName = 'Test';
        newAcc.Primary_Billing_City__c ='Los Angeles';
        newAcc.Primary_Billing_State__c = 'CA';
        newAcc.Primary_Billing_Zip_Code__c ='94006';
        newAcc.Primary_Billing_County__c='US';
        newAcc.Primary_Billing_Street__c ='1 richmond st';
        newAcc.respond_date__c = system.today().adddays(-1);
        try{
            insert newAcc;
        }
        catch(exception e){
            system.assert(false,'Failed to insert the newAcc '+e.getMessage());
        }
        //Region creation 
        Region__c newRegion = new Region__c(name='testregion');
        Insert newRegion;
        Branch__C newBr = new Branch__c();
        newBr.name ='AZ-Phoenix_East';
        newBr.Carrier_ID__c='12345';
        newBr.region_md__c = newRegion.id;
        try{
            insert newBr;
        }
        catch(exception e){
            system.assert(false,'Failed to insert the newBr '+e.getMessage());
        }
        //Address__c creation
        Address__c newA = new Address__c();
        newA.Name = 'Test Address';
        newA.branch__c= newBr.id;
        newA.Unique_Key__c = '123456789';
        try{
            insert newA;
        }
        catch(exception e){
            system.assert(false,'Failed to insert the newA '+e.getMessage());
        }
        User_Address__c newUA = new User_Address__c();
        newUA.Address__c = newA.Id;
        newUA.UserAccount__c = newAcc.Id;
        //newUA.CreatedDate = system.Now();
        try{
            insert newUA;
        }
        catch(exception e){
            system.assert(false,'Failed to insert the newUA '+e.getMessage());
        }
        //Industry__c creation
        Industry__c newIndustry = new Industry__c();
        newIndustry.name ='test1';
        newIndustry.Active__c = true;
        newIndustry.CPL_Active__c = true;
        try{
            insert newIndustry;
        }
        catch(exception e){
            system.assert(false,'Failed to insert the newIndustry '+e.getMessage());
        }
        //Opportunity creation
        Opportunity newOpp = new Opportunity();
        newOpp.Name = 'Test Opp';
        newOpp.AccountId = newAcc.Id;
        newOpp.Type = 'Trade';
        newOpp.stageName = 'Closed Won';
        newOpp.NuCard_Industry__c = 'Attorney';
        newOpp.NuHome_Industry__c = newIndustry.Id;
        newOpp.Branch__c = 'AZ-Phoenix_East';
        newOpp.closeDate = system.Today();    
        newOpp.OB_Campaign_Active__c = true;    
        try{
            insert newOpp;
        }
        catch(exception e){
            system.assert(false,'Failed to insert the newOpp '+e.getMessage());
        }
        //OB_Campaign_Call_Center__c creation
        OB_Campaign_Call_Center__c newCC = new OB_Campaign_Call_Center__c();
        newCC.Name = 'NuHome';
        try{
            insert newCC;
        }
        catch(exception e){
            system.assert(false,'Failed to insert the newCC '+e.getMessage());
        }
        //OB_Campaign__c creation
        OB_Campaign__c newOBC = new OB_Campaign__c();
        newOBC.Opportunity__c = newOpp.Id;
        newOBC.OB_Campaign_Branch__c = 'AZ-Phoenix_East';
        newOBC.OB_Campaign_Call_Center__c = newCC.Id;
        try{
            insert newOBC;
        }
        catch(exception e){
            system.assert(false,'Failed to insert the newOBC '+e.getMessage());
        }
        //OB_Campaign_Member__c creation
        OB_Campaign_Member__c newOBCM = new OB_Campaign_Member__c();
        newOBCM.AccountName__c = newAcc.Id;
        newOBCM.OB_Campaign__c = newOBC.Id;
        newOBCM.User_Address__c = newUA.Id;
        newOBCM.DupCatcher__c = newUA.UserAccount__c;
        newOBCM.UniqueKey__c = newA.Id;
        try{
            insert newOBCM;
        }
        catch(exception e){
            system.assert(false,'Failed to insert the newOBCM '+e.getMessage());
        }
    } 
    static testmethod void newOBCMonAcct(){
        // Now update the account record to invoke the trigger
        Account temp = [select id,respond_date__c from account where LastName='Test' limit 1];
        temp.respond_date__c = system.today();
        update temp;
    }
}