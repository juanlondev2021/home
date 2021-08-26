/**
* Diaco
* @author 			Jorge Andres Martinez Peña href=<Jorgeality29@gmail.com>
* Project:			Contracts
* Description:		class responsible to test the class DiacoCmpContractController COMPLEMENTING DiacoCMPContractControllerTest(which give some kind of issue with event process builder).
*					
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		20/03/2018		Jorge Martinez (JM)		Initial implementation  of the class.
**/
@isTest
public class temporalTestDiacoCMPContractController {
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
    
    static testMethod void test(){
        
        Account Acc = new Account();
        Acc.FirstName = 'Account ';
        Acc.LastName = 'Test';
        Acc.RecordTypeId ='012410000012NOKAA2';
        Acc.Customer_1_DOB__c =  Date.newInstance(2018, 7, 3);
        Acc.Customer_2_DOB__c =  Date.newInstance(2018, 7, 3);
        
        Acc.Customer_1_Drivers_License_Issue_Date__c =  Date.newInstance(2018, 7, 3);
        Acc.Customer_2_Drivers_License_Issue__c =  Date.newInstance(2018, 7, 3);
        
        Acc.Customer_1_Drivers_License_Expiration__c =  Date.newInstance(2018, 7, 3);
        Acc.Customer_2_Drivers_License_Expiration__c =  Date.newInstance(2018, 7, 3);
        
        insert Acc;
        
        Personnel__c per = new Personnel__c();
        per.Name = 'test';
        per.First_Name__c = 'test';
        per.Last_Name__c = 'test';
        per.Kunnect_ID__c = 'none';
        insert per;
        
        docuSignConf__c doc = new docuSignConf__c(
            accountId__c = 'testaccouont', 
            integratorsKey__c = 'TestintegratorsKey', 
            password__c = 'testapassword', 
            userId__c = 'TestuserId'
        ); 
        upsert doc;
        
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Chatter External User'].Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            
            
        );
        
        insert u;
        Home_Services__c hs = new  Home_Services__c();
        hs.Account__c = Acc.Id;
        hs.RecordTypeId = '012410000013G9OAAU';
        hs.Card_Number__c = '123456789';
        hs.CSV__c = '123';
        hs.Method_Of_Payment__c = 'Credit Card';		 
        hs.ApptSetter__c = per.Id;
        hs.Exp_Date__c = '7/24';
        //hs.Sales_Rep__c = u.Id;
        insert hs;
        
        
        
        Product__c pro = new Product__c();
        pro.Name = 'test';
        pro.Product_Type__c = 'Water';
        pro.active__c = true;
        pro.Service__c = false;
        insert pro;
        
        Product__c pro2 = new Product__c();
        pro2.Name = 'test';
        pro2.Product_Type__c = 'Water';
        pro2.Service__c = true; 
        pro2.active__c = true;
        insert pro2;
        
        List<Product__c> prods =  new  List<Product__c>();
        prods.add(pro);
        prods.add(pro2);
      
        
        Line_Item__c li = new Line_Item__c();
        li.Name = 'test';
        li.Home_Service__c = hs.Id;
        li.Product__c = pro.Id;
        li.Active__c = false;
        insert li;
        
        Line_Item__c li2 = new Line_Item__c();
        li2.Name = 'test';
        li2.Home_Service__c = hs.Id;
        li2.Product__c = pro2.Id;
        li2.Active__c = True;
        insert li2;
        
        Line_Item__c li3 = new Line_Item__c();
        li3.Name = 'test';
        li3.Home_Service__c = hs.Id;
        li3.Product__c = pro2.Id;
        li3.Active__c = True;
        insert li3;
        
        Line_Item__c li4 = new Line_Item__c();
        li4.Name = 'test';
        li4.Home_Service__c = hs.Id;
        li4.Product__c = pro2.Id;
        li4.Active__c = True;
        insert li4;
        Line_Item__c li5 = new Line_Item__c();
        li5.Name = 'test';
        li5.Home_Service__c = hs.Id;
        li5.Product__c = pro2.Id;
        li5.Active__c = false;
        insert li5;
        
        List<Line_Item__c> prodsli =  new  List<Line_Item__c>();
        prodsli.add(li);
        prodsli.add(li2);
        prodsli.add(li3);
        List<Line_Item__c> prodsli1 =  new  List<Line_Item__c>();
        hs.Home_Services_Status__c = 'Closed Won';
        update hs;
        Test.startTest();
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        DiacoCmpContractController.getDataCustomerOne(hs.Id);
        DiacoCmpContractController.getDataHomeServicePricing(hs.Id);
        DiacoCmpContractController.getDataHomeService(hs.Id);
        DiacoCmpContractController.getDataHomeServiceAgreement(hs.Id);
        DiacoCmpContractController.getRecordType(hs.Id);
        DiacoCmpContractController.getDataCustomerTwo(hs.Id);
        DiacoCmpContractController.getStates();
        DiacoCmpContractController.saveAccount(Acc);
        DiacoCmpContractController.getDataLocationAndPayments(hs.Id);
        DiacoCmpContractController.getInstallationDate(hs.Id);
        DiacoCmpContractController.saveHomeService(hs);
        DiacoCmpContractController.saveHomeService2(hs);
        DiacoCmpContractController.saveHomeService3(hs);
        DiacoCmpContractController.getSalesReps();
        DiacoCmpContractController.getSalesRepsName(u.Id);
        DiacoCmpContractController.products('jorge andres martinez - Water Treatment Installation');
        DiacoCmpContractController.ListProducService(hs.Id, 1);
        DiacoCmpContractController.ListProducService(hs.Id, 2);
        //DiacoCmpContractController.LineItemsServiceList(prods, hs.Id);
        //DiacoCmpContractController.LineItemsServiceList2(prods, hs.Id);
        DiacoCmpContractController.ProductListToSelect(hs.Id, 1);
        DiacoCmpContractController.ProductListToSelect(hs.Id, 2);
        DiacoCmpContractController.getProduct(pro.Id);
        DiacoCmpContractController.SavelineItemServices(prodsli);
        DiacoCmpContractController.SaveRecordsLineItems(prodsli);
        prodsli1.add(li4);
        prodsli1.add(li5);
        DiacoCmpContractController.changeDate(prodsli1);
        DiacoCmpContractController.getlineItems(hs.Id, 1);
        DiacoCmpContractController.getlineItems(hs.Id, 2);
        DiacoCmpContractController.getDataHomeOwner(hs.Id);
        DiacoCmpContractController.saveHomeOwner(hs, Acc);
        DiacoCmpContractController.getPaymentMethods(hs.Id);
        DiacoCmpContractController.sendToDocusign(hs.Id, 1);
        DiacoCmpContractController.updateDates(hs.Id);
        DiacoCmpContractController.getRecordTypes();
        String ids = Acc.Id;
        DiacoCmpContractController.getHsFromAccount(ids);
        //DiacoCmpContractController.saveHomeServiceInfo(hs);
        DiacoCmpContractController.getHsAccountFromAnotherObject(hs.Id);
        Test.stopTest();
        
        
    }
}