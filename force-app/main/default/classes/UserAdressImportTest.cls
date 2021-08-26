@isTest
public class UserAdressImportTest {
    
    @testSetup static void loadTestData() {
        Account newAcc = new Account(FirstName = 'Test',
                                     LastName = 'Account Record',
                                     Home_Type__c = 'SF',                                                    
                                     PersonEmail = 'testAcc@ymail.com',
                                     Primary_Shipping_State__c = 'AZ',
                                     Primary_Shipping_County__c = 'Test County',
                                     Zip__c = '27007',
                                     Primary_Shipping_City__c = 'Test City',
                                     Street__c = 'Test Street',
                                     Primary_Shipping_Country__c = 'US',
                                     Sales_Price__c = 1000,
                                     Branch__c = 'AZ-Test Branch');
        insert newAcc;
        Address__c add = new Address__c(
        	Zip_Code__c = '27007', 
            Street__c = 'Test Street'
        );
        insert add;
    }
    
    public static testmethod void test(){
        List<Account> accounts = [Select Id from Account];
        Test.startTest();
        User_Address__c us = new User_Address__c(
        	UserAccount__c = accounts[0].Id
        );
        insert us;
        Test.stopTest();
    }

}