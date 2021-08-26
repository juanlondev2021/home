@isTest
public class diacoContractHATest {
    @isTest static void testAll(){
        Account Acc = new Account();
        Acc.FirstName = 'Account ';
        Acc.LastName = 'Test';
        Acc.RecordTypeId ='012410000012NOKAA2';
        Acc.Street__c='test';
        Acc.City__c='test';
        Acc.State__c='AZ';
        Acc.Zip__c='test';
        Acc.Phone = '000000000';
        insert Acc;
        Personnel__c per = new Personnel__c();
        per.Name = 'test';
        per.First_Name__c = 'test';
        per.Last_Name__c = 'test';
        per.Kunnect_ID__c = 'none';
        insert per;
     	Home_Services__c hs = new  Home_Services__c();
        hs.Account__c = Acc.Id;
        hs.RecordTypeId = '012410000013G9KAAU';
        hs.Name='test test test test';
        hs.ApptSetter__c = per.Id;
        insert hs;
        Home_Services__c hs2 = new  Home_Services__c();
        hs2.Account__c = Acc.Id;
        hs2.RecordTypeId = '012410000013G9GAAU';
        hs2.Name='test test test test';
        hs2.ApptSetter__c = per.Id;
        insert hs2;
        Home_Services__c hs3 = new  Home_Services__c();
        hs3.Account__c = Acc.Id;
        hs3.RecordTypeId = '012410000013G9OAAU';
        hs3.Name='test test test test';
        hs3.ApptSetter__c = per.Id;
        insert hs3;
        Home_Services__c hs4 = new  Home_Services__c();
        hs4.Account__c = Acc.Id;
        hs4.RecordTypeId = '012410000013H81AAE';
        hs4.Name='test test test test';
        hs4.ApptSetter__c = per.Id;
        insert hs4;
        docuSignConf__c doc = new docuSignConf__c(
            accountId__c = 'testaccouont', 
            integratorsKey__c = 'TestintegratorsKey', 
            password__c = 'testapassword', 
            userId__c = 'TestuserId'
        ); 
        upsert doc;
        Test.startTest();
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        diacoContractHA.updateDates(hs2.Id);
        diacoContractHA.generateContract(hs2.Id, 'diacoRenderContractAutomation');
        diacoContractHA.sendToDocusign(hs2.Id, 0);
        diacoContractHA.updateDates(hs.Id);
        diacoContractHA.generateContract(hs.Id, 'diacoRenderContractAutomation');
        diacoContractHA.sendToDocusign(hs.Id, 0);
        diacoContractHA.updateDates(hs3.Id);
        diacoContractHA.generateContract(hs3.Id, 'diacoRenderContractAutomation');
       diacoContractHA.getUtilityContractName(hs3.Id);
        diacoContractHA.sendToDocusign(hs3.Id, 1);
        diacoContractHA.updateDates(hs4.Id);
        diacoContractHA.generateContract(hs4.Id, 'diacoRenderContractAutomation');
        diacoContractHA.sendToDocusign(hs4.Id, 1);
        diacoContractHA.newSendToDocusign(hs3.Id);
        diacoContractHA.sendToDocusignWithPreDesignName(hs3.Id,'PreDesignNameTest');
        
        diacoContractHA.howManyEnvelope(hs3.Id);
        diacoContractHA.howManyEnvelopeByPredesignName(hs3.Id,'WaterTest');
        Test.stopTest();
    }
    
     private class WebServiceMockImpl implements WebServiceMock
     {
        public void doInvoke(
            Object stub, Object request, Map<String, Object> response,
            String endpoint, String soapAction, String requestName,
            String responseNS, String responseName, String responseType)
        {
            System.debug(request);
            if(request instanceof DocuSignApi.SendEnvelope_element){
                
                response.put('response_x', new DocuSignApi.SendEnvelopeResponse_element()) ;
                
                return;
            }else if(request instanceof DocuSignApi.CreateEnvelopeFromTemplates_element){
                
                response.put('response_x', new DocuSignApi.CreateEnvelopeFromTemplatesResponse_element());
                
                return;
            }else if(request instanceof DocuSignApi.RequestSenderToken_element){
                
                response.put('response_x', new DocuSignApi.RequestSenderTokenResponse_element());
                
                return;
            }else if(request instanceof DocuSignApi.RequestRecipientToken_element){
                
                response.put('response_x', new DocuSignApi.RequestRecipientTokenResponse_element());
                
                return;
            }else if(request instanceof DocuSignApi.CreateAndSendEnvelope_element){
                
                response.put('response_x', new DocuSignApi.CreateAndSendEnvelopeResponse_element());
                
                return;
            }else if(request instanceof DocuSignApi.CreateEnvelope_element){
                
                response.put('response_x', new DocuSignApi.CreateEnvelopeResponse_element());
                
                return;
            }else if(request instanceof DocuSignApi.CreateEnvelopeFromTemplatesAndForms_element){
                
                response.put('response_x', new DocuSignApi.CreateEnvelopeFromTemplatesAndFormsResponse_element());
                
                return;
            }
               
            
        }
    }

}