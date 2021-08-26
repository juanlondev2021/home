/*
--------------------------
 * Modified By: Ganesh
 * Modified on:
 * Description: Test class for nuHome_Verbal_Consent_AC Controller.
  				Updated the test class as per best practices. 
-----------------------------
*/
@isTest(seealldata=false)
private class nuHome_Verbal_Consent_AC_Test {
    /*
	 *Created By: MST
	 *Description : Test class for nuHome_Verbal_Consent_AC Controller.
     * */
     @testsetup static void createtestdata(){
         //Insert list of Accounts
        String accRecTypeId = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();         
    	List<Account> collAcc = new List<Account>();
		Account accIns1 = new Account(LastName = 'Test1',Phone = '9876543210',RecordTypeId = accRecTypeId);
        collAcc.add(accIns1);
    	Account accIns2 = new Account(LastName = 'Test2',Phone = '9876543210',RecordTypeId = accRecTypeId,Respond_Date__c = Date.valueof('2016-03-30'));
        collAcc.add(accIns2);
    	Account accIns3 = new Account(LastName = 'Test3',Phone = '9876543210',RecordTypeId = accRecTypeId,Respond_Date__c = Date.valueof('2016-03-30'),Verbal_Consent__c = 'Yes');
		collAcc.add(accIns3);
    	Account accIns4 = new Account(LastName = 'Test4',Phone = '9876543210',RecordTypeId = accRecTypeId,Respond_Date__c = Date.valueof('2016-03-30'),Verbal_Consent__c = 'No');
		collAcc.add(accIns4);
    	Account accIns5 = new Account(LastName = 'Test5',Phone = '9876543210',RecordTypeId = accRecTypeId,Respond_Date__c = Date.valueof('2016-03-30'),Verbal_Consent__c = 'Email Only');
        collAcc.add(accIns5);
    	Account accIns6 = new Account(LastName = 'Test6',Phone = '9876543210',RecordTypeId = accRecTypeId,Respond_Date__c = Date.valueof('2016-03-30'),Verbal_Consent__c = 'Phone Only');
		collAcc.add(accIns6);
    	Account accIns7 = new Account(LastName = 'Test7',Phone = '9876543210',RecordTypeId = accRecTypeId,Respond_Date__c = Date.valueof('2016-03-30'),PersonDoNotCall = True);
		collAcc.add(accIns7);
    	Account accIns8 = new Account(LastName = 'Test8',Phone = '9876543210',RecordTypeId = accRecTypeId,Respond_Date__c = Date.valueof('2016-03-30'),PersonHasOptedOutOfEmail = True);
		collAcc.add(accIns8);
         
		Insert collAcc;
		system.assertEquals(8,[select count() from Account]);
    } 
    static testmethod void unittest(){
        test.startTest();
        List<Account> acntList = [select id,Respond_Date__c,Verbal_Consent__c,PersonHasOptedOutOfEmail,PersonDoNotCall from Account];
        nuHome_Verbal_Recursive_AC recr = new nuHome_Verbal_Recursive_AC();
        nuHome_Verbal_Consent_AC.chooseVerbalConsent(acntList);
        test.stopTest();
    }
	
}