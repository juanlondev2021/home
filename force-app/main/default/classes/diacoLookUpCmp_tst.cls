@istest
public with sharing class diacoLookUpCmp_tst {
    @IsTest
    static void test(){
        
        List<RecordType> rtypesAccount  = [SELECT Name, Id FROM RecordType WHERE sObjectType='Account' and isActive=true];

        Map<String,Id> accountRecordTypes = new Map<String,String>{};
        for ( RecordType rt: rtypesAccount ) {

            accountRecordTypes.put(rt.Name,rt.Id);
        }
        
        Account acc = new Account();
        acc.Name = 'test';           
        acc.RecordTypeId = accountRecordTypes.get('Business Accounts'); 
        insert acc;
        
        Test.startTest();

        diacoLookUpCmp_ctr.fetchLookUpValues('test', 'Account', 'Garage_Operation__c = true');
        diacoLookUpCmp_ctr.fetchLookUpValues('test', 'Account', null);

        diacoLookUpCmp_ctr.fetchLookUpValue(acc.Id, 'Account');

        Test.stopTest();
        
    }
}