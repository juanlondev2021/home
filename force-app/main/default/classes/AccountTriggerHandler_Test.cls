/* **************************************************************************************************
* Class Name : AccountTriggerHandler_Test
* Created By : Sankar Marappan
* Created Date : 4/4/2016
* Author : MST
* Description : This class will cover the code coverage for 'AccountMain' and 'AccountTriggerHandler'. 
*********************************************************************************************************/
@isTest(seeAllData = false)
private class AccountTriggerHandler_Test {
    //Create common test data
    @testSetup static void loadData() {
        TestClassUtil.createZipcodeForBranch();//Zipcode__c custom obj data 
        TestClassUtil.createAccount(50);   
    }
    @isTest static void testPositiveScenarios() {
        List<Account> accList = [SELECT id,phone FROM Account];
        //Update account phone from null to not null
        for(Account acc : accList){
            acc.phone = '9987654321';
        }
        update accList;
        //Verify auto population of field values
        for(Account updatedAcc : [SELECT id,Respond_date__c,Branch__c,Region_Code__c,MSA__c FROM Account]){
            System.assert(updatedAcc.Respond_date__c != null);
            System.assert(updatedAcc.Branch__c != null);
           // System.assert(updatedAcc.Region_Code__c != null);
          //  System.assert(updatedAcc.MSA__c != null);
        }
    }
    @isTest static void testNegativeScenarios() {
        //Create Account with phone no
        RecordType rt = [SELECT id,Name FROM RecordType WHERE SobjectType = 'Account' and Name = 'Person Account' LIMIT 1];    
        insert new Account(FirstName = 'Test',LastName = 'Account Record',RecordTypeId = rt.Id,phone = '1234567899',Branch__c = 'AZ-Test Branch');          
        List<Account> accList = [SELECT id,Primary_Shipping_Zip_Code__c FROM Account];
        for(Account acc : accList){
            acc.Primary_Shipping_Zip_Code__c = null;
        }
        //Update invalid zipcode
        accList[0].Primary_Shipping_Zip_Code__c = '123456';
        update accList;
    }
}