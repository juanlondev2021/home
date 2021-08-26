/***************************************************
* Created By: MSTSolutions
* Test class for nuHome_Inventory_Product
* Modified By: Ganesh
* Modified on:
* Description: Updated the test class as per best practices.
* *************************************************/
@isTest(seealldata=false)
private class nuHome_Inventory_Product_Test {
    static testmethod void testdts(){
        test.startTest();
        //insert Door_Tag_Script__c record
        Door_Tag_Script__c doorTagScript = TestNuHomeStatisticControlUtil.insertDoorTagv2();
        system.assertNotEquals(null, doorTagScript.id);
        //update Door_Tag_Script__c record
        doorTagScript.Home_Remodeling__c = 'Verified Lead';
        doorTagScript.Kitchen_Remodeling__c = 'Verified Lead';
        doorTagScript.Bathroom_Remodeling__c = 'Verified Lead';
        doorTagScript.Granite_Marble__c = 'Verified Lead';
        doorTagScript.Windows_Doors__c = 'Verified Lead';
        doorTagScript.Flooring__c = 'Verified Lead';
        doorTagScript.Gutters__c = 'Verified Lead';
        doorTagScript.Roofer__c = 'Verified Lead';
        doorTagScript.Siding__c = 'Verified Lead';
        doorTagScript.PaintingInside__c = True;
        doorTagScript.Create_Task_Update__c = 'Email Sent';
        Recursive.isExecute = True;
        update doorTagScript;
        test.stopTest();
    }
}