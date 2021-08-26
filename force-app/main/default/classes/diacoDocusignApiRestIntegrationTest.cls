/**
* Diaco
* @author 			Jorge Martinez href=<jorgeality29@gmail.com>
* Project:			SalesRabbit Integration
* Description:		Class responsible for testing diacoDocusignApiRestIntegration class
*
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		11/01/2018		Jorge Martinez (JM)		Initial implementation of the class.
**/
@isTest
public class diacoDocusignApiRestIntegrationTest {
    @isTest static void Test() {
        Account Acc = new Account();
        Acc.FirstName = 'Account';
        Acc.LastName = 'Test';
        Acc.RecordTypeId ='012410000012NOKAA2';
        insert Acc;
        
        Personnel__c per = new Personnel__c();
        per.Name = 'test';
        per.First_Name__c = 'test';
        per.Last_Name__c = 'test';
        per.Kunnect_ID__c = 'none';
        insert per;
        
        Home_Services__c hs = new  Home_Services__c();
        hs.Name = 'test test - Water Treatment Sales';
        hs.Account__c = Acc.Id;
        hs.RecordTypeId = '012410000013G9NAAU';
        hs.Method_Of_Payment__c = 'Credit Card';		 
        hs.ApptSetter__c = per.Id;
        hs.Exp_Date__c = '7/24';
        hs.sendDate__c = Date.today();
        hs.envelopeId__c = '7d65ea43-8d7e-4ce4-a6d3-a523dbd7e155';
        insert hs;
        
        docuSignConf__c doc = new docuSignConf__c(
            account__c = '1234567', 
            integratorsKey__c = 'TestintegratorsKey', 
            password__c = 'testapassword', 
            userId__c = 'TestuserId',
            tokenPart1__c = '123', tokenPart2__c= '123', tokenPart3__c= '123'
        ); 
        upsert doc;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DiacoDocuSignCalloutMock());
        diacoDocusignApiRestIntegration ddari = new diacoDocusignApiRestIntegration();
        HttpResponse tokens = ddari.generatorToken();
        diacoTokenFromDocusign token = ddari.getResponseAsObject(tokens);
        
        HttpResponse  response = ddari.gettingDocumentAsPDF(hs.envelopeId__c, token.access_token);
        ddari.saveContract(hs, response);
        HttpResponse httpr =  ddari.gettingEnvelopesStatus(hs.envelopeId__c, token.access_token);
        diacoDocusignEnvelopes envelope = ddari.getEnvelopesAsObject(httpr);
        ddari.getRefreshToken(token.refresh_token);
        Test.stopTest();
        
    }
}