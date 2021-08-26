/*
--------------------------
 * Modified By: Ganesh
 * Modified on:
 * Description: This test class covers DriverInteractions trigger. Updated the test class as per best practices. 
-----------------------------
*/
@isTest(seeAllData = false)
private class DriverInteractions_Test {
    @testsetup static void createtestdata(){
        
        //insert a new driver record
        driver__c recDriver = new driver__C(Name = 'Cheetah Driver',First_Name__c = 'Cheetah',Last_Name__c = 'Driver',
                                            Phone__c = '9999999999',Branch__c = 'AZ-Phoenix_East',Driver_Street__c = '0000',ID__c = '0',
                                            Driver_City__c = '0000',Driver_State__c = 'AZ',Driver_Country__c = 'US',
                                            Driver_Zip_Code__c = '0000', active__c=true);
        insert recDriver;
        system.assertNotEquals(null, recDriver.id);  
    }
    //test method    
    static testmethod void testTriggerLogic1() {
        test.startTest();
        //update the user record
        driver__c recDriver=[select id,active__c from driver__c where active__c=true limit 1];
        recDriver.active__c = false;
        update recDriver;
        //update the user record
        driver__c recDriver1=[select id,active__c from driver__c where active__c=false limit 1];
        recDriver1.active__c = true;
        update recDriver1;
        test.stopTest();
    }
}