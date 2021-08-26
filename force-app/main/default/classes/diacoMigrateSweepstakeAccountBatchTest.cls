@isTest
public class diacoMigrateSweepstakeAccountBatchTest {
	@testSetup 
    static void setup() {
        List<Account> accounts = new List<Account>();
        // insert 10 accounts
        for (Integer i=0;i<10;i++) {
            accounts.add(new Account(name='Account '+i, 
                billingcity='New York', billingcountry='USA'));
        }
        insert accounts;
        
        List<webForm__c> WFs = new List<webForm__c>();
        // insert 10 accounts
        for (Integer i=0;i<10;i++) {
            WFs.add(new webForm__c(name='test '+i, 
                Account__c = accounts[i].Id,
                Sweepstake_Date__c= 'S-1',
                Services_Pick__c = 'Solar,Water',
                I_Accept_Terms__c=false,
                Type__c = 'Sweepstake',
             	Sweepstake_In_Date__c=Date.today()));
        }
        insert WFs;
        
    }
    
    static testmethod void test() {        
        Test.startTest();
        diacoMigrateSweepstakeAccountBatch uca = new diacoMigrateSweepstakeAccountBatch(10);
        Id batchId = Database.executeBatch(uca);
        Test.stopTest();
        // after the testing stops, assert records were updated properly
    }
}