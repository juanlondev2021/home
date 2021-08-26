@isTest
private class diacoKnifeFunc_tst {
    static testmethod void tets() {
        Id recordTypeIdBAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Accounts').getRecordTypeId();
        Test.startTest();
            diacoKnifeFunc.getPicklistValues('Account', new List<String>{'Branch__c'} ); 
            diacoKnifeFunc.getDataRecordType('Account'); 

            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('getPicklistValueByRecordtype');
            mock.setStatusCode(200);
            mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
            Test.setMock(HttpCalloutMock.class, mock);

            diacoKnifeFunc.getPicklistValueByRecordtype('Account', 'Branch__c', new List<Id>{recordTypeIdBAcc});
            diacoKnifeFunc.getPicklistValueByRecordtype('Account', recordTypeIdBAcc, new List<String>{'Branch__c'});

            diacoKnifeFunc.getRecordTypeIdbyName('Account', 'Business Accounts');
            diacoKnifeFunc.getRecordTypeNameById('Account', recordTypeIdBAcc);

            diacoKnifeFunc.sendEmail
            (
                new String[] {'Test@email.com'},
                'Test Subject',
                'Test Body'
            );

            diacoKnifeFunc.formatMultipickList(new String[]{'test;test2'});

        Test.stopTest();
    }
}