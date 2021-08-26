@isTest
private  class GlobalTest {
    static testMethod void testMethod1(){
        ZipCodeMatch__c cs = new ZipCodeMatch__c();
        cs.Carrier_Code__c = 'San Antonio-TX';
        cs.name = '72832';
        cs.MSA__c = 'San Antonio-New Braunfels TX';
        cs.Region_Code__c = 'sc1';
        cs.Zip_Code__c = '72832';
        try{
            insert cs;
        }
        catch(exception e){
            system.assert(false,'Failed to insert the custom setting record. '+e.getMessage());
        }
        //
        String recTypeId = [Select id from recordType where developerName='PersonAccount' limit 1].Id;
        Account acc = new Account();
        acc.lastname = 'TestAccount';
        acc.recordTypeId = recTypeId;
        acc.Phone = '1222222211';
        acc.Primary_Shipping_Zip_Code__c = '72832';
        try{
            insert acc;
        }
        catch(exception e){
            system.assert(false,'Failed to insert the Account record. '+e.getMessage());
        }
        accountZipCodeMapper_Batch obj = new accountZipCodeMapper_Batch();
        database.executeBatch(obj);
    } 
    static testMethod void testMethod2(){
        GlobalTriggerController.DeliveryObjectTriggerVariable = true;
        Driver__c dr = new Driver__c();
        dr.name = 'Invalid Driver';
        dr.First_Name__c = 'Test';
        dr.Last_Name__c = 'Test';
        dr.ID__c = 'Invalid Driver';
        dr.Phone__c = '8188003959';
        dr.Branch__c = 'Austin';
        dr.Driver_Street__c = 'TesteStreet';
        dr.Driver_City__c = 'testCity';
        dr.Driver_State__c = 'CA';
        dr.Driver_Country__c = 'US';
        dr.Driver_Zip_Code__c = '99999';
        try{
            insert dr;
        }
        catch(exception e){
            system.assert(false,'failed to insert the test driver.');
        }
        String recTypeId = [Select id from recordType where developerName='PersonAccount' limit 1].Id;
        Account acc = new Account();
        acc.lastname = 'TestAccount';
        acc.recordTypeId = recTypeId;
        acc.Phone = '1234567892';
        acc.Primary_Shipping_Zip_Code__c = '72832';
        try{
            insert acc;
        }
        catch(exception e){
            system.assert(false,'Failed to insert the Account record. '+e.getMessage());
        }
        Gift_Card_Orders__c gc = new Gift_Card_Orders__c();
        gc.name = '222222222';
        try{
            insert gc;
        }
        catch(exception e){
            system.assert(false,'Failed to insert the gift card record. '+e.getMessage());
        }
        Driver__c driver = new Driver__c();
        driver.name = 'testDriver';
        driver.First_Name__c = 'testFirstName';
        driver.Last_Name__c = 'testLastName';
        driver.Phone__c = '8888888888';
        driver.ID__c = 'abc12345';
        driver.Driver_Street__c = 'testStreet';
        driver.Driver_City__c = 'SanJose';
        driver.Driver_State__c = 'CA';
        driver.Driver_Country__c = 'US';
        driver.Driver_Zip_Code__c = '94087';
        try{
            insert driver;
        }
        catch(exception e){
            system.assert(false,'Failed to insert the  driver record. '+e.getMessage());
        }
        Delivery_Object__c delObj = new Delivery_Object__c();
        delObj.name='testDO';
        delObj.Parent_Gift_Card_Order__c = gc.Id;
        delObj.Driver__c = driver.Id;
        delObj.Person_Account__c = acc.Id;
        delObj.Scan_Code__c = '2222222222';
        try{
            insert delObj;
        }
        catch(exception e){
            system.assert(false,'Failed to insert the delivery object record. '+e.getMessage());
        }
        acc.phone = '8188003000';
        acc.personmobilephone = '8188003001';
        try{
            update acc;
        }
        catch(exception e){
            system.assert(false,'Failed to insert the Account record. '+e.getMessage());
        }
    }
    
   /* static testMethod void testMethod3(){
        OB_Campaign_Member__c obcm = new OB_Campaign_Member__c();
        obcm.AccountName__c = '00121000003wXde';
        obcm.OB_Campaign__c = 'a2a210000004LII';
    try{
            insert obcm;
        }
        catch(exception e){
            system.assert(false,'Failed to insert the OB Campaign Member record. '+e.getMessage());
        }
        } */
}