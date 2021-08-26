/**
* Diaco
* @author 			Giovanni Ulloque href=<Gulloque@diaco.us>
* Project:			Script to update Billing Address from Address. 
* Description:		class responsible to update Billing Address.
* Test:             AccountBillingAddressBatchTest
*
* Changes (Version)
* -------------------------------------
*			No.		Date			Author						Description
*			-----	----------		--------------------		---------------
* @version	1.0		31/10/2020	    Giovanni Ulloque (GU)		Initial implementation of the class.
**/

@isTest
public class AccountBillingAddressBatchTest {
    @testSetup 
    static void setup() {
        List<Account> accounts = new List<Account>();
        // insert 10 accounts
        for (Integer i = 0; i<10; i++) {
            accounts.add(new Account(name='Account ' + i, 
                Street__c = '', City__c = '', State__c = '', Zip__c = ''));
        }
        insert accounts;
    }
    
    static testmethod void test() {        
        Test.startTest();
        Id batchId = Database.executeBatch(new AccountBillingAddressBatch(10));
        Test.stopTest();
        // after the testing stops, assert records were updated properly
    }

}