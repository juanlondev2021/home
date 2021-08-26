/*********************************************************
Description : This test class created for JSON2Apex and docusign envelop sending class.
**********************************************************/
@isTest
Private class Test_JSON2Apex
{
  //Creating Dummy response method by creating instance for a class.
  static testmethod void callJson2Apex()
  {
    JSON2Apex newJson = new JSON2Apex();
    JSON2Apex.parse('{"envelopeId": "ffeb728c-4c49-4281-8427-39ca2fccedd4"}');
                        
  }
  //Test method for docusign authorization and envelope sending.
  static testmethod void AuthCalloutvf()
  {

                Account acc = new Account();
                acc.name = 'testAccount';  
                acc.Primary_Billing_City__c='Sunnyvale';    
                acc.Primary_Billing_Country__c='US';
                acc.Primary_Billing_State__c='CA';
                acc.Primary_Billing_Street__c='260 N Mathilda Ave';
                acc.Primary_Billing_Zip_Code__c='94086'; 
                acc.branch__c = 'CA-San_Jose';   
                acc.Phone = '1234567891';
                insert acc;
           
                Contact con = new Contact();
                con.LastName = 'test';
                con.email = 'test@gmail.com';
                con.accountId = acc.id;
                insert con;
                
                List<Contact> conList = new List<Contact>();
                conList.add(con);
         
                DocusignCredentials__c doccredentials = new DocusignCredentials__c();
                doccredentials.Name = 'DousignCredential1';
                doccredentials.AccountId__c = '74b3rf20-0b4d-409a-a253-f1ecd0b9d57f';
                doccredentials.IntegratorKey__c = 'MSTS-c136b3a7-7d95-4e6c-b7f5-0e00759b0756';
                doccredentials.TemplateID__c = 'DE066A64-5B0F-4EE7-9FB6-D36E17046494';
                doccredentials.UserName__c = '52893f7f-481b-404c-99b0-ad5cb336e01d';
                insert doccredentials;
                
                ApexPages.StandardController ctrl = new ApexPages.StandardController(acc);
                AuthCalloutvf authCtrl = new AuthCalloutvf(ctrl);
                authCtrl.senddoc();
                
                AuthCallout authcallctrl = new AuthCallout();
                Test.startTest();
                authcallctrl.basicAuthCallout(conList);
                  RestRequest req = new RestRequest();

                  RestResponse res = new RestResponse();
                
                  req.requestURI = '/services/apexrest/Customer/';  //Request URL
                
                  req.httpMethod = 'POST';
                
                  RestContext.request = req;
                  RestContext.response= res;
                Test_JSON2Apex.callJson2Apex();
                Test.stopTest();
  
  }
  
}