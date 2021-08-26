/*
--------------------------
 * Modified By: Ganesh
 * Modified on:
 * Description: This is a test class for TCPA_AT trigger.
 				Updated the test class as per best practices. 
-----------------------------
*/
@isTest(seealldata=false)
private class TCPA_Trigger_AT_Test {
    /*
    static testmethod void verbalCreation(){
        
        test.startTest();
        TCPA__c  currVerbal = new TCPA__c();
        currVerbal.Active__c = True;
        currVerbal.Description__c = 'This is test Description';
        currVerbal.Place_Holder__c = 'nuHome nuCard SPEC';
        insert currVerbal ;
        system.assertNotEquals(null, currVerbal.id);
        
        TCPA__c  currVerbal1 = new TCPA__c ();
        currVerbal1.Active__c = True;
        currVerbal1.Description__c = 'This is test Description';
        currVerbal1.Place_Holder__c = 'nuHome nuCard SPEC';
        try{
            insert currVerbal1 ;
        }
        Catch(DMLException e){
            system.debug('Exception msg #####################' + e);
            system.assertEquals('You can not create two active record for same place holder - nuHome nuCard SPEC', e.getDMLMessage(0));
        }
        
        TCPA__c currVerbal3 = new TCPA__c();
        currVerbal3.Active__c = True;
        currVerbal3.Description__c = 'This is test Description';
        currVerbal3.Place_Holder__c = 'nuHome Door Tag Script';
        insert currVerbal3;
        system.assertNotEquals(null, currVerbal3.id);
        
        currVerbal3.Place_Holder__c = 'nuHome nuCard CPL';
        update currVerbal3;
        
        currVerbal3.Active__c = False;
        currVerbal3.Description__c = 'This is test duplicate Description';
        update currVerbal3;
        test.stopTest();
    }*/
}