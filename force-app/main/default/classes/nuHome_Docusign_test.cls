/*********************************************************
Creted By: MST
Description : Test class for nuHome_Docusign webservice class.

Modified By: Ganesh
Modified on:
Description: Updated the test class as per best practices.
**********************************************************/
@isTest(seealldata=false)
private class nuHome_Docusign_test {
    @testsetup static void createtestdata(){
        
        DocusignCredentials__c cred = new DocusignCredentials__c();
        cred.Name = 'DousignCredential1';
        cred.UserName__c = '52898f7f-481b-404c-99b0-ad5cb336e01d';
        cred.Password__c = 'metasoft100';
        cred.IntegratorKey__c = 'MSTS-c1c6b3a7-7d95-4e6c-b7f5-0e00759b0756';
        cred.TemplateID__c = 'DE066A64-9B0F-4EE7-9FB6-D36E17046494';
        //Creating custom settings with docusign credentials.
        insert cred;
    }
    
    //Calling void callout method.
    static testMethod void voidCallout(){
        DocusignCredentials__c docred = [select id,Name,userName__c,Password__c,IntegratorKey__c,TemplateID__c from DocusignCredentials__c limit 1];
        //Calling docusign method.
        test.startTest();
        nuHome_Docusign.voidMethod('test');
        test.stopTest();
    }
}